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

        NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
        // check for user setting exist
        //NSMutableDictionary *database = [defaults objectForKey:@"database"];
        if (!database)
        {
            //database = [[NSMutableDictionary alloc] init];
            
            _useFacebook = false;
            _useTwitter = false;
            _useInstagram = false;
            _selectedMediaName = 0;
            _groups = [[NSMutableArray alloc] init];
        }
        else
        {
            _useFacebook = [[database objectForKey:USEFACEBOOK] boolValue];
            _useTwitter = [[database objectForKey:USETWITTER] boolValue];
            _useInstagram = [[database objectForKey:USEINSTAGRAM] boolValue];
            _selectedMediaName = [[database objectForKey:SELECTEDMEDIANAME] intValue];
            _groups = [database objectForKey:GROUPS];
            
            // need to add this since groups have been added after database was created
            if (!_groups)
            {
                _groups = [[NSMutableArray alloc] init];
            }
        }
        self.mediaNames = [[NSArray alloc] initWithObjects:@"facebook", @"twitter", @"instagram", nil];
        
        _fbloginView = [[FBLoginView alloc] init];
        _fbloginView.delegate = self;
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
                            nil];
        [_fbloginView setReadPermissions:permissions];

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
    
    [defaults setObject:self.groups forKey:GROUPS];
    
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

@end
