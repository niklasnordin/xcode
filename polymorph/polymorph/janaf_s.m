//
//  janaf_s.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-16.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "janaf_s.h"

static NSString *name = @"janaf_s";

@implementation janaf_s

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [janaf_s name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double y = 0.0;
    double y1 = ((((a[4]/4.0 + a[3]/3.0)*T + a[2]/2.0)*T + a[1])*T + a[0]*log(T) + a[6])*a[7];

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
