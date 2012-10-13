//
//  iapws97.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97.h"

static NSString *name = @"iapws97";
static int nCoeffs = 5;

@implementation iapws97

-(iapws97 *)initWithZero
{
    self = [super init];
    _ni = malloc(nCoeffs*sizeof(long double));
     
    for (int i=0; i<nCoeffs; i++)
    {
        _ni[i] = 0.0;
    }
     
    _tstar = 1.0;
    _pstar = 1.0e+6;

    return self;
}

-(iapws97 *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    _ni = malloc(nCoeffs*sizeof(long double));

    for (int i=0; i<nCoeffs; i++)
    {
        NSDictionary *Aidict = [array objectAtIndex:i];
        NSString *iname = [NSString stringWithFormat:@"n%d", i+1];
        NSNumber *aik = [Aidict objectForKey:iname];
     
        _ni[i] = [aik doubleValue];
    }
     
     _tstar = [[[array objectAtIndex:nCoeffs] objectForKey:@"Tstar"] doubleValue];
     _pstar = [[[array objectAtIndex:nCoeffs+1] objectForKey:@"Pstar"] doubleValue];

    return self;
}

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [iapws97 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return 0.0;
}

-(double)pressureForT:(double)T
{
    double theta = T/_tstar;
    double pi = _ni[0] + _ni[1]*theta + _ni[2]*theta*theta;
    return _pstar*pi;
}

-(double)temperatureForP:(double)p
{
    double pi = p/_pstar;
    double theta = _ni[3] + sqrt((pi-_ni[4])/_ni[2]);
    return _tstar*theta;
}

-(int)setRegionForPressure:(double)p andT:(double)T
{
    int region = -1;
    if (T < 1073.15)
    {
        if (T < 623.15)
        {
            if (T > 273.15)
            {
                double p23 = [_iapws4 saturationPressureForT:T];
            
                if (p > p23)
                {
                    region = 1;
                }
                else
                {
                    region = 2;
                }
            }
        }
        else
        {
            if (T < 863.15)
            {
                double ps = [self pressureForT:T];
                if (p < ps)
                {
                    region = 2;
                }
            }
            else
            {
                if (p < 100.0e+6)
                {
                    region = 2;
                }
            }
        }
    }
    else
    {
        if (T < 2273.15)
        {
            if (p < 50.0e+6)
            {
                region = 5;
            }
        }
    }
    
    return region;
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
        _iapws1 = function;
    }
    
    if ([key isEqualToString:@"iapws97_2"])
    {
        _iapws2 = function;
    }
    
    if ([key isEqualToString:@"iapws97_2b"])
    {
        _iapws2b = function;
    }
    
    if ([key isEqualToString:@"iapws97_3"])
    {
        _iapws3 = function;
    }
    
    if ([key isEqualToString:@"iapws97_4"])
    {
        _iapws4 = function;
    }
    
    if ([key isEqualToString:@"iapws97_5"])
    {
        _iapws5 = function;
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
