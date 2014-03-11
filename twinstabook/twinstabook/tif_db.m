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
@property (nonatomic) int nActivities;
@end

@implementation tif_db

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.nActivities = 0;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *dirs = [fileManager URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirectory = [dirs firstObject];
        NSURL *url = [documentsDirectory URLByAppendingPathComponent:kDocumentName];
        self.managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
        
        if (fileExists)
        {
            // open the document
            [self.managedDocument openWithCompletionHandler:^(BOOL success) {
                if (success)
                {
                    NSLog(@"opening %@",kDocumentName);
                    [self managedDocumentIsReady];
                }
                else
                {
                    NSLog(@"error opening %@",kDocumentName);
                }
            }];
        }
        else
        {
            [self.managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                // create the document
                if (success)
                {
                    [self managedDocumentIsReady];
                    NSLog(@"created %@",kDocumentName);
                }
                else
                {
                    NSLog(@"could not create %@",kDocumentName);
                }
            }];
        }
        
        self.socialMediaNames = @[FACEBOOK, TWITTER, INSTAGRAM];

        self.account = [[ACAccountStore alloc] init];
        self.twitterAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        self.facebookAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

        self.facebookSearchOptions = [[NSArray alloc] initWithObjects:@"friends", @"pages", @"users", nil];
        self.facebookFriends = [[NSMutableArray alloc] init];
        self.twitterFriends = [[NSMutableArray alloc] init];
        self.instagramFriends = [[NSMutableArray alloc] init];
        
        //self.twitterLogo = [UIImage imageNamed:@"Twitter_logo_blue.png"];
        //self.facebookLogo = [UIImage imageNamed:@"FB-fLogo-Blue-printpackaging.tif"];
        //self.instagramLogo = [UIImage imageNamed:@"Instagram_Icon_Large.png"];
        
        self.twitterLogo = [UIImage imageNamed:@"Twitter-Logo-200-sq.png"];
        self.facebookLogo = [UIImage imageNamed:@"Facebook-Logo-Small.tif"];
        self.instagramLogo = [UIImage imageNamed:@"Instagram-Logo-200.png"];
        
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
            
            _posts = [[NSMutableDictionary alloc] init];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [_posts setObject:dict forKey:FACEBOOK];
            [_posts setObject:dict forKey:TWITTER];
            [_posts setObject:dict forKey:INSTAGRAM];
            
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
            _instagramAccessToken = [database objectForKey:INSTAGRAMACCESSTOKEN];
            
            _posts = [database objectForKey:POSTS];
            
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
        
    }
    
    return self;
}

- (void)managedDocumentIsReady
{
    if (self.managedDocument.documentState == UIDocumentStateNormal)
    {
        NSLog(@"document %@ is ready", self.managedDocument.fileURL.path);
    }
}

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

    NSNumber *selectedMediaName = [[NSNumber alloc] initWithInteger:self.selectedMediaNameIndex];
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

        NSInteger itype = user.type;
        NSNumber *type = [[NSNumber alloc] initWithInteger:itype];

        NSDictionary *userDict = @{@"name": user.name,
                                   @"uid" : user.uid,
                                   @"imageData" : user.imageData,
                                   @"updated" : user.updated,
                                   @"profileImageURL" : user.profileImageURL,
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
        obj.profileImageURL = [user objectForKey:@"profileImageURL"];
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

- (void)openFacebookInViewController:(UIViewController *)vc withCompletionsHandler:(void (^)(BOOL success))completion
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
                 NSArray *accounts = [self.account accountsWithAccountType:self.facebookAccountType];
                 // there is only one facebook account
                 ACAccount *facebookAccount = [accounts lastObject];
                 self.facebookUsername = [facebookAccount userFullName];

                 NSLog(@"hello facebook");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completion(YES);
                 });
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
                     completion(NO);
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
                 completion(NO);
             });
         }
     }
     ];
    
}
/*
- (void)loadAllFacebookFriendsWithCompletionsHandler:(void (^)(BOOL success))completion;
{
    completion(YES);
}
*/

- (void)loadAllFacebookFriendsWithCompletionsHandler:(void (^)(BOOL success))completion
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
                 NSString *apiString = [NSString stringWithFormat:@"%@/me/friends",kFacebookGraphRoot];
                 //NSString *apiString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends"];
                 NSURL *request = [NSURL URLWithString:apiString];
                 NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name,username",@"fields", nil];
                 
                 SLRequest *friends = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:request parameters:param];
                 friends.account = facebookAccount;
                 [self startActivityIndicator];
                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      [self stopActivityIndicator];
                      
                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          //self.facebookUsername = [facebookAccount userFullName];
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          NSArray* friendsArray = [result objectForKey:@"data"];
                          
                          NSLog(@"facebook friends.count = %ld",friendsArray.count);
                          if (friendsArray.count)
                          {
                              [self.facebookFriends removeAllObjects];
                              for (NSDictionary *userDict in friendsArray)
                              {
                                  //NSLog(@"userDict = %@",userDict);
                                  NSDictionary *pictureDict = [[userDict objectForKey:@"picture"] objectForKey:@"data"];
                                 // NSLog(@"picureDict = %@",pictureDict);
                                  UserObject *user = [[UserObject alloc] init];
                                  user.name = [userDict objectForKey:@"name"];
                                  user.uid = [userDict objectForKey:@"id"];
                                  user.profileImageURL = [pictureDict objectForKey:@"url"];
                                  user.type = kFacebook;
                                  [self.facebookFriends addObject:user];
                              }

                              //[self.facebookFriends addObjectsFromArray:friendsArray];
                          }
                          //NSLog(@"last friend = %@",[friendsArray lastObject]);
                          completion(YES);
                      }
                      else
                      {
                          completion(NO);
                          NSLog(@"error = %@",[error localizedDescription]);
                      }
                  }];
             }
             
         }
         else
         {
             completion(NO);
             NSLog(@"facebook access is not granted");
         }
         
     }];
    
    return;
     
}

#pragma mark Twitter

- (void)openTwitterInViewController:(UIViewController *)vc
{
    
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

- (void)loadAllTwitterFriendsInViewController:(UIViewController *)vc
{
    [self loadTwitterFriendsWithCursor:@"" inViewController:vc];
}

- (void)loadTwitterFriendsWithCursor:(NSString *)cursor inViewController:(UIViewController *)vc
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
                 [parameters setObject:@"200" forKey:@"count"];
                 //[parameters setObject:@"1" forKey:@"include_entities"];
                 //[parameters setObject:@"1" forKey:@"user_id"];
                 //[parameters setObject:@"1" forKey:@"screen_name"];
                 [parameters setObject:@"1" forKey:@"skip_status"];
                 if (cursor)
                 {
                     if (![cursor isEqualToString:@""])
                     {
                         [parameters setObject:cursor forKey:@"cursor"];
                     }
                 }
                 //NSLog(@"cursor = %@",cursor);
                 SLRequest *friends = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:request parameters:parameters];
                 friends.account = twitterAccount;

                 [self startActivityIndicator];
                 [friends performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      [self stopActivityIndicator];

                      //NSLog(@"response = %@",response);
                      //NSLog(@"error = %@",error.debugDescription);
                      if (!error)
                      {
                          NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                          //NSLog(@"result = %@",result);
                          
                          NSArray *users = [result objectForKey:@"users"];
                          NSDictionary *errors = [[result objectForKey:@"errors"] lastObject];
                          if (errors)
                          {
                              NSLog(@"%@",errors);
                              NSString *message = [errors objectForKey:@"message"];
                              NSString *output = [NSString stringWithFormat:@"Twitter Error when reading friends list: %@",message];
                              UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:output
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:nil];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [as showInView:vc.view];
                              });
                              
                          }
                          if (users.count)
                          {
                              if (self.twitterFriends.count && [cursor isEqualToString:@""])
                              {
                                  [self.twitterFriends removeAllObjects];
                              }
                              for (NSDictionary *u in users)
                              {
                                  //NSLog(@"%@",u);
                                  NSString *name = [u objectForKey:@"screen_name"];
                                  NSString *uid = [u objectForKey:@"id_str"];
                                  UserObject *user = [[UserObject alloc] init];
                                  user.name = name;
                                  user.uid = uid;
                                  user.profileImageURL = [u objectForKey:@"profile_image_url"];
                                  user.type = kTwitter;
                                  [self.twitterFriends addObject:user];
                              }
                              NSLog(@"twitterFriends.count = %ld",self.twitterFriends.count);
                          }
                          NSString *next_cursor = [result objectForKey:@"next_cursor_str"];
                          if (next_cursor)
                          {
                              if (![next_cursor isEqualToString:@"0"])
                              {
                                  [self loadTwitterFriendsWithCursor:next_cursor inViewController:vc];
                              }
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

- (void)openInstagramInViewController:(UIViewController *)vc andWebView:(UIWebView *)webView
{

    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token",kInstagramClientId, kInstagramRedirectUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];


}

- (void)loadAllInstagramFriendsInViewController:(UIViewController *)vc withCursor:(NSString *)cursor
{
    bool addCursor = YES;
    if (!cursor || [cursor isEqualToString:@""])
    {
        addCursor = NO;
        [self.instagramFriends removeAllObjects];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows/?access_token=%@",self.instagramAccessToken];
        if (addCursor)
        {
            urlString = [NSString stringWithFormat:@"%@&cursor=%@",urlString,cursor];
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        [self startActivityIndicator];
        NSData *pData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
        [self stopActivityIndicator];

        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableLeaves error:&error];
        
        //NSLog(@"result = %@",result);
        NSDictionary *metaDict = [result objectForKey:@"meta"];
        NSNumber *codeNumber = [metaDict objectForKey:@"code"];
        int codeInt = [codeNumber intValue];
        NSLog(@"code = %@",codeNumber);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (codeInt != 400)
            {
                //NSLog(@"it is valid");
                //NSLog(@"result = %@",result);
                NSArray *userData = [result objectForKey:@"data"];
                NSDictionary *pagination = [result objectForKey:@"pagination"];
                NSString *next_cursor = [pagination objectForKey:@"next_cursor"];
                //NSString *next_url = [pagination objectForKey:@"next_link"];
                //NSLog(@"instagram user count = %ld",[userData count]);
                //NSLog(@"adding to users %ld",self.instagramFriends.count);
                //NSLog(@"pagination = %@",pagination);
                //NSLog(@"cursor = %@",next_cursor);
                for (NSDictionary *userDict in userData)
                {
                    UserObject *user = [[UserObject alloc] init];
                    user.name = [userDict objectForKey:@"username"];
                    user.uid = [userDict objectForKey:@"id"];
                    user.profileImageURL = [userDict objectForKey:@"profile_picture"];
                    user.type = kInstagram;
                    
                    [self.instagramFriends addObject:user];
                }
                if (next_cursor)
                {
                    // load next sequence
                    [self loadAllInstagramFriendsInViewController:vc withCursor:next_cursor];
                }
                /*
                NSDictionary *dataDict = [result objectForKey:@"data"];
                NSString *username = [dataDict objectForKey:@"username"];
                NSString *profileLinkURL = [dataDict objectForKey:@"profile_picture"];
                NSString *userid = [dataDict objectForKey:@"id"];
                */
            }
            else
            {
                //NSLog(@"it is not valid");
                NSString *output = [NSString stringWithFormat:@"Instagram Authentication Error. No valid access token. Please log in."];
                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:output
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
                
                [as showInView:vc.view];
                
            }
        });
    });
    
    
}

// this will use the profileImageURL and should work for all services
- (void)downloadImageForUser:(UserObject *)user
{
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
             
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    NSMutableURLRequest *pictureRequest = [NSMutableURLRequest requestWithURL:url];
    [self startActivityIndicator];
    NSData *pImageData = [NSURLConnection sendSynchronousRequest:pictureRequest returningResponse:&responseCode error:&error];
    [self stopActivityIndicator];
             
    if (pImageData)
    {
        user.imageData = pImageData;
    }
    
}

- (void)checkIfProfilePicturesAreUpToDate
{
    //need to implement this later
}

- (void)startActivityIndicator
{
    if (self.nActivities == 0)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    self.nActivities++;
}

- (void)stopActivityIndicator
{
    self.nActivities--;
    if (self.nActivities == 0)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}
@end
