//
//  nsrds_3.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-28.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_3.h"

static NSString *name = @"nsrds_3";

@implementation nsrds_3

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_3 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    
    double y = a[0] + a[1]*exp(-a[2]/pow(T, a[3]));
    
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
