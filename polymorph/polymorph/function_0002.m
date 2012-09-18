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


-(function_0002 *)initWithZero
{
    self = [super init];
    return self;
}

-(function_0002 *)initWithArray:(NSArray *)array
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

-(double)valueForT:(double)T andP:(double)p
{
    return 2.0*T+3.1 + T*T;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 0;
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return nil;
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    
}

@end
