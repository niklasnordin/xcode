//
//  nsrds_2.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-28.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_2.h"

static NSString *name = @"nsrds_2";

@implementation nsrds_2

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_2 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    
    double y = a[0]*pow(T, a[1])/(1.0 + a[2]/T + a[3]/T/T);
    
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
