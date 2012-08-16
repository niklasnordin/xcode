//
//  janaf_h.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-16.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "janaf_h.h"

static NSString *name = @"janaf_h";

@implementation janaf_h


+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [janaf_h name];
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
    a[6] = 0.0;
    a[7] = 0.0;

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double y = 0.0;
    double y1 = (((((a[4]/5.0 + a[3]/4.0)*T + a[2]/3.0)*T + a[1]/2.0)*T + a[0])*T + a[5])*a[7];
    if (y1) y = y1;
    return y;
}

-(int)nCoefficients
{
    return 8;
}

@end
