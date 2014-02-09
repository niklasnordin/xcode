//
//  facebookParser.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "FacebookParser2.h"
@interface FacebookParser()

- (displayObject *)parseStatus:(NSDictionary *)dict;
- (displayObject *)parseLink:(NSDictionary *)dict;
- (displayObject *)parsePhoto:(NSDictionary *)dict;
- (displayObject *)parseVideo:(NSDictionary *)dict;

@end

@implementation FacebookParser

static NSString *FBTYPEPHOTO = @"photo";
static NSString *FBTYPESTATUS = @"status";
static NSString *FBTYPELINK = @"link";
static NSString *FBTYPEVIDEO = @"video";

static NSString *OBJTYPE = @"type";

- (id)init
{
    self = [super init];
    return self;
}

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

    FacebookParser *parser = [[FacebookParser alloc] init];
    displayObject *obj = nil;
    
    NSString *type = [dict objectForKey:OBJTYPE];
    NSNumber *numberType = [FBType objectForKey:type];
    int enumType = [numberType intValue];
    
    switch (enumType) {
        case FBPHOTO:
            //NSLog(@"type is photo");
            break;
            
        case FBSTATUS:
            //NSLog(@"type is status");
            obj = [parser parseStatus:dict];
            break;
        
        case FBLINK:
            //NSLog(@"type is link");
            break;
            
        case FBVIDEO:
            //NSLog(@"type is video");
            break;
        default:
            NSLog(@"Not implemented: type is %@", type);
            break;
    }
    return obj;
}

- (displayObject *)parseStatus:(NSDictionary *)dict
{
    displayObject *obj = [[displayObject alloc] init];

    NSString *message = [dict objectForKey:@"message"];
    [obj setMain:message];
    
    //NSLog(@"dictionary is %@",dict);
    NSLog(@"message is %@",message);
    
    return obj;
}

- (displayObject *)parseLink:(NSDictionary *)dict
{
    displayObject *obj;
    
    //NSLog(@"%@",dict);
    
    return obj;
}

- (displayObject *)parsePhoto:(NSDictionary *)dict
{
    displayObject *obj;
    
    //NSLog(@"%@",dict);
    
    return obj;
}

- (displayObject *)parseVideo:(NSDictionary *)dict
{
    displayObject *obj;
    
    //NSLog(@"%@",dict);
    
    return obj;
}


@end
