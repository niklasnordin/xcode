//
//  fundamentalJacobsenCv.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-22.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "FJ_Cv.h"

static NSString *name = @"FJ_Cv";

@implementation FJ_Cv

#define Rgas 8314.462175

+(NSString *)name
{
    return name;
}

-(FJ_Cv *)initWithZero
{
    self = [super initWithZero];
    return self;
}

-(FJ_Cv *)initWithArray:(NSArray *)array
{
    self = [super initWithArray:array];
    return self;
}

-(NSString *) name
{
    return [FJ_Cv name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return [self cv:p T:T];
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
    return 96;
}


-(double)cv:(double)pressure T:(double)Temperature
{
    double tau = [self tc]/Temperature;
    double rho = [_rho valueForT:Temperature andP:pressure]/[self mw];
    
    double delta = rho/[self rhoc];
    double cv1 = [self d2a0dt2:pressure T:Temperature cp0:_cp0];
    double cv2 = [self d2aResdt2:delta t:tau];

    return -Rgas*tau*tau*(cv1 + cv2)/[self mw];
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"cp0", @"rho" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    
    if ([key isEqualToString:@"rho"])
    {
        _rho = function;
    }
    
    if ([key isEqualToString:@"cp0"])
    {
        _cp0 = function;
    }
}

@end
