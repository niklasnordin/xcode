//
//  janaf_cp.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-16.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "janaf_cp.h"

static NSString *name = @"janaf_cp";

@implementation janaf_cp

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [janaf_cp name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double y = 0.0;
    double y1 = ((((a[4]*T + a[3])*T + a[2])*T + a[1])*T + a[0] )*a[7];
    if (y1) y = y1;
    return y;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 8;
}

- (NSString *)equationText
{
    return @"";
}

@end
