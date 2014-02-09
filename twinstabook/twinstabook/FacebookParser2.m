//
//  facebookParser.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "FacebookParser2.h"

@implementation FacebookParser

static NSString *FBTYPEPHOTO = @"photo";
static NSString *FBTYPESTATUS = @"status";
static NSString *FBTYPELINK = @"link";
static NSString *FBTYPEVIDEO = @"video";

static NSString *OBJTYPE = @"type";

+ (displayObject *)parse:(NSDictionary *)dict
{
    // how can you make this static???
    NSDictionary *FBType =
    @{
      FBTYPELINK :  [[NSNumber alloc] initWithInt:FBLINK],
      FBTYPEPHOTO : [[NSNumber alloc] initWithInt:FBPHOTO],
      FBTYPEVIDEO : [[NSNumber alloc] initWithInt:FBVIDEO],
      FBTYPESTATUS : [[NSNumber alloc] initWithInt:FBSTATUS]
    };

    displayObject *obj;
    
    NSString *type = [dict objectForKey:OBJTYPE];
    NSNumber *numberType = [FBType objectForKey:type];
    int enumType = [numberType intValue];
    
    switch (enumType) {
        case FBPHOTO:
            NSLog(@"type is photo");
            break;
            
        case FBSTATUS:
            NSLog(@"type is status");
            break;
        
        case FBLINK:
            NSLog(@"type is link");
            break;
            
        case FBVIDEO:
            NSLog(@"type is video");
            break;
        default:
            NSLog(@"type is not implemented: %@", type);
            break;
    }
    return obj;
}

@end
