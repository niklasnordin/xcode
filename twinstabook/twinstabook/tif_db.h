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

//typedef enum { kFacebook, kTwitter, kInstagram } kMediaTypes;

// these must be in the same order as the socialMediaNames
const static NSString *FACEBOOK = @"Facebook";
const static int kFacebook = 0;
const static NSString *TWITTER = @"Twitter";
const static int kTwitter = 1;
const static NSString *INSTAGRAM = @"Instagram";
const static int kInstagram = 2;

static NSString *USEFACEBOOK = @"usefacebook";
static NSString *USETWITTER = @"useTwitter";
static NSString *USEINSTAGRAM = @"useInstagram";
static NSString *SELECTEDMEDIANAME = @"selectedMediaName";
static NSString *SELECTEDFEEDINDEX = @"selectedFeedIndex";
static NSString *GROUPS = @"groups";
static NSString *GROUPMEMBERS = @"groupMembers";
static NSString *LASTUPDATE = @"lastUpdate";
static NSString *SELECTEDTWITTERACCOUNTS = @"selectedTwitterAccounts";

const static NSString *kFacebookGraphRoot = @"https://graph.facebook.com";
const static NSString *kTwitterAPIRoot = @"https://api.twitter.com";
const static NSString *kTwitterAPIVersion = @"1.1";

@interface tif_db : NSObject
<
    FBLoginViewDelegate
>

@property (strong, nonatomic) NSArray *socialMediaNames;
@property (nonatomic) int selectedMediaNameIndex;

@property (strong, nonatomic) ACAccountStore *account;

@property (strong, nonatomic) NSDate *lastUpdate;

@property (nonatomic) bool useFacebook;
@property (nonatomic) bool useTwitter;
@property (nonatomic) bool useInstagram;

@property (nonatomic) NSInteger selectedFeedIndex;

@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) NSMutableDictionary *groupMembers;
@property (strong, nonatomic) NSOperationQueue *imageLoadingQueue;
@property (nonatomic) NSInteger selectedOptionindex;

- (id)init;
- (void)saveDatabase;

// facebook
@property (strong, nonatomic) ACAccountType *facebookAccountType;
@property (strong, nonatomic) NSMutableDictionary *facebookUidToImageDownloadOperations;
@property (strong, nonatomic) FBLoginView *fbloginView;
@property (strong, nonatomic) NSMutableArray *facebookFriends;
@property (strong, nonatomic) NSArray *facebookSearchOptions;

- (void)openFacebookInViewController:(UIViewController *)vc;
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user;
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error;
- (void)requestNewAccessToken;
- (void)loadAllFacebookFriends;

// twitter
@property (strong, nonatomic) ACAccountType *twitterAccountType;
@property (strong, nonatomic) NSArray *twitterAccounts;
@property (strong, nonatomic) NSMutableDictionary *selectedTwitterAccounts;
@property (strong, nonatomic) NSMutableArray *twitterFriends;

- (void)openTwitterInViewController:(UIViewController *)vc;
- (void)loadTwitterFriends;
- (ACAccount *)selectedTwitterAccount;

// instagram functions
- (void)openInstagramInViewController:(UIViewController *)vc;

@end
