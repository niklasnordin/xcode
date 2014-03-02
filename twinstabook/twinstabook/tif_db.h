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

typedef enum : NSInteger
{
    kFacebook = 0,
    kTwitter,
    kInstagram
} kMediaTypes;

// these must be in the same order as the socialMediaNames
static NSString * const FACEBOOK = @"Facebook";
//static const int kFacebook = 0;
static NSString * const TWITTER = @"Twitter";
//static const int kTwitter = 1;
static NSString * const INSTAGRAM = @"Instagram";
//static const int kInstagram = 2;

static NSString * const USEFACEBOOK = @"usefacebook";
static NSString * const USETWITTER = @"useTwitter";
static NSString * const USEINSTAGRAM = @"useInstagram";
static NSString * const SELECTEDMEDIANAME = @"selectedMediaName";
static NSString * const SELECTEDFEEDINDEX = @"selectedFeedIndex";
static NSString * const GROUPS = @"groups";
static NSString * const GROUPMEMBERS = @"groupMembers";
static NSString * const LASTUPDATE = @"lastUpdate";
static NSString * const SELECTEDTWITTERACCOUNT = @"selectedTwitterAccount";

static NSString * const kFacebookGraphRoot = @"https://graph.facebook.com";
static NSString * const kTwitterAPIRoot = @"https://api.twitter.com";
static NSString * const kTwitterAPIVersion = @"1.1";

@interface tif_db : NSObject

// contains the names of the social medias
@property (strong, nonatomic) NSArray *socialMediaNames;

// used for the search function when adding members to a group
@property (nonatomic) int selectedMediaNameIndex;

// used for the search function when there is a secondary option
// so far only facebook has search options
@property (nonatomic) NSInteger selectedOptionIndex;

@property (strong, nonatomic) ACAccountStore *account;

@property (strong, nonatomic) NSDate *lastUpdate;

@property (nonatomic) bool useFacebook;
@property (nonatomic) bool useTwitter;
@property (nonatomic) bool useInstagram;

// the index to which group to use for the feed
@property (nonatomic) NSInteger selectedFeedIndex;

// the names of all the groups
@property (strong, nonatomic) NSMutableArray *groups;

// dictionaries containing the groupmembers to all groups
@property (strong, nonatomic) NSMutableDictionary *groupMembers;


- (id)init;
- (void)saveDatabase;

// facebook
@property (strong, nonatomic) ACAccountType *facebookAccountType;
@property (strong, nonatomic) NSMutableArray *facebookFriends;
@property (strong, nonatomic) NSArray *facebookSearchOptions;
@property (strong, nonatomic) NSString *facebookUsername;
@property (strong, nonatomic) UIImage *facebookLogo;

//@property (strong, nonatomic) FBLoginView *fbloginView;
- (void)openFacebookInViewController:(UIViewController *)vc;
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user;
//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
//- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error;
//- (void)requestNewAccessToken;
- (void)loadAllFacebookFriends;


// twitter
@property (strong, nonatomic) ACAccountType *twitterAccountType;
@property (strong, nonatomic) NSArray *twitterAccounts;
@property (strong, nonatomic) NSMutableArray *twitterFriends;
@property (strong, nonatomic) ACAccount *selectedTwitterAccount;
@property (strong, nonatomic) UIImage *twitterLogo;

- (void)openTwitterInViewController:(UIViewController *)vc;
- (void)loadAllTwitterFriendsInViewController:(UIViewController *)vc;
- (void)loadTwitterFriendsWithCursor:(NSString *)cursor inViewController:(UIViewController *)vc;

// instagram functions
@property (strong, nonatomic) UIImage *instagramLogo;

- (void)openInstagramInViewController:(UIViewController *)vc;

@end
