//
//  facebookParser.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DisplayObject.h"

typedef enum
{
    FBSTATUS,
    FBVIDEO,
    FBLINK,
    FBPHOTO
} FBTypes;

@interface FacebookParser : NSObject

- (id)init;
//+ (DisplayObject *)parse:(NSDictionary *)dict;

@end
