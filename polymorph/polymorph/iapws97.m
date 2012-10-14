//
//  iapws97.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97.h"
#import "iapws97_1.h"

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

-(double)PsForT:(double)T
{
    double theta = T/_tstar;
    double pi = _ni[0] + _ni[1]*theta + _ni[2]*theta*theta;
    return _pstar*pi;
}

-(double)TsForP:(double)p
{
    double pi = p/_pstar;
    double theta = _ni[3] + sqrt((pi-_ni[4])/_ni[2]);
    return _tstar*theta;
}

-(region)setRegionForPressure:(double)p andT:(double)T
{
    region reg = none;
    double pMeta = 10.0e+6;
    
    if (p > 100.0e+6)
    {
        return reg;
    }
    
    if (T < 1073.15)
    {
        if (T < 623.15)
        {
            if (T >= 273.15)
            {
                double p23 = [_iapws4 PsForT:T];
            
                if (p > p23)
                {
                    reg = reg1;
                }
                else
                {
                    if (p >pMeta)
                    {
                        reg = reg2;
                    }
                    else
                    {
                        reg = reg2b;
                    }
                }
            }
        }
        else
        {
            if (T < 863.15)
            {
                double ps = [self PsForT:T];
                if (p < ps)
                {
                    reg = reg2;
                }
                else
                {
                    reg = reg3;
                }
            }
            else
            {
                if (p < 100.0e+6)
                {
                    if (p < pMeta)
                    {
                        reg = reg2b;
                    }
                    else
                    {
                        reg = reg2;
                    }
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
                reg = reg5;
            }
        }
    }
    
    return reg;
}

-(double)rhoForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 rhoForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 rhoForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b rhoForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 rhoForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 rhoForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
}
@end
