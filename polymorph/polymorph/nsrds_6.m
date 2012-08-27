//
//  nsrds_6.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-24.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_6.h"

static NSString *name = @"nsrds_6";

@implementation nsrds_6


+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_6 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double Tr = T/a[5];
    double eVal = a[1] + Tr*(a[2] + Tr*(a[3] + a[4]*Tr));

    double y = a[0]*pow(1 - Tr, eVal);

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
    return @"";
}


@end
