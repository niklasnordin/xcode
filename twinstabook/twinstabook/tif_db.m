//
//  tif_db.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "tif_db.h"
#import "twinstabookFirstViewController.h"

@interface tif_db ()

@end

@implementation tif_db

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.socialMediaNames = @[FACEBOOK, TWITTER, INSTAGRAM];

        self.account = [[ACAccountStore alloc] init];
        self.twitterAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        self.facebookAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

        self.twitterAccounts = [[NSArray alloc] init];
        self.facebookSearchOptions = [[NSArray alloc] initWithObjects:@"friends", @"pages", @"users", nil];
        self.facebookFriends = [[NSMutableArray alloc] init];
        self.twitterFriends = [[NSMutableArray alloc] init];
        
        NSUserDefaults *database = [NSUserDefaults standardUserDefaults];

        // check for user setting exist
        if (!database)
        {
            //database = [[NSMutableDictionary alloc] init];
            
            _useFacebook = false;
            _useTwitter = false;
            _useInstagram = false;
            _selectedMediaNameIndex = 0;
            _selectedFeedIndex = 0;
            
            _groups = [[NSMutableArray alloc] init];
            _groupMembers = [[NSMutableDictionary alloc] init];
            for (NSString *name in self.socialMediaNames)
            {
                NSMutableArray *arry = [[NSMutableArray alloc] init];
                [_groupMembers setObject:arry forKey:name];
            }
            _lastUpdate = [[NSDate alloc] initWithTimeIntervalSinceNow:-10000000];
            _selectedTwitterAccounts = [[NSMutableDictionary alloc] init];
        }
        else
        {
            _useFacebook = [[database objectForKey:USEFACEBOOK] boolValue];
            _useTwitter = [[database objectForKey:USETWITTER] boolValue];
            _useInstagram = [[database objectForKey:USEINSTAGRAM] boolValue];
            _selectedMediaNameIndex = [[database objectForKey:SELECTEDMEDIANAME] intValue];
            _selectedFeedIndex = [[database objectForKey:SELECTEDFEEDINDEX] integerValue];
            
            _groups = [database objectForKey:GROUPS];
            _groupMembers = [database objectForKey:GROUPMEMBERS];
            _selectedTwitterAccounts = [database objectForKey:SELECTEDTWITTERACCOUNTS];
            
            // do not use this yet
            //_lastUpdate = [database objectForKey:LASTUPDATE];

            // need to add this since groups have been added after database was created
            if (!_groups)
            {
                _groups = [[NSMutableArray alloc] init];
            }
            if (!_groupMembers)
            {
                _groupMembers = [[NSMutableDictionary alloc] init];
                for (NSString *name in self.socialMediaNames)
                {
                    NSMutableArray *arry = [[NSMutableArray alloc] init];
                    [_groupMembers setObject:arry forKey:name];
                }
            }
            
            //if (!_lastUpdate)
            {
                _lastUpdate = [[NSDate alloc] initWithTimeIntervalSinceNow:-10000000];
            }
            if (!_selectedTwitterAccounts)
            {
                _selectedTwitterAccounts = [[NSMutableDictionary alloc] init];
            }
        }
                
        // initialize the facebook login button
        _fbloginView = [[FBLoginView alloc] init];
        _fbloginView.delegate = self;
        
        //_imageLoadingQueue = [[NSOperationQueue alloc] init];
        //[_imageLoadingQueue setName:@"imageLoadingQueue"];
        
        //_facebookUidToImageDownloadOperations = [[NSMutableDictionary alloc] init];

        NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                                 @"read_friendlists",
                                 @"user_photos",
                                 nil];

        [_fbloginView setReadPermissions:permissions];
        
        //[self performSelectorInBackground:@selector(loadAllFacebookFriends) withObject:nil];
        if (self.useFacebook)
        {
            [self loadAllFacebookFriends];
        }
        
        if (self.useTwitter)
        {
            [self loadTwitterFriends];
        }
    }
    return self;
}


- (void)saveDatabase
{
    //NSLog(@"save database");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *numberFacebook = [[NSNumber alloc] initWithBool:self.useFacebook];
    [defaults setObject:numberFacebook forKey:USEFACEBOOK];

    NSNumber *numberTwitter = [[NSNumber alloc] initWithBool:self.useTwitter];
    [defaults setObject:numberTwitter forKey:USETWITTER];
    
    NSNumber *numberInstagram = [[NSNumber alloc] initWithBool:self.useInstagram];
    [defaults setObject:numberInstagram forKey:USEINSTAGRAM];
    
    [defaults setObject:[[NSNumber alloc] initWithInteger:self.selectedFeedIndex] forKey:SELECTEDFEEDINDEX];
    
    [defaults setObject:self.groups forKey:GROUPS];
    [defaults setObject:self.groupMembers forKey:GROUPMEMBERS];

    NSNumber *selectedMediaName = [[NSNumber alloc] initWithInt:self.selectedMediaNameIndex];
    [defaults setObject:selectedMediaName  forKey:SELECTEDMEDIANAME];
    
    [defaults setObject:self.lastUpdate forKey:LASTUPDATE];
    
    [defaults setObject:self.selectedTwitterAccounts forKey:SELECTEDTWITTERACCOUNTS];
    
    [defaults synchronize];
    
}


- (void)requestNewAccessToken
{
    
}


- (void)readURLAsync:(NSString *)urlString fromConnection:(FBRequestConnection *)connection
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
    
    NSError *jsonError;
    //NSString *svar = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    NSLog(@"dict = %@",dict);
    if (!jsonError)
    {
        NSMutableArray *data = [dict objectForKey:@"data"];
        if (data)
        {
            NSLog(@"data = %@",data);
        }
    }
    
    
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

#pragma mark Facebook

- (void)openFacebookInViewController:(UIViewController *)vc
{
    // FacebookAppID
    //ACFacebookAppIdKey : @"577876515622948" };
    /*
     NSLog(@"read permissions = %@",[_fbloginView readPermissions]);
     @"email",
     @"user_birthday",
     @"user_likes",
     @"user_location",
     @"user_photos",
     @"read_stream",
     @"publish_stream",
     @"publish_actions",
     @"status_update",
     @"user_about_me",
     @"read_friendlists",
     @"friends_about_me",
     @"friends_birthday",
     @"friends_photos",
     */
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDict[@"FacebookAppID"];
    
    NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
    NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookAppIdKey : appID };
    
    //self.facebookAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.account requestAccessToAccountsWithType:self.facebookAccountType options:options completion:^(BOOL granted, NSError *error)
     {
         if (!error)
         {
             if (granted)
             {
                 NSLog(@"hello facebook");
             }
             else
             {
                 NSLog(@"facebook not granted");
                 UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Facebook access not granted. Check permissions in Settings"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [as showInView:vc.view];
                 });
                 
             }
         }
         else
         {
             NSString *errorMessage = [NSString stringWithFormat:@"%@",[error localizedDescription]];
             UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:errorMessage
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [as showInView:vc.view];
             });
             
         }
     }
     ];
    
}

- (void)loadAllFacebookFriends
{
    //NSLog(@"loadAllFacebookfriends");
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDict[@"FacebookAppID"];
    
    NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                             @"read_friendlists",
                             @"user_photos",
                             nil];
    
    NSDictionary *options = @{ ACFacebookPermissionsKey : permissions,
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookAppIdKey : appID };
    
    //self.facebookAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.account requestAccessToAccountsWithType:self.facebookAccountType options:options completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             //NSLog(@"access granted");
             
             NSArray *accounts = [self.account accountsWithAccountType:self.facebookAccountType];
             
             // there is only one facebook account
             ACAccount *facebookAccount = [accounts lastObject];
             
             if (facebookAccount)
             {
                 //NSLog(@"here i am in the facebook account to load friends");
                 NSString *apiString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends"];
                 NSURL *request = [NSURL URLWithString:apiString];
                 NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name,username",@"fields", nil];
                 
                 SLRequest *friends = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:param];
                 friends.account = facebookAccount;
                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          NSArray* friendsArray = [result objectForKey:@"data"];
                          
                          NSLog(@"facebook friends.count = %ld",friendsArray.count);
                          if (friendsArray.count)
                          {
                              [self.facebookFriends addObjectsFromArray:friendsArray];
                          }
                          //NSLog(@"last friend = %@",[friendsArray lastObject]);
                          
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
    
    return;
    
    // This is the old way to load the friends
    if ([[FBSession activeSession] isOpen])
    {
        
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error)
         {
             if (error)
             {
                 NSLog(@"error = %@",error);
             }
             else
                 
             {
                 
                 NSArray* friends = [result objectForKey:@"data"];
                 //FBGraphObject *paging = [result objectForKey:@"paging"];
                 
                 //NSString *previous = [paging objectForKey:@"previous"];
                 // keys
                 // first_name, id, last_name, name, username
                 NSLog(@"Found: %ld friends", friends.count);
                 
                 if ([friends count])
                 {
                     [self.facebookFriends removeAllObjects];
                     [self.facebookFriends addObjectsFromArray:friends];
                 }
                 
                 //NSLog(@"result = %@",result);
                 //NSString *next = [paging objectForKey:@"next"];
                 //if (next)
                 {
                     //NSLog(@"next");
                     //[self readURLAsync:next fromConnection:connection];
                 }
                 /*
                  for (NSDictionary<FBGraphUser>* friend in friends)
                  {
                  NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
                  }
                  */
             }
         }];
    }
    else
    {
        NSLog(@"session is not open");
    }
    
    
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    // this is called when you have logged in
    // first get the buttons set for login mode
    //self.buttonPostPhoto.enabled = YES;
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
    //NSLog(@"loginViewShowingLoggedInUser");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    //NSLog(@"loginViewFetchUserInfo");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    // this is called after you have logged out
    //NSLog(@"loginViewShowingLoggedOutUser");
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark Twitter

- (void)openTwitterInViewController:(UIViewController *)vc
{
    
    //self.twitterAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    //NSLog(@"in openTwitterInViewController");
    [self.account requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (!error)
         {
             if (granted)
             {
                 
                 ACAccount *twitterAccount = [self selectedTwitterAccount];
                 if (twitterAccount)
                 {
                     // do stuff here
                 }
                 else
                 {
                     
                     UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"No available twitter account"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [as showInView:vc.view];
                     });
                 }
             }
             else
             {
                 NSLog(@"twitter not granted, error = %@", [error localizedDescription]);
                 
                 UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Twitter access not granted. Check permissions in Settings"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [as showInView:vc.view];
                 });
                 
             }
         }
         else
         {
             NSString *errorMessage = [NSString stringWithFormat:@"%@",[error localizedDescription]];
             UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:errorMessage
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [as showInView:vc.view];
             });
             
         }
     }
     ];
    
}

- (void)loadTwitterFriends
{
    NSLog(@"load twitter friends");

    //self.twitterAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.account requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSLog(@"twitter access granted");
             
             ACAccount *twitterAccount = [self selectedTwitterAccount];
             
             if (twitterAccount)
             {
                 NSLog(@"here i am in the twitter account to load friends");
                 NSString *apiString = [NSString stringWithFormat:@"%@/%@/friends/list.json", kTwitterAPIRoot, kTwitterAPIVersion];
                 //NSString *apiString = [NSString stringWithFormat:@"%@/%@/friends/ids.json", kTwitterAPIRoot, kTwitterAPIVersion];

                 NSURL *request = [NSURL URLWithString:apiString];
                 
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 //[parameters setObject:@"100" forKey:@"count"];
                 //[parameters setObject:@"1" forKey:@"include_entities"];
                 //[parameters setObject:@"1" forKey:@"user_id"];
                 //[parameters setObject:@"1" forKey:@"screen_name"];
                 [parameters setObject:@"1" forKey:@"skip_status"];

                 SLRequest *friends = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                 friends.account = twitterAccount;
                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          //NSLog(@"result = %@",result);
                          
                          NSArray *users = [result objectForKey:@"users"];
                          
                          NSLog(@"twitter users.count = %ld",users.count);
                          if (users.count)
                          {
                              if (self.twitterFriends.count)
                              {
                                  [self.twitterFriends removeAllObjects];
                              }
                              for (NSDictionary *u in users)
                              {
                                  NSString *name = [u objectForKey:@"screen_name"];
                                  NSString *uid = [u objectForKey:@"id_str"];
                                  NSDictionary *d = @{@"name" : name, @"id" : uid };
                                  //NSLog(@"%@",d);
                                  [self.twitterFriends addObject:d];
                              }
                              NSLog(@"twitterFriends.count = %ld",self.twitterFriends.count);
                              //[self.facebookFriends addObjectsFromArray:friendsArray];
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
    
    return;
}

- (ACAccount *)selectedTwitterAccount
{
    ACAccount *twitterAccount = nil;

    self.twitterAccounts = [self.account accountsWithAccountType:self.twitterAccountType];
    NSInteger numAccounts = [self.twitterAccounts count];
    
    if (numAccounts)
    {
        if ([self.selectedTwitterAccounts count] == 0)
        {
            ACAccount *account = [self.twitterAccounts lastObject];
            NSString *username = [account username];
            NSString *uid = [[self.twitterAccounts lastObject] userID];
            [self.selectedTwitterAccounts setObject:uid forKey:username];
        }
        
        for (ACAccount *account in self.twitterAccounts)
        {
            //NSLog(@"username = %@",account.username);
            if ([self.selectedTwitterAccounts objectForKey:account.username])
            {
                //NSLog(@"selected: %@",account.username);
                twitterAccount = account;
            }
        }
    }
    
    return twitterAccount;
}

#pragma mark Instagram

- (void)openInstagramInViewController:(UIViewController *)vc
{
    
}
@end
