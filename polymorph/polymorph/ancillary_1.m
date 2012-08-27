//
//  ancillary_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-26.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "ancillary_1.h"

static NSString *name = @"ancillary_1";

@implementation ancillary_1


+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [ancillary_1 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double pc = a[8];
    double Tc = a[9];
    
    double phi = 1.0 - T/Tc;
    
    double rhs = a[0]*pow(phi, a[4]) + a[1]*pow(phi, a[5]) + a[2]*pow(phi, a[6]) + a[3]*pow(phi, a[7]);
    
    return pc*exp(Tc*rhs/T);
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 10;
}

- (NSString *)equationText
{
    return @"";
}

@end
