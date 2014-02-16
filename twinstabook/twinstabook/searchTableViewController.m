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

@property (strong, nonatomic) NSMutableDictionary *twitterIdsInView;

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
    self.downloadTwitterImage = [[NSNumber alloc] initWithBool:YES];
    
    NSLog(@"viewDidLoad, names count = %ld",[self.names count]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _selectedUsers = [[NSMutableDictionary alloc] init];
    _twitterIdsInView = [[NSMutableDictionary alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSEnumerator *keys = [self.selectedUsers keyEnumerator];
    for (NSString *key in keys)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.selectedUsers objectForKey:key]];
        //[self.groupMembers addObject:@{key: dict}];
        [dict setObject:self.mediaName forKey:@"media"];
        bool userAlreadyInList = false;
        for (NSDictionary *u in self.groupMembers)
        {
            NSString *username = [u objectForKey:@"name"];
            if ([username isEqualToString:[dict objectForKey:@"name"]])
            {
                NSString *media = [u objectForKey:@"media"];
                if ([media isEqualToString:[dict objectForKey:@"media"]])
                {
                    userAlreadyInList = true;
                }
            }
        }

        // dont forget to check if member already exists
        if (!userAlreadyInList)
        {
            [self.groupMembers addObject:dict];
        }
    }
    
    [self.membersTableView reloadData];

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

- (UIImage *)getFacebookImageForUserID:(NSString *)userID
{
    UIImage *image = nil;
    NSString *page = [NSString stringWithFormat:@"%@/%@?fields=picture",kFacebookGraphRoot,userID];
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

//- (void)getTwitterImageForUserID:(NSString *)uid forTableView:(UITableView *)tableView andIP:(NSIndexPath *)indexPath
- (void)getTwitterImageForUserID:(NSString *)uid forCell:(UITableViewCell *)cell
{
    //UIImage *image = [UIImage imageNamed:@"questionMark.png"];
    
    if (![self.twitterIdsInView objectForKey:uid])
    {
        return;
    }
    
    __weak UITableViewCell *weakCell = cell;
    
    [self.database.account requestAccessToAccountsWithType:self.database.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             
             ACAccount *twitterAccount = [self.database selectedTwitterAccount];
             
             if (twitterAccount)
             {
                 NSString *apiString = [NSString stringWithFormat:@"%@/%@/users/show.json", kTwitterAPIRoot, kTwitterAPIVersion];
                 
                 NSURL *request = [NSURL URLWithString:apiString];
                 
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 //[parameters setObject:@"100" forKey:@"count"];
                 //[parameters setObject:@"1" forKey:@"include_entities"];
                 [parameters setObject:uid forKey:@"user_id"];
                 //[parameters setObject:@"1" forKey:@"screen_name"];
                 //[parameters setObject:@"1" forKey:@"skip_status"];
                 
                 SLRequest *friends = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                 friends.account = twitterAccount;
                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          //NSLog(@"%@ result = %@",uid,result);
                          NSString *pictureURLString = [result objectForKey:@"profile_image_url_https"];
                          NSURL *pictureURL = [NSURL URLWithString:pictureURLString];
                          NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:pictureURL];
                          NSHTTPURLResponse *responseCode = nil;

                          NSData *pResponseData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];

                              // set the image
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if ([self.twitterIdsInView objectForKey:uid])
                              {
                                  //NSLog(@"in main queue, setting image");
                                  //UIImage *placeHolderImage = [UIImage imageNamed:@"questionMark.png"];
                                  //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                  weakCell.imageView.image = [UIImage imageWithData:pResponseData];
                                  //weakCell.imageView.image = placeHolderImage;
                                  [self.twitterIdsInView removeObjectForKey:uid];
                              }
                          });
                          
                      }
                      else
                      {
                          NSLog(@"error = %@",[error localizedDescription]);
                      }
                  }];
             }
             
         }
         else
         {
             NSLog(@"twitter access is not granted");
         }
         
     }];

}

- (UIImage *)getInstagramImageForUserID:(NSString *)uid
{
    UIImage *image = [UIImage imageNamed:@"questionMark.png"];

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
    
    if ([self.mediaName isEqualToString:self.database.socialMediaNames[kFacebook]])
    {

        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
    
        [loadImageIntoCellOp addExecutionBlock:^(void)
         {
             UIImage *image = nil;
             image = [self getFacebookImageForUserID:userID];
    
        
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
        
        UIImage *placeHolderImage = [UIImage imageNamed:@"questionMark.png"];
        //[placeHolderImage set
        cell.imageView.image = placeHolderImage;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    
    if ([self.mediaName isEqualToString:self.database.socialMediaNames[kTwitter]])
    {
        [self.twitterIdsInView setObject:self.downloadTwitterImage forKey:userID];
        [self getTwitterImageForUserID:userID forCell:cell];

        //[placeHolderImage set
        UIImage *placeHolderImage = [UIImage imageNamed:@"questionMark.png"];
        cell.imageView.image = placeHolderImage;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
        
    if ([self.mediaName isEqualToString:self.database.socialMediaNames[kInstagram]])
    {
        //image = [self getInstagramImageForUserID:userID];
    }
    //Make sure cell doesn't contain any traces of data from reuse -
    //This would be a good place to assign a placeholder image

    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.names objectAtIndex:indexPath.row];
    NSString *userID = [dict objectForKey:@"id"];
    
    // if object has not been downloaded yet, remove it
    if ([self.twitterIdsInView objectForKey:userID])
    {
        [self.twitterIdsInView removeObjectForKey:userID];
    }
    
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
