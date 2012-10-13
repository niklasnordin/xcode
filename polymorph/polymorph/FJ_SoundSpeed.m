//
//  fundamentalJacobsenSoundSpeed.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "FJ_SoundSpeed.h"

static NSString *name = @"FJ_SoundSpeed";

@implementation FJ_SoundSpeed

#define Rgas 8314.462175

-(FJ_SoundSpeed *)initWithZero
{
    self = [super initWithZero];
    return self;
}

-(FJ_SoundSpeed *)initWithArray:(NSArray *)array
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
    return [FJ_SoundSpeed name];
}

-(double)valueForT:(double)Temperature andP:(double)pressure
{
    double rho = [_rho valueForT:Temperature andP:pressure]/[self mw];
    double delta = rho/[self rhoc];
    double tau = [self tc]/Temperature;
        
    double cv1 = [self d2a0dt2:pressure T:Temperature cp0:_cp0];
    double cv2 = [self d2aResdt2:delta t:tau];
    
    double cv = -Rgas*tau*tau*(cv1 + cv2);
    
    double t1 = [self daResdd:delta t:tau];
    double t2 = [self d2aResdddt:delta t:tau];
    double t3 = [self d2aResdd2:delta t:tau];
    
    double nom = 1.0 + delta*t1 - delta*tau*t2;
    double denom = 1.0 + 2.0*delta*t1 + delta*delta*t3;
       
    double cp = cv + Rgas*nom*nom/denom;
        
    double w2 = Rgas*Temperature*(cp/cv)*(1.0 + 2.0*delta*t1 + delta*delta*t3)/[self mw];
    return sqrt(w2);
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
