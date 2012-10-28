//
//  iapws97_rho.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-14.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_rho.h"

static NSString *name = @"iapws97_rho";
static int nCoeffs = 5;

@implementation iapws97_rho

-(iapws97_rho *)initWithZero
{
    self = [super init];
    return self;
}

-(iapws97_rho *)initWithArray:(NSArray *)array
{
    self = [super initWithArray:array];
    return self;
}

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [iapws97_rho name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double Temp = fmax(T, 273.15);
    Temp = fmin(Temp, 2273.149999999);
    return [self rhoForP:p andT:Temp];
}

-(bool)pressureDependent
{
    return YES;
}

-(bool)temperatureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return nCoeffs+2;
}

- (NSString *)equationText
{
    return @"";
}

-(BOOL)requirementsFulfilled
{
    return YES;
}

@end
