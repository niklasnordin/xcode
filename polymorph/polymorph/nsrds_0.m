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

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    
    double y = ((((a[5]*T + a[4])*T + a[3])*T + a[2])*T + a[1])*T + a[0];
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

- (NSString *)equationText
{
    return @"y=A0 + A1*T + A2*T^2 + A3*T^3 + A4*T^4 + A5*T^5";
}

@end
