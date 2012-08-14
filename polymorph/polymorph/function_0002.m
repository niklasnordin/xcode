//
//  function_0002.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "function_0002.h"

static NSString *name = @"function_0002";

@implementation function_0002


-(function_0002 *) init
{
    self = [super init];
    return self;
}


+(NSString *)name
{
    return name;
}


-(NSString *) name
{
    return [function_0002 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    return 2.0*T+3.1 + T*T;
}

-(int)nCoefficients
{
    return 0;
}

@end
