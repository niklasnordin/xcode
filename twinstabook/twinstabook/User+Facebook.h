//
//  User+Facebook.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-11.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "User.h"
#import "Post.h"

@interface User (Facebook)

+ (User *)facebookUserInContext:(NSManagedObjectContext *)context fromPost:(Post *)post;

@end
