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
static NSString * const FACEBOOK = @"Facebook";
static const int kFacebook = 0;
static NSString * const TWITTER = @"Twitter";
static const int kTwitter = 1;
static NSString * const INSTAGRAM = @"Instagram";
static const int kInstagram = 2;

static NSString * const USEFACEBOOK = @"usefacebook";
static NSString * const USETWITTER = @"useTwitter";
static NSString * const USEINSTAGRAM = @"useInstagram";
static NSString * const SELECTEDMEDIANAME = @"selectedMediaName";
static NSString * const SELECTEDFEEDINDEX = @"selectedFeedIndex";
static NSString * const GROUPS = @"groups";
static NSString * const GROUPMEMBERS = @"groupMembers";
static NSString * const LASTUPDATE = @"lastUpdate";
static NSString * const SELECTEDTWITTERACCOUNTS = @"selectedTwitterAccounts";

static NSString * const kFacebookGraphRoot = @"https://graph.facebook.com";
static NSString * const kTwitterAPIRoot = @"https://api.twitter.com";
static NSString * const kTwitterAPIVersion = @"1.1";

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
//@property (strong, nonatomic) NSOperationQueue *imageLoadingQueue;
@property (nonatomic) NSInteger selectedOptionindex;

- (id)init;
- (void)saveDatabase;

// facebook
@property (strong, nonatomic) ACAccountType *facebookAccountType;
//@property (strong, nonatomic) NSMutableDictionary *facebookUidToImageDownloadOperations;
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
@property (strong, nonatomic) NSString *facebookUsername;

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
