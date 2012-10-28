//
//  iapws97_cv.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_cv.h"

static NSString *name = @"iapws97_cv";
static int nCoeffs = 5;

@implementation iapws97_cv

-(iapws97_cv *)initWithZero
{
    self = [super init];
    return self;
}

-(iapws97_cv *)initWithArray:(NSArray *)array
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
    return [iapws97_cv name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double Temp = fmax(T, 273.15);
    Temp = fmin(Temp, 2273.149999999);
    return [self cvForP:p andT:Temp];
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
