//
//  tif_db.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

static NSString *USEFACEBOOK = @"usefacebook";
static NSString *USETWITTER = @"useTwitter";
static NSString *USEINSTAGRAM = @"useInstagram";
static NSString *SELECTEDMEDIANAME = @"selectedMediaName";
static NSString *SELECTEDFEEDINDEX = @"selectedFeedIndex";
static NSString *GROUPS = @"groups";
static NSString *GROUPMEMBERS = @"groupMembers";
static NSString *LASTUPDATE = @"lastUpdate";

@interface tif_db : NSObject
<
    FBLoginViewDelegate
>

@property (strong, nonatomic) ACAccountStore *account;
@property (strong, nonatomic) ACAccountType *twitterAccountType;
@property (strong, nonatomic) ACAccountType *facebookAccountType;

@property (strong, nonatomic) NSDate *lastUpdate;
@property (nonatomic) bool useFacebook;
@property (nonatomic) bool useTwitter;
@property (nonatomic) bool useInstagram;
@property (nonatomic) int selectedMediaName;
@property (nonatomic) NSInteger selectedFeedIndex;

@property (strong, nonatomic) NSArray *mediaNames;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) NSMutableDictionary *groupMembers;

@property (strong, nonatomic) NSOperationQueue *imageLoadingQueue;
@property (strong, nonatomic) NSMutableDictionary *facebookUidToImageDownloadOperations;

@property (strong, nonatomic) FBLoginView *fbloginView;
@property (strong, nonatomic) NSMutableArray *facebookFriends;
@property (strong, nonatomic) NSArray *facebookSearchOptions;
@property (nonatomic) NSInteger selectedOptionindex;

- (id)init;
- (void)saveDatabase;

- (void)openFacebookInViewController:(UIViewController *)vc;
- (void)openTwitterInViewController:(UIViewController *)vc;
- (void)openInstagramInViewController:(UIViewController *)vc;

// facebook functions
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user;
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error;
- (void)requestNewAccessToken;

// twitter functions

// instagram functions

@end
