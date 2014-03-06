//
//  twitterParser.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-13.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "twitterParser.h"

@implementation twitterParser

+ (DisplayObject *)parse:(NSDictionary *)dict
{
    DisplayObject *obj = nil;
    
    //NSLog(@"dict = %@",dict);
    if (dict)
    {
        obj = [[DisplayObject alloc] initWithTwitterDictionary:dict];
//        obj.mainTitle = [dict objectForKey:@"text"];
        NSLog(@"text = %@",obj.message);

    }
    return obj;
}

@end
