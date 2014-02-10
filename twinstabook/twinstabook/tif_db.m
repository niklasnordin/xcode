//
//  tif_db.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "tif_db.h"

@implementation tif_db

-(id)init
{
    self = [super init];
    if (self)
    {

        self.mediaNames = [[NSArray alloc] initWithObjects:@"facebook", @"twitter", @"instagram", nil];
        self.facebookSearchOptions = [[NSArray alloc] initWithObjects:@"friends", @"pages", @"users", nil];
        
        NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
        // check for user setting exist
        if (!database)
        {
            //database = [[NSMutableDictionary alloc] init];
            
            _useFacebook = false;
            _useTwitter = false;
            _useInstagram = false;
            _selectedMediaName = 0;
            _selectedFeedIndex = 0;
            
            _groups = [[NSMutableArray alloc] init];
            _groupMembers = [[NSMutableDictionary alloc] init];
            for (NSString *name in self.mediaNames)
            {
                NSMutableArray *arry = [[NSMutableArray alloc] init];
                [_groupMembers setObject:arry forKey:name];
            }
        }
        else
        {
            _useFacebook = [[database objectForKey:USEFACEBOOK] boolValue];
            _useTwitter = [[database objectForKey:USETWITTER] boolValue];
            _useInstagram = [[database objectForKey:USEINSTAGRAM] boolValue];
            _selectedMediaName = [[database objectForKey:SELECTEDMEDIANAME] intValue];
            _selectedFeedIndex = [[database objectForKey:SELECTEDFEEDINDEX] integerValue];
            
            _groups = [database objectForKey:GROUPS];
            _groupMembers = [database objectForKey:GROUPMEMBERS];
            // need to add this since groups have been added after database was created
            if (!_groups)
            {
                _groups = [[NSMutableArray alloc] init];
            }
            if (!_groupMembers)
            {
                _groupMembers = [[NSMutableDictionary alloc] init];
                for (NSString *name in self.mediaNames)
                {
                    NSMutableArray *arry = [[NSMutableArray alloc] init];
                    [_groupMembers setObject:arry forKey:name];
                }
            }
        }
        //NSLog(@"init groupmembers count = %ld",[self.groupMembers count]);
        
        // initialize the facebook login button
        _fbloginView = [[FBLoginView alloc] init];
        _fbloginView.delegate = self;
        
        _imageLoadingQueue = [[NSOperationQueue alloc] init];
        [_imageLoadingQueue setName:@"imageLoadingQueue"];
        
        _facebookUidToImageDownloadOperations = [[NSMutableDictionary alloc] init];
        
        
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
        NSArray * permissions = [NSArray arrayWithObjects:@"read_stream",
                                 @"read_friendlists",
                                 @"user_photos",
                                 nil];
        [_fbloginView setReadPermissions:permissions];
        //[self performSelectorInBackground:@selector(loadAllFacebookFriends) withObject:nil];
        [self loadAllFacebookFriends];
    }
    return self;
}
-(void)saveDatabase
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

    NSNumber *selectedMediaName = [[NSNumber alloc] initWithInt:self.selectedMediaName];
    [defaults setObject:selectedMediaName  forKey:SELECTEDMEDIANAME];
    
    [defaults synchronize];
    
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

- (void)loadAllFacebookFriends
{
    NSLog(@"loadAllFacebookFriends");
    if ([[FBSession activeSession] isOpen])
    {
        NSLog(@"session is open");
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

@end
