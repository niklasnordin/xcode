//
//  ancillary_2.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "ancillary_2.h"

static NSString *name = @"ancillary_2";

@implementation ancillary_2


+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [ancillary_2 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double rhoc = a[10];
    double Tc   = a[11];
    
    double phi = 1.0 - T/Tc;
    
    double rhs = a[0]*pow(phi, a[5]) + a[1]*pow(phi, a[6])
        + a[2]*pow(phi, a[7]) + a[3]*pow(phi, a[8]) + a[4]*pow(phi, a[9]);
    
    return rhoc*rhs;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 12;
}

- (NSString *)equationText
{
    return @"";
}

@end
