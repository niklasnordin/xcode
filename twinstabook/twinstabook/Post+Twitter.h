//
//  Post+Twitter.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-03-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "Post.h"

@interface Post (Twitter)

+ (Post *)addTwitterPostToContext:(NSManagedObjectContext *)context fromDictionary:(NSDictionary *)dict;

@end
