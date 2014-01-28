//
//  tif_db.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

static NSString *USEFACEBOOK = @"usefacebook";
static NSString *USETWITTER = @"useTwitter";
static NSString *USEINSTAGRAM = @"useInstagram";

@interface tif_db : NSObject <FBLoginViewDelegate>

@property (nonatomic) bool useFacebook;
@property (nonatomic) bool useTwitter;
@property (nonatomic) bool useInstagram;

@property (strong, nonatomic) FBLoginView *fbloginView;

-(id)init;
-(void)saveDatabase;

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user;
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error;

@end
