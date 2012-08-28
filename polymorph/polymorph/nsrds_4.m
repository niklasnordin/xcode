//
//  nsrds_4.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-28.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_4.h"

static NSString *name = @"nsrds_4";

@implementation nsrds_4

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_4 name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    
    double y = a[0] + a[1]/T + a[2]/pow(T, 3) + a[3]/pow(T, 8) + a[4]/pow(T, 9);
    
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
