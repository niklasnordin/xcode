//
//  nsrds_5.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_5.h"

static NSString *name = @"nsrds_5";

@implementation nsrds_5

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_5 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }

    double y = a[0]/pow(a[1], 1.0 + pow(1.0 - T/a[2], a[3]));

    return y;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 4;
}

- (NSString *)equationText
{
    return @"";
}

@end
