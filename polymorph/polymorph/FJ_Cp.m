//
//  fundamentalJacobsenCp.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-23.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "FJ_Cp.h"

static NSString *name = @"FJ_Cp";

@implementation FJ_Cp

#define Rgas 8314.462175

+(NSString *)name
{
    return name;
}

-(FJ_Cp *)initWithZero
{
    self = [super initWithZero];
    return self;
}

-(FJ_Cp *)initWithArray:(NSArray *)array
{
    self = [super initWithArray:array];
    return self;
}

-(NSString *) name
{
    return [FJ_Cp name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return [self cp:p T:T];
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

-(double)cp:(double)pressure T:(double)Temperature
{
    //double cv = [_cv valueForT:Temperature andP:pressure];
    
    double tau = [self tc]/Temperature;
    double rho = [_rho valueForT:Temperature andP:pressure]/[self mw];
    double delta = rho/[self rhoc];
    
    double t1 = [self daResdd:delta t:tau];
    double t2 = [self d2aResdddt:delta t:tau];
    double t3 = [self d2aResdd2:delta t:tau];

    double nom = 1.0 + delta*t1 - delta*tau*t2;
    double denom = 1.0 + 2.0*delta*t1 + delta*delta*t3;

    double cv1 = [self d2a0dt2:pressure T:Temperature cp0:_cp0];
    double cv2 = [self d2aResdt2:delta t:tau];
    
    double cv = -tau*tau*(cv1 + cv2);

    double cp = cv + nom*nom/denom;
    return cp*Rgas/[self mw];
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
/*
-(NSArray *)coefficientNames
{
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (int i=0; i<96; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
        [names addObject:name];
    }
    return names;

}
*/

@end
