//
//  searchGroupMembersViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "searchGroupMembersViewController.h"
#import "UserObject.h"

@interface searchGroupMembersViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *uidToImageDownloadOperations;
@property (strong, nonatomic) NSOperationQueue *imageLoadingQueue;

@property (strong, nonatomic) NSMutableArray *tableViewObjects;
@property (strong, nonatomic) NSMutableArray *searchObjects;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
@property (strong, nonatomic) NSMutableDictionary *userToIndexPath;

@end

@implementation searchGroupMembersViewController


- (NSMutableArray *)searchArray:(NSMutableArray *)ar with:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        return ar;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@",searchText];

    for (UserObject *user in ar)
    {
        if ([user.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [result addObject:user];
        }
    }

    return result;
}

- (void)addObjectToTable:(UserObject *)obj
{
    //NSLog(@"setting tableViewObjects, updating tableView");
    // make sure we only update the table view on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableViewObjects addObject:obj];
        [self.tableView reloadData];
    });
}

- (void)removeObjectFromTable:(NSInteger)i
{
    //NSLog(@"setting tableViewObjects, updating tableView");
    // make sure we only update the table view on the main queue
    /*
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    [tableView reloadData];
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableViewObjects removeObjectAtIndex:i];
        [self.tableView reloadData];
    });
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    self.tableViewObjects = [[NSMutableArray alloc] init];
    [self searchWithText:@""];
    
    _searchObjects = [[NSMutableArray alloc] init];
    _userToIndexPath = [[NSMutableDictionary alloc] init];
    _uidToImageDownloadOperations = [[NSMutableDictionary alloc] init];
    _imageCache = [[NSMutableDictionary alloc] init];
    _imageLoadingQueue = [[NSOperationQueue alloc] init];
    [_imageLoadingQueue setName:@"imageLoadingQueue"];
    
    // if twitter

    self.tableViewObjects = [self searchArray:self.database.twitterFriends with:@""];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([tableView isEqual:self.tableView])
    {
        return [self.tableViewObjects count];
    }
    else
    {
        // search?
        return [self.searchObjects count];
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView != tableView)
    {
        NSLog(@"this is not tableview!!!");
    }
    
    static NSString *CellIdentifier = @"aliasNameCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UserObject *user = nil;
    if ([tableView isEqual:self.tableView])
    {
        user = [self.tableViewObjects objectAtIndex:indexPath.row];
        [self.userToIndexPath setObject:indexPath forKey:user.uid];
    }
    else
    {
        user = [self.searchObjects objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = user.name;
    cell.imageView.image = [UIImage imageNamed:@"questionMark.png"];

    // no image data available so set the image to download and put a
    // question mark there meanwhile
    switch (self.database.selectedMediaNameIndex)
    {
        case kFacebook:
            //[self facebookSearch:searchText];
            break;
                
        case kTwitter:
            [self downloadTwitterImageForUser:user andCell:cell];
            break;
                
        case kInstagram:
            //[self instagramSearch:searchText];
            break;
                
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    UserObject *user = [self.tableViewObjects objectAtIndex:indexPath.row];
    [self.userToIndexPath removeObjectForKey:user.uid];
    //Fetch operation that doesn't need executing anymore
    NSBlockOperation *ongoingDownloadOperation = [self.uidToImageDownloadOperations objectForKey:user.uid];
    if (ongoingDownloadOperation)
    {
        //Cancel operation and remove from dictionary
        [ongoingDownloadOperation cancel];
        [self.uidToImageDownloadOperations removeObjectForKey:user.uid];
    }

}

- (void)downloadImageForUser:(UserObject *)user andTV:(UITableView *)tv indexPath:(NSIndexPath *)ip
{
    
    // first check if the image exists in the cache
    NSData *imageData = [self.imageCache objectForKey:user.uid];
    if (imageData)
    {
        NSLog(@"using imageData for uid = %@",user.uid);
        UITableViewCell *cell = [tv cellForRowAtIndexPath:ip];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    else
    {
        // otherwise download it
        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
        
        [loadImageIntoCellOp addExecutionBlock:^(void)
         {
             UIImage *image = nil;
             
             // get the image here
             //image = [self getFacebookImageForUserID:userID];
             
             //Some asynchronous work. Once the image is ready, it will load into view on the main queue
             [[NSOperationQueue mainQueue] addOperationWithBlock:^(void)
              {
                  //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
                  if (!weakOp.isCancelled)
                  {
                      UITableViewCell *theCell = [tv cellForRowAtIndexPath:ip];
                      
                      if (image)
                      {
                          theCell.imageView.image = image;
                          NSData *imageData = UIImagePNGRepresentation(image);
                          [self.imageCache setObject:imageData forKey:user.uid];
                          //user.imageData = imageData;
                      }
                      
                      [self.uidToImageDownloadOperations removeObjectForKey:user.uid];
                  }
              }];
         }];
        
        //Save a reference to the operation in an NSMutableDictionary so that it can be cancelled later on
        if (user.uid)
        {
            [self.uidToImageDownloadOperations setObject:loadImageIntoCellOp forKey:user.uid];
        }
        
        //Add the operation to the designated background queue
        if (loadImageIntoCellOp)
        {
            [self.imageLoadingQueue addOperation:loadImageIntoCellOp];
        }
    }
    
}

//- (void)downloadTwitterImageForUser:(UserObject *)user  andTV:(UITableView *)tv indexPath:(NSIndexPath *)ip
- (void)downloadTwitterImageForUser:(UserObject *)user andCell:(UITableViewCell *)cell
{

    if ([self.imageCache objectForKey:user.uid])
    {
        //UITableViewCell *cell = [tv cellForRowAtIndexPath:ip];
        cell.imageView.image = [UIImage imageWithData:[self.imageCache objectForKey:user.uid]];
        return;
    }
    
    __weak UITableViewCell *weakCell = cell;
    
    NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = loadImageIntoCellOp;

    [loadImageIntoCellOp addExecutionBlock:^(void)
     {
         
         [self.database.account requestAccessToAccountsWithType:self.database.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
          {
              if (granted)
              {
                  
                  ACAccount *twitterAccount = [self.database selectedTwitterAccount];
                  
                  if (twitterAccount)
                  {
                      NSString *apiString = [NSString stringWithFormat:@"%@/%@/users/show.json", kTwitterAPIRoot, kTwitterAPIVersion];
                      //NSLog(@"apiString = %@", apiString);
                      
                      NSURL *request = [NSURL URLWithString:apiString];
                      
                      NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                      [parameters setObject:user.uid forKey:@"user_id"];
                      //NSLog(@"parameters = %@",parameters);
                      SLRequest *friends = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                      friends.account = twitterAccount;
                      [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                       {

                           if (!error)
                           {
                               NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

                               NSString *pictureURLString = [result objectForKey:@"profile_image_url"];
                               NSURL *pictureURL = [NSURL URLWithString:pictureURLString];
                               NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:pictureURL];
                               NSHTTPURLResponse *responseCode = nil;
                               
                               NSData *pResponseData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];
                               
                               if (!error)
                               {
                                   // set the image
                                   //Some asynchronous work. Once the image is ready, it will load into view on the main queue
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^(void)
                                    {
                                        //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
                                        if (!weakOp.isCancelled)
                                        {
 
                                            if (pResponseData)
                                            {
                                                [self.imageCache setObject:pResponseData forKey:user.uid];
                                                //user.imageData = pResponseData;
                                                //UITableViewCell *cell = [tv cellForRowAtIndexPath:ip];

                                                weakCell.imageView.image = [UIImage imageWithData:pResponseData];
                                                //NSLog(@"here we go for uid = %@",user.uid);

                                            }
                                            
                                            [self.uidToImageDownloadOperations removeObjectForKey:user.uid];
                                            
                                        }
                                    }];
                               }
                               else
                               {
                                   NSLog(@"error = %@",[error debugDescription]);
                               }
                               
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
         
     }];
    
    //Save a reference to the operation in an NSMutableDictionary so that it can be cancelled later on
    if (user.uid)
    {
        [self.uidToImageDownloadOperations setObject:loadImageIntoCellOp forKey:user.uid];
    }
    
    //Add the operation to the designated background queue
    if (loadImageIntoCellOp)
    {
        [self.imageLoadingQueue addOperation:loadImageIntoCellOp];
    }
    
    NSArray *imageCacheKeys = [self.imageCache allKeys];
    if (imageCacheKeys.count > maxImages)
    {
        [self.imageCache removeObjectForKey:imageCacheKeys[0]];
    }
}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchWithText:(NSString *)searchText
{
    NSInteger length = [searchText length];
    
    if (length >= self.minStringLength)
    {
        switch (self.database.selectedMediaNameIndex)
        {
            case kFacebook:
                [self facebookSearch:searchText];
                break;
                
            case kTwitter:
                [self twitterSearch:searchText];
                break;
                
            case kInstagram:
                [self instagramSearch:searchText];
                break;
                
            default:
                break;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithText:searchText];
}

- (void)facebookSearch:(NSString *)searchString
{
    NSLog(@"facebookSearch");
    switch (self.database.selectedOptionIndex) {

        case 0:
            [self searchFacebookFriends:searchString];
            break;

        case 1:
            [self searchFacebookPages:searchString];
            break;

        case 2:
            [self searchFacebookUsers:searchString];
            break;

        default:
            break;
    }
    
}

- (void)twitterSearch:(NSString *)searchString
{
    self.searchObjects = [self searchArray:self.tableViewObjects with:searchString];
}

- (void)instagramSearch:(NSString *)searchString
{
    NSLog(@"instagramSearch");
}

- (void)searchFacebookFriends:(NSString *)searchString
{
    
}

- (void)searchFacebookPages:(NSString *)searchString
{
    
}

- (void)searchFacebookUsers:(NSString *)searchString
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
