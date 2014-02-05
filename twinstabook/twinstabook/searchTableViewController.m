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

//@property (strong, nonatomic) NSMutableArray *imageCache;

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
    //self.imageCache = [[NSMutableArray alloc] initWithCapacity:[self.names count]];
    //NSLog(@"imageCache count = %ld",[self.imageCache count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)setImageCache:(NSMutableArray *)imageCache
{
    _imageCache = imageCache;
    [self.tableView reloadData];
}
*/

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
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [self.names objectAtIndex:indexPath.row];
    NSString *name = [dict objectForKey:@"name"];
    NSString *userID = [dict objectForKey:@"id"];
    //UIImage *img = [self getImageForUserID:userID andIndex:indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //cell.imageView.image = nil;
    cell.textLabel.text = name;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self getImageForUserID:userID];
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
            currentCell.imageView.image = image;
        });
    });
    //[dict objectForKey:@"name"]UIImage *img = [self getImageForUserID:userID];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    NSLog(@"didSelect");
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
