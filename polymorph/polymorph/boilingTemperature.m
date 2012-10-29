//
//  boilingTemperature.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "boilingTemperature.h"

static NSString *name = @"boilingTemperature";

@implementation boilingTemperature

-(boilingTemperature *)initWithZero
{
    self = [super init];
    return self;
}

-(boilingTemperature *)initWithArray:(NSArray *)array
{
    self = [super init];
    return self;
}

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [boilingTemperature name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double errMax = 1.0e-3;
    double Tg = 300.0;
    double Tg0 = Tg;
    double dt = 10.0;
    //id<functionValue> pv = [_functionPointers objectForKey:@"Pv"];
    double pg0 = [_pv valueForT:Tg andP:p];
    int i = 0;
    while ((dt > errMax) && (i <100))
    {
        i++;
        double pg = [_pv valueForT:Tg andP:p];
        // if temperature gets too high it will probably return nan
        // so set the pressure to something slightly higher than previous guess
        if (isnan(pg)) {
            pg = 1.01*pg0;
        }
        pg = fmax(0.0, pg);
        Tg0 = Tg;
        if ((pg < p) && (pg0 < p))
        {
            Tg += dt;
        }
        else
        {
            if ((pg > p) && (pg0 > p))
            {
                Tg -= dt;
                Tg = fmax(0.5, Tg);
            }
            else
            {
                dt *= 0.1;
                // p is between pg and pg0
                // pg = Pv(Tg)
                // pg0 = Pv(Tg0)
                // p = Pv(Ta)
                Tg = Tg0 + (Tg - Tg0)*(p - pg0)/(pg - pg0);
            }
        }
        pg0 = pg;
        
    }
    return Tg;
}

-(bool)pressureDependent
{
    return YES;
}

-(bool)temperatureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 0;
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"Pv" ];
}

-(void)setFunction:(id<functionValue>)function forKey:(NSString *)key
{
    if ([key isEqualToString:@"Pv"])
    {
        _pv = function;
    }
}

-(NSArray *)coefficientNames
{
    return nil;
}

-(BOOL)requirementsFulfilled
{
    return (_pv != nil) ? YES : NO;
}

@end
