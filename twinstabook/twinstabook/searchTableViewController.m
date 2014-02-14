//
//  searchTableViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-03.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "searchTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface searchTableViewController ()

@end

@implementation searchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    NSLog(@"viewDidLoad, names count = %ld",[self.names count]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _selectedUsers = [[NSMutableDictionary alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSEnumerator *keys = [self.selectedUsers keyEnumerator];
    for (NSString *key in keys)
    {
        NSDictionary *dict = [self.selectedUsers objectForKey:key];
        //[self.groupMembers addObject:@{key: dict}];
        [self.groupMembers addObject:dict];
    }
    
    [self.members reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.database.imageLoadingQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getImageForUserID:(NSString *)userID
{
    UIImage *image = nil;
    NSString *http = @"https://graph.facebook.com";
    NSString *page = [NSString stringWithFormat:@"%@/%@?fields=picture",http,userID];
    NSURL *url = [NSURL URLWithString:page];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"Error getting %@, HTTP status code %ld", url, [responseCode statusCode]);
    }
    
    NSError *jsonError;

    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (!jsonError)
    {
        //NSLog(@"responseDict:%@",responseDict);
        NSDictionary *pictureData = [[responseDict objectForKey:@"picture"] objectForKey:@"data"];
        NSString *urlPictureString = [pictureData objectForKey:@"url"];
        //NSLog(@"url:%@",urlPictureString);
        NSURL *urlForPicture = [NSURL URLWithString:urlPictureString];
        NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:urlForPicture];
        
        NSData *pResponseData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];
        image = [UIImage imageWithData:pResponseData];
    }

    return image;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"aliasNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [self.names objectAtIndex:indexPath.row];
    NSString *userID = [dict objectForKey:@"id"];
    NSString *name = [dict objectForKey:@"name"];
    cell.textLabel.text = name;
    
    if ([self.selectedUsers objectForKey:userID])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //cell.imageView.autoresizesSubviews = UIViewAutoresizingNone;
    
    NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
    
    [loadImageIntoCellOp addExecutionBlock:^(void)
    {
        UIImage *image = [self getImageForUserID:userID];
        //Some asynchronous work. Once the image is ready, it will load into view on the main queue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void)
        {
            //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
            if (!weakOp.isCancelled)
            {
                UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
                //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                theCell.imageView.image = image;
                theCell.imageView.contentMode = UIViewContentModeScaleAspectFit;

                [self.database.facebookUidToImageDownloadOperations removeObjectForKey:userID];
            }
        }];
    }];
    
    
    //Save a reference to the operation in an NSMutableDictionary so that it can be cancelled later on
    if (userID)
    {
        [self.database.facebookUidToImageDownloadOperations setObject:loadImageIntoCellOp forKey:userID];
    }
    
    //Add the operation to the designated background queue
    if (loadImageIntoCellOp)
    {
        [self.database.imageLoadingQueue addOperation:loadImageIntoCellOp];
    }
    
    //Make sure cell doesn't contain any traces of data from reuse -
    //This would be a good place to assign a placeholder image
    UIImage *placeHolderImage = [UIImage imageNamed:@"questionMark.png"];
    //[placeHolderImage set
    cell.imageView.image = placeHolderImage;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.names objectAtIndex:indexPath.row];
    NSString *userID = [dict objectForKey:@"id"];
    //Fetch operation that doesn't need executing anymore
    NSBlockOperation *ongoingDownloadOperation = [self.database.facebookUidToImageDownloadOperations objectForKey:userID];
    if (ongoingDownloadOperation)
    {
        //Cancel operation and remove from dictionary
        [ongoingDownloadOperation cancel];
        [self.database.facebookUidToImageDownloadOperations removeObjectForKey:userID];
    }
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger row = indexPath.row;
    NSDictionary *dict = [self.names objectAtIndex:row];
    NSString *userID = [dict objectForKey:@"id"];
    NSString *name = [dict objectForKey:@"name"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([self.selectedUsers objectForKey:userID])
    {
        // objected is already selected, so we deselect it
        [self.selectedUsers removeObjectForKey:userID];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        UIImage *image = cell.imageView.image;
        NSData *imageData = UIImagePNGRepresentation(image);
        NSDictionary *dict = @{@"name" : name,
                               @"uid" : userID,
                               @"image" : imageData,
                                @"type" : self.mediaName};

        [self.selectedUsers setObject:dict forKey:userID];

        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
}

- (void)readURLAsync:(NSString *)urlString
{
    if (urlString)
    {
        NSLog(@"read async: %@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        [conn start];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didRecieveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"didFinishLoading");
    
}

@end
