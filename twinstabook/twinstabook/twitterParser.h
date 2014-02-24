//
//  twitterParser.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayObject.h"

@interface twitterParser : NSObject

+ (DisplayObject *)parse:(NSDictionary *)dict;

@end
