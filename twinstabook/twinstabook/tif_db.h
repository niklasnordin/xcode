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
#import "staticConstants.h"

@interface tif_db : NSObject

@property (strong, nonatomic) UIManagedDocument *managedDocument;
@property (nonatomic) BOOL contextIsReady;

// contains the names of the social medias
@property (strong, nonatomic) NSArray *socialMediaNames;

// used for the search function when adding members to a group
@property (nonatomic) NSInteger selectedMediaNameIndex;

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

- (void)startActivityIndicator;
- (void)stopActivityIndicator;

// facebook
@property (strong, nonatomic) ACAccountType *facebookAccountType;
@property (strong, nonatomic) ACAccount *selectedFacebookAccount;
@property (strong, nonatomic) NSMutableArray *facebookFriends;
@property (strong, nonatomic) NSArray *facebookSearchOptions;
@property (strong, nonatomic) NSString *facebookUsername;
@property (strong, nonatomic) UIImage *facebookLogo;
@property (strong, nonatomic) NSString *facebookAccountUserID;
@property (nonatomic) BOOL facebookLoaded;

- (void)openFacebookInViewController:(UIViewController *)vc withCompletionsHandler:(void (^)(BOOL success))completion;
//- (void)loadAllFacebookFriends;
- (void)loadAllFacebookFriendsWithCompletionsHandler:(void (^)(BOOL success))completion;

// twitter
@property (strong, nonatomic) ACAccountType *twitterAccountType;
@property (strong, nonatomic) NSArray *twitterAccounts;
@property (strong, nonatomic) NSMutableArray *twitterFriends;
@property (strong, nonatomic) ACAccount *selectedTwitterAccount;
@property (strong, nonatomic) NSNumber *selectedTwitterAccountIndex;
@property (strong, nonatomic) UIImage *twitterLogo;
@property (strong, nonatomic) NSString *twitterAccountUserID;
@property (nonatomic) BOOL twitterLoaded;

- (void)openTwitterInViewController:(UIViewController *)vc;
- (void)loadAllTwitterFriendsInViewController:(UIViewController *)vc;
- (void)loadTwitterFriendsWithCursor:(NSString *)cursor inViewController:(UIViewController *)vc;

// instagram functions
@property (strong, nonatomic) UIImage *instagramLogo;
@property (strong, nonatomic) NSString *instagramAccessToken;
@property (strong, nonatomic) NSMutableArray *instagramFriends;
@property (strong, nonatomic) NSString *instagramAccountUserID;
@property (nonatomic) BOOL instagramLoaded;

- (void)openInstagramInViewController:(UIViewController *)vc andWebView:(UIWebView *)webView;
- (void)loadAllInstagramFriendsInViewController:(UIViewController *)vc withCursor:(NSString *)cursor;

@end
