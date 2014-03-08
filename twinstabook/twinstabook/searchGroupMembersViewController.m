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
@property (strong, nonatomic) NSMutableDictionary *selectedObjects;
@property (strong, nonatomic) NSMutableDictionary *uidToImageDownloadOperations;
@property (strong, nonatomic) NSOperationQueue *imageLoadingQueue;

@property (strong, nonatomic) NSMutableArray *tableViewObjects;
@property (strong, nonatomic) NSMutableArray *searchObjects;
@property (strong, nonatomic) NSMutableDictionary *imageCache;

@property (strong, nonatomic) NSString *searchString;

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
    
    _selectedObjects = [[NSMutableDictionary alloc] init];
    _searchObjects = [[NSMutableArray alloc] init];

    _uidToImageDownloadOperations = [[NSMutableDictionary alloc] init];
    _imageCache = [[NSMutableDictionary alloc] init];
    _imageLoadingQueue = [[NSOperationQueue alloc] init];
    [_imageLoadingQueue setName:@"imageLoadingQueue"];
    

    // if facebook
    if ([self.searchFeed isEqualToString:[self.database.socialMediaNames objectAtIndex:kFacebook]])
    {
        if (self.database.selectedOptionIndex == 0)
        {
            self.tableViewObjects = [self searchArray:self.database.facebookFriends with:@""];
        }
    }
    
    // if twitter
    if ([self.searchFeed isEqualToString:[self.database.socialMediaNames objectAtIndex:kTwitter]])
    {
        self.tableViewObjects = [self searchArray:self.database.twitterFriends with:@""];
    }
    
    // if instagram
    if ([self.searchFeed isEqualToString:[self.database.socialMediaNames objectAtIndex:kInstagram]])
    {
        self.tableViewObjects = [self searchArray:self.database.instagramFriends with:@""];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    
    bool reloadTableView = NO;
    
    NSArray *keys = [self.selectedObjects allKeys];
    for (NSString *key in keys)
    {
        UserObject *user = [self.selectedObjects objectForKey:key];
        if (!user.imageData)
        {
            if ([self.imageCache objectForKey:user.uid])
            {
                user.imageData = [self.imageCache objectForKey:user.uid];
            }
        }
        if (![self.groupMembers containsObject:user])
        {
            //NSLog(@"adding member %@",user.name);
            [self.groupMembers addObject:user];
            reloadTableView = YES;
        }
    }
    

    if (reloadTableView)
    {
        [self.membersTableView reloadData];
    }
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
    }
    else
    {
        user = [self.searchObjects objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = user.name;
    cell.imageView.image = [UIImage imageNamed:@"questionMark.png"];

    if ([self.selectedObjects objectForKey:user.uid])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    //if ([self.searchString isEqualToString:self.searchBar.text])
    {
        // no image data available so set the image to download and put a
        // question mark there meanwhile
        switch (self.database.selectedMediaNameIndex)
        {
            case kFacebook:
                [self downloadFacebookImageForUser:user andCell:cell];
                break;
                
            case kTwitter:
                [self downloadImageForUser:user andCell:cell];
                break;
                
            case kInstagram:
                [self downloadImageForUser:user andCell:cell];
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserObject *user = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([tableView isEqual:self.tableView])
    {
        user = [self.tableViewObjects objectAtIndex:indexPath.row];
    }
    else
    {
        user = [self.searchObjects objectAtIndex:indexPath.row];
    }
    
    if ([self.selectedObjects objectForKey:user.uid])
    {
        [self.selectedObjects removeObjectForKey:user.uid];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        [self.selectedObjects setObject:user forKey:user.uid];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserObject *user = nil;
    if ([tableView isEqual:self.tableView])
    {
        if (indexPath.row < self.tableViewObjects.count)
        {
            user = [self.tableViewObjects objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if (indexPath.row < self.searchObjects.count)
        {
            user = [self.searchObjects objectAtIndex:indexPath.row];
        }
    }
    
    if (user)
    {
        //Fetch operation that doesn't need executing anymore
        NSBlockOperation *ongoingDownloadOperation = [self.uidToImageDownloadOperations objectForKey:user.uid];
        if (ongoingDownloadOperation)
        {
            //Cancel operation and remove from dictionary
            [ongoingDownloadOperation cancel];
            [self.uidToImageDownloadOperations removeObjectForKey:user.uid];
        }
    }
}

// this will use the profileImageURL and should work for all services
- (void)downloadImageForUser:(UserObject *)user andCell:(UITableViewCell *)cell
{
    if (user.imageData)
    {
        cell.imageView.image = [UIImage imageWithData:user.imageData];
        return;
    }
    
    // first check if the image exists in the cache
    NSData *imageData = [self.imageCache objectForKey:user.uid];
    if (imageData)
    {
        //NSLog(@"using imageData for uid = %@",user.uid);
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    else
    {
        //NSLog(@"dowloading image for user: %@",user.name);
        // otherwise download it
        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
        
        [loadImageIntoCellOp addExecutionBlock:^(void)
         {
             NSError *error = [[NSError alloc] init];
             NSHTTPURLResponse *responseCode = nil;
             
             // get the image here
             NSURL *url = [NSURL URLWithString:user.profileImageURL];
             NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:url];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
             NSData *pImageData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

             //Some asynchronous work. Once the image is ready, it will load into view on the main queue
             [[NSOperationQueue mainQueue] addOperationWithBlock:^(void)
              {
                  //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
                  if (!weakOp.isCancelled)
                  {
                      //UITableViewCell *theCell = [tv cellForRowAtIndexPath:ip];
                      
                      if (pImageData)
                      {
                          cell.imageView.image = [UIImage imageWithData:pImageData];
                          [self.imageCache setObject:pImageData forKey:user.uid];
                          user.imageData = pImageData;
                          user.updated = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
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
    
    NSArray *imageCacheKeys = [self.imageCache allKeys];
    if (imageCacheKeys.count > maxImages)
    {
        [self.imageCache removeObjectForKey:imageCacheKeys[0]];
    }
    
}

// facebook doesn not provide the image link so we need to get it from the uid
- (void)downloadFacebookImageForUser:(UserObject *)user andCell:(UITableViewCell *)cell
{
    if (user.imageData)
    {
        cell.imageView.image = [UIImage imageWithData:user.imageData];
        return;
    }

    NSData *imageData = [self.imageCache objectForKey:user.uid];
    if (imageData)
    {
        //NSLog(@"using imageData for uid = %@",user.uid);
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    else
    {
        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
        
        [loadImageIntoCellOp addExecutionBlock:^(void)
         {

             NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
             NSString *appID = infoDict[@"FacebookAppID"];
    
             NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
             NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                                        ACFacebookAudienceKey : ACFacebookAudienceFriends,
                                        ACFacebookAppIdKey : appID };
    
    
             [self.database.account requestAccessToAccountsWithType:self.database.facebookAccountType options:options completion:^(BOOL granted, NSError *error)
              {
                  if (granted)
                  {
             
                      NSArray *accounts = [self.database.account accountsWithAccountType:self.database.facebookAccountType];
             
                      // there is only one facebook account
                      ACAccount *facebookAccount = [accounts lastObject];
             
                      if (facebookAccount)
                      {
                          NSString *apiString = [NSString stringWithFormat:@"%@/%@/picture",kFacebookGraphRoot,user.uid];
                          NSURL *request = [NSURL URLWithString:apiString];
                          NSDictionary *param = @{ @"type" : @"square"
                                                   };
                          SLRequest *pictureRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:param];
                          pictureRequest.account = facebookAccount;
                          [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 
                          [pictureRequest performRequestWithHandler:^(NSData *pImageData, NSHTTPURLResponse *urlResponse, NSError *error)
                           {
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                      
                               if (!error)
                               {
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^(void)
                                    {
                                        //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
                                        if (!weakOp.isCancelled)
                                        {
                                            
                                            if (pImageData)
                                            {
                                                cell.imageView.image = [UIImage imageWithData:pImageData];
                                                [self.imageCache setObject:pImageData forKey:user.uid];
                                                user.imageData = pImageData;
                                                user.updated = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                                            }
                                            
                                            [self.uidToImageDownloadOperations removeObjectForKey:user.uid];
                                        }
                                    }];
                          
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
                      NSLog(@"facebook access is not granted");
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
    
    NSArray *imageCacheKeys = [self.imageCache allKeys];
    if (imageCacheKeys.count > maxImages)
    {
        [self.imageCache removeObjectForKey:imageCacheKeys[0]];
    }
    
}


# pragma mark twitter
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
                                                NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                                                [self.imageCache setObject:pResponseData forKey:user.uid];
                                                user.imageData = pResponseData;
                                                user.updated = now;
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
    // need to reload the data if something selected/deselected while in search bar
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // need to reload the data if something selected/deselected while in search bar
    
    if (self.database.selectedMediaNameIndex == kFacebook)
    {
        if (self.database.selectedOptionIndex == 1)
        {

            NSArray *keys = [self.selectedObjects allKeys];
            for (NSString *key in keys)
            {
                UserObject *user = [self.selectedObjects objectForKey:key];
                if (![self.groupMembers containsObject:user])
                {
                    //NSLog(@"adding member %@",user.name);
                    if (![self.tableViewObjects containsObject:user])
                    {
                        [self.tableViewObjects addObject:user];
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    return YES;
//}

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
/*
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"begin editing");
    [self.searchDisplayController setActive:YES animated:NO];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
*/
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchString = searchText;
    [self searchWithText:searchText];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void)facebookSearch:(NSString *)searchString
{
    switch (self.database.selectedOptionIndex) {

        case 0:
            [self searchFacebookFriends:searchString];
            break;

        case 1:
            [self searchFacebook:searchString withType:@"page"];
            break;

        case 2:
            [self searchFacebook:searchString withType:@"user"];
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
    self.searchObjects = [self searchArray:self.tableViewObjects with:searchString];
}

- (void)searchFacebookFriends:(NSString *)searchString
{
    self.searchObjects = [self searchArray:self.tableViewObjects with:searchString];
}

- (void)searchFacebook:(NSString *)searchStringWithSpace withType:(NSString *)typeString
{
    //NSLog(@"search facebook pages");
    //[self.searchActivityIndicator setHidden:NO];
    //[self.searchActivityIndicator startAnimating];
    
    // replace all 'space' with plus sign
    NSString *searchString = [searchStringWithSpace stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDict[@"FacebookAppID"];
    
    NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
    NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookAppIdKey : appID };
    
    [self.database.account requestAccessToAccountsWithType:self.database.facebookAccountType options:options completion:^(BOOL granted, NSError *error)
    {
         if (granted)
         {
             
             NSArray *accounts = [self.database.account accountsWithAccountType:self.database.facebookAccountType];
             
             // there is only one facebook account
             ACAccount *facebookAccount = [accounts lastObject];
             
             // Get the access token, could be used in other scenarios
             //ACAccountCredential *fbCredential = [facebookAccount credential];
             //NSString *accessToken = [fbCredential oauthToken];
             //NSLog(@"Facebook Access Token: %@", accessToken);
             //NSString *searchWithToken = [NSString stringWithFormat:@"%@&access_token=%@",search,accessToken];
             if (facebookAccount)
             {

                 NSString *apiString = [NSString stringWithFormat:@"%@/search",kFacebookGraphRoot];
                 NSURL *request = [NSURL URLWithString:apiString];

                 NSDictionary *param = @{@"q": searchString,
                                         @"type" : typeString
                                         };
                 
                 SLRequest *users = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:param];
                 users.account = facebookAccount;
                 if (![searchStringWithSpace isEqualToString:self.searchString])
                 {
                     // dont do anything if the search text has changed
                     return;
                 }
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 
                 [users performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                      
                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          //self.facebookUsername = [facebookAccount userFullName];
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

                            //NSLog(@"result = %@",result);
                          if (result)
                          {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  // check if the search string hasnt changed before we start to update
                                  if ([searchStringWithSpace isEqualToString:self.searchString])
                                  {
                                      NSArray *dataDict = [result objectForKey:@"data"];
                                  
                                      [self.searchObjects removeAllObjects];

                                      for(int i=0;i<[dataDict count]; i++)
                                      {
                                          UserObject *obj = [[UserObject alloc] init];
                                          obj.name = [dataDict[i] objectForKey:@"name"];
                                          obj.uid = [dataDict[i] objectForKey:@"id"];
                                          obj.type = kFacebook;
                                          obj.updated = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                                          obj.profileImageURL = @"";
                                          [self.searchObjects addObject:obj];
                                      }
                                
                                      [self.searchDisplayController.searchResultsTableView reloadData];
                                  }
                              });
                              //NSDictionary *paging = [result objectForKey:@"paging"];
                          }
                      }
                      else
                      {
                          NSLog(@"error = %@",[error localizedDescription]);
                      }
                  }];
             }

         }
    }];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
