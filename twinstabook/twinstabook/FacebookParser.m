//
//  facebookParser.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-09.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "FacebookParser.h"
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

static NSString *FBSTATUSTYPEWALLPOST = @"wall_post";
static NSString *FBSTATUSTYPEMOBILEUPDATE = @"mobile_status_update";

- (id)init
{
    self = [super init];
    return self;
}

+ (displayObject *)parse:(NSDictionary *)dict
{
    //NSLog(@"dictionary is %@",dict);

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
    displayObject *obj = nil;
    NSString *message = [dict objectForKey:@"message"];
    //NSString *statusType = [dict objectForKey:@"status_type"];
    
    if (message)
    {
        //NSLog(@"obj = %@",dict);
        obj = [[displayObject alloc] init];
        [obj setMainTitle:message];
        [obj setType:@"facebook"];
        
        // get the link
        NSArray *actions = [dict objectForKey:@"actions"];
        for (NSDictionary *subDicts in actions)
        {
            NSString *subKey = [subDicts objectForKey:@"name"];
            if ([subKey isEqualToString:@"Comment"])
            {
                NSString *url = [subDicts objectForKey:@"link"];
                [obj setLink:url];
            }
        }
    }

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
