//
//  idealGasLaw.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-18.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "idealGasLaw.h"

static NSString *name = @"idealGasLaw";

@implementation idealGasLaw

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [idealGasLaw name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    a[0] = 0.0;
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    double y = 0.0;
    double y1 = p/( a[0]*T );
    
    if (y1) y = y1;
    return y;
}

-(int)nCoefficients
{
    return 1;
}

@end
