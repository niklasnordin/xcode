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

-(NSArray *)dependsOnFunctions
{
    return @[ @"iapws97_1", @"iapws97_2", @"iapws97_2b", @"iapws97_3", @"iapws97_4", @"iapws97_5" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    if ([key isEqualToString:@"iapws97_1"])
    {
        self.iapws1 = function;
    }
    
    if ([key isEqualToString:@"iapws97_2"])
    {
        self.iapws2 = function;
    }
    
    if ([key isEqualToString:@"iapws97_2b"])
    {
        self.iapws2b = function;
    }
    
    if ([key isEqualToString:@"iapws97_3"])
    {
        self.iapws3 = function;
    }
    
    if ([key isEqualToString:@"iapws97_4"])
    {
        self.iapws4 = function;
    }
    
    if ([key isEqualToString:@"iapws97_5"])
    {
        self.iapws5 = function;
    }
}

-(NSArray *)coefficientNames
{
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for (int i=0; i<nCoeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"n%d", i+1];
        [names addObject:name];
    }
    
    [names addObject:@"Tstar"];
    [names addObject:@"Pstar"];
    
    return names;
    
}

@end
