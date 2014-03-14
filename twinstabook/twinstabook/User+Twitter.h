//
//  User+Twitter.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "User.h"
#import "Post.h"
#import "UserObject.h"

@interface User (Twitter)

+ (User *)twitterUserInContext:(NSManagedObjectContext *)context fromPost:(Post *)post;
+ (User *)twitterUserInContext:(NSManagedObjectContext *)context fromUserObject:(UserObject *)obj;
+ (User *)twitterUserInContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict;

@end
