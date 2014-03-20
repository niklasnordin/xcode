//
//  Post+Facebook.h
//  twinstabook
//
//  Created by Niklas Nordin on 09/03/14.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "Post.h"
#import "UserObject.h"

@interface Post (Facebook)

+ (Post *)addDummyToContext:(NSManagedObjectContext *)context;
+ (Post *)addFacebookPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserObject:(UserObject *)usr forAccountID:(NSString *)auid;
+ (Post *)addFacebookMobileStatusUpdateToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict forUserObject:(UserObject *)usr forAccountID:(NSString *)auid;

+ (void)readLikesForFacebookPost:(NSString *)postID withCompletionHandler:(void (^)(NSInteger nLikes))completion;

+ (void)readCommentsForFacebookPostID:(NSString *)postID withCompletionHandler:(void (^)(NSInteger nComments))completion;

@end
