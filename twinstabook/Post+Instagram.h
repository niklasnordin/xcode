//
//  Post+Instagram.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "Post.h"

@interface Post (Instagram)

+ (Post *)addInstagramPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict;

@end
