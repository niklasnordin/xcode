//
//  functions.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "functions.h"

@implementation functions

-(id) select:(NSString *)name
{

    id f;
    if ([name isEqualToString:[function_0001 name]])
    {
       f = [[function_0001 alloc] init];
    }
    else if ([name isEqualToString:[function_0002 name]])
    {
        f = [[function_0002 alloc] init];
    }
    else if ([name isEqualToString:[nsrds_5 name]])
    {
        f = [[nsrds_5 alloc] init];
    }
    else if ([name isEqualToString:[nsrds_0 name]])
    {
        f = [[nsrds_0 alloc] init];
    }
    else if ([name isEqualToString:[nsrds_1 name]])
    {
        f = [[nsrds_1 alloc] init];
    }
    else
    {
        NSLog(@"%@ is illegal function. Abort!",name);
        abort();
    }
        
    return f;
}

@end
