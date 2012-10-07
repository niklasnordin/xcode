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
    
    double cv = [_cv valueForT:Temperature andP:pressure];
    double cp = [_cp valueForT:Temperature andP:pressure];
    
    double t1 = [self daResdd:delta t:tau];
    double t2 = [self d2aResdd2:delta t:tau];
    
    double w2 = Rgas*Temperature*(cp/cv)*(1.0 + 2.0*delta*t1 + delta*delta*t2)/[self mw];
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
    return @[ @"cp", @"cv", @"rho" ];

}

-(void)setFunction:(id)function forKey:(NSString *)key
{

    if ([key isEqualToString:@"rho"])
    {
        _rho = function;
    }
    
    if ([key isEqualToString:@"cv"])
    {
        _cv = function;
    }

    if ([key isEqualToString:@"cp"])
    {
        _cp = function;
    }
}

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


@end
