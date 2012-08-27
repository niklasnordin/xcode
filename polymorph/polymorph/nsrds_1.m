//
//  nsrds_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-29.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_1.h"

static NSString *name = @"nsrds_1";

@implementation nsrds_1

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_1 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];

    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }

    double y = exp(a[0] + a[1]/T + a[2]*log(T) + a[3]*pow(T, a[4]));

    return y;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 5;
}

- (NSString *)equationText
{
    return @"";
}


@end
