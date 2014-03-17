//
//  User+Instagram.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "User.h"

@interface User (Instagram)

+ (User *)instagramUserInContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict  forUserID:(NSString *)uid;

@end
