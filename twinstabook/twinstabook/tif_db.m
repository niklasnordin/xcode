//
//  tif_db.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "tif_db.h"
#import "twinstabookFirstViewController.h"
#import "UserObject.h"

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

        self.facebookSearchOptions = [[NSArray alloc] initWithObjects:@"friends", @"pages", @"users", nil];
        self.facebookFriends = [[NSMutableArray alloc] init];
        self.twitterFriends = [[NSMutableArray alloc] init];
        
        //self.facebookUsername = [[NSString alloc] init];

        self.twitterLogo = [UIImage imageNamed:@"Twitter_logo_blue.png"];
        self.facebookLogo = [UIImage imageNamed:@"FB-fLogo-Blue-printpackaging.tif"];
        self.instagramLogo = [UIImage imageNamed:@"Instagram_Icon_Large.png"];
        
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
        }
        else
        {
            _useFacebook = [[database objectForKey:USEFACEBOOK] boolValue];
            _useTwitter = [[database objectForKey:USETWITTER] boolValue];
            _useInstagram = [[database objectForKey:USEINSTAGRAM] boolValue];
            _selectedMediaNameIndex = [[database objectForKey:SELECTEDMEDIANAME] intValue];
            _selectedFeedIndex = [[database objectForKey:SELECTEDFEEDINDEX] integerValue];
            
            _groups = [database objectForKey:GROUPS];
            _groupMembers = [[NSMutableDictionary alloc] init];

            NSMutableDictionary *groupMembers = [database objectForKey:GROUPMEMBERS];
            for (NSString *group in self.groups)
            {
                NSMutableArray *memberDict = [groupMembers objectForKey:group];
                NSMutableArray *memberObjects = [self dictionaryToUserObjects:memberDict];
                [self.groupMembers setObject:memberObjects forKey:group];
            }
            
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
  
        }
                
        // initialize the facebook login button
        //_fbloginView = [[FBLoginView alloc] init];
        //_fbloginView.delegate = self;
        
        //_imageLoadingQueue = [[NSOperationQueue alloc] init];
        //[_imageLoadingQueue setName:@"imageLoadingQueue"];
        
        //_facebookUidToImageDownloadOperations = [[NSMutableDictionary alloc] init];
/*
        NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                                 @"read_friendlists",
                                 @"user_photos",
                                 nil];

        [_fbloginView setReadPermissions:permissions];
  */      
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

//- (tif_db *)
- (void)saveDatabase
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *numberFacebook = [[NSNumber alloc] initWithBool:self.useFacebook];
    [defaults setObject:numberFacebook forKey:USEFACEBOOK];

    NSNumber *numberTwitter = [[NSNumber alloc] initWithBool:self.useTwitter];
    [defaults setObject:numberTwitter forKey:USETWITTER];
    
    NSNumber *numberInstagram = [[NSNumber alloc] initWithBool:self.useInstagram];
    [defaults setObject:numberInstagram forKey:USEINSTAGRAM];
    
    [defaults setObject:[[NSNumber alloc] initWithInteger:self.selectedFeedIndex] forKey:SELECTEDFEEDINDEX];
    
    [defaults setObject:self.groups forKey:GROUPS];
    
    NSMutableDictionary *groupMembers = [[NSMutableDictionary alloc] init];
    for (NSString *group in self.groups)
    {
        NSMutableArray *memberObjects = [self.groupMembers objectForKey:group];
        NSMutableArray *memberDict = [self userObjectsToDictionary:memberObjects];
        [groupMembers setObject:memberDict forKey:group];
    }
    
    [defaults setObject:groupMembers forKey:GROUPMEMBERS];

    NSNumber *selectedMediaName = [[NSNumber alloc] initWithInt:self.selectedMediaNameIndex];
    [defaults setObject:selectedMediaName  forKey:SELECTEDMEDIANAME];
    
    [defaults setObject:self.lastUpdate forKey:LASTUPDATE];
    
    //[defaults setObject:self.selectedTwitterAccount forKey:SELECTEDTWITTERACCOUNT];
    
    [defaults synchronize];
    
}

- (NSMutableArray *)userObjectsToDictionary:(NSArray *)users
{
    NSMutableArray *dict = [[NSMutableArray alloc] init];
    
    for (UserObject *user in users)
    {

        NSNumber *type = [[NSNumber alloc] initWithInteger:user.type];

        NSDictionary *userDict = @{@"name": user.name,
                                   @"uid" : user.uid,
                                   @"imageData" : user.imageData,
                                   @"updated" : user.updated,
                                   @"type" : type};
        [dict addObject:userDict];
    }
    return dict;
}

- (NSMutableArray *)dictionaryToUserObjects:(NSArray *)users
{
    NSMutableArray *dict = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *user in users)
    {
        UserObject *obj = [[UserObject alloc] init];
        obj.name = [user objectForKey:@"name"];
        obj.uid = [user objectForKey:@"uid"];
        obj.imageData = [user objectForKey:@"imageData"];
        obj.updated = [user objectForKey:@"updated"];
        NSNumber *num = [user objectForKey:@"type"];
        obj.type = [num integerValue];
        [dict addObject:obj];
    }
    return dict;
}

- (void)requestNewAccessToken
{
    
}

/*
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
*/
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
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          self.facebookUsername = [facebookAccount userFullName];
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
    
    [self.account requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {

         if (granted)
         {

             ACAccount *twitterAccount = [self selectedTwitterAccount];
             
             if (twitterAccount)
             {
                 //NSLog(@"here i am in the twitter account to load friends");
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
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 
                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          //NSLog(@"result = %@",result);
                          
                          NSArray *users = [result objectForKey:@"users"];
                          
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
                                  UserObject *user = [[UserObject alloc] init];
                                  user.name = name;
                                  user.uid = uid;
                                  user.type = kTwitter;
                                  [self.twitterFriends addObject:user];
                              }
                              //NSLog(@"twitterFriends.count = %ld",self.twitterFriends.count);
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

- (NSArray *)twitterAccounts
{
    if (!_twitterAccounts)
    {
        _twitterAccounts = [self.account accountsWithAccountType:self.twitterAccountType];
    }
    
    return _twitterAccounts;
}

- (ACAccount *)selectedTwitterAccount
{
    if (!_selectedTwitterAccount)
    {
        _selectedTwitterAccount = [self.twitterAccounts lastObject];
    }
    
    return _selectedTwitterAccount;
}

#pragma mark Instagram

- (void)openInstagramInViewController:(UIViewController *)vc
{
    
}
@end
