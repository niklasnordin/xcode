//
//  nsrds_0.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-29.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_0.h"

static NSString *name = @"nsrds_0";

@implementation nsrds_0

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_0 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    a[0] = 0.0;
    a[1] = 0.0;
    a[2] = 0.0;
    a[3] = 0.0;
    a[4] = 0.0;
    a[5] = 0.0;
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double y = 0.0;
    double y1 = ((((a[5]*T + a[4])*T + a[3])*T + a[2])*T + a[1])*T + a[0];
    if (y1) y = y1;
    return y;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 6;
}

@end
