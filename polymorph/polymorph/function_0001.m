//
//  function_0001.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "function_0001.h"

static NSString *name = @"function_0001";

@implementation function_0001

-(function_0001 *) init
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
    return [function_0001 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double y = 2.0*T - T*T;
    return y;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 0;
}

@end
