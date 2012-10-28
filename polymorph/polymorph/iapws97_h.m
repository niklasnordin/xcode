//
//  iapws97_h.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_h.h"


static NSString *name = @"iapws97_h";
static int nCoeffs = 5;

@implementation iapws97_h

-(iapws97_h *)initWithZero
{
    self = [super init];
    return self;
}

-(iapws97_h *)initWithArray:(NSArray *)array
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
    return [iapws97_h name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double Temp = fmax(T, 273.15);
    Temp = fmin(Temp, 2273.149999999);
    return [self hForP:p andT:Temp];
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
