//
//  functions.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "functions.h"

@implementation functions

-(id) select:(NSString *)name withArray:(NSArray *)array
{
    id f;
    Class functionClass = (NSClassFromString(name));
    
    if (functionClass != nil) {
        f = [[functionClass alloc] initWithArray:array];
    }
    else
    {
        //NSLog(@"%@ is an illegal function. Abort!",name);
        //abort();
        f = nil;
    }
    
    return f;
}

-(id) select:(NSString *)name
{
    id f;
    Class functionClass = (NSClassFromString(name));
    
    if (functionClass != nil) {
        f = [[functionClass alloc] initWithZero];
    }
    else
    {
        NSLog(@"%@ is an illegal function. Abort!",name);
        abort();
    }
    
    return f;
}

@end
