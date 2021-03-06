//
//  FJ_u.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-28.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "FJ_u.h"

static NSString *name = @"FJ_u";

@implementation FJ_u

#define Rgas 8314.462175

+(NSString *)name
{
    return name;
}

-(FJ_u *)initWithZero
{
    self = [super initWithZero];
    return self;
}

-(FJ_u *)initWithArray:(NSArray *)array
{
    self = [super initWithArray:array];
    return self;
}

-(NSString *) name
{
    return [FJ_u name];
}

-(double)valueForT:(double)T andP:(double)p
{
    /*
    double t = [self tc]/T;
    double rho = [_rho valueForT:T andP:p];
    double delta = rho/[self rhoc];
    */
    //double u1 = [self da0dt:delta, t);
    //double u2 = daResdt(delta, t);
    //return Rgas*[self tc]*(u1 + u2);
    return 1.0;
}

-(bool)pressureDependent
{
    return YES;
}

-(bool)temperatureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return 96;
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"rho" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    
    if ([key isEqualToString:@"rho"])
    {
        _rho = function;
    }

}

-(BOOL)requirementsFulfilled
{
    return (_rho != nil) ? YES : NO;
}

@end
