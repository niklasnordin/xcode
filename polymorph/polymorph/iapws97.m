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
    if (T < 273.15)
    {
        return reg;
    }
    
    if (T < 1073.15)
    {
        if (T < 623.15)
        {
            double ps = [_iapws4 PsForT:T];


            //NSLog(@"p=%g, ps=%g, T=%g, Ts=%g",p,ps,T,Ts);
            //NSLog(@"h=%g, hs=%g, f=%g",h,hs,frac);
            if (p >= ps)
            {
                /*
                double Ts = [_iapws4 TsForp:p];
                double h = [_iapws1 hForP:p andT:T];
                double hs = [_iapws1 hForP:p andT:Ts];
                double frac = fabs((h-hs)/hs);
                 */
                reg = reg1;
                //reg = (frac < 0.05) ? reg2b : reg1;
            }
            else
            {
                if (p > pMeta)
                {
                    reg = reg2;
                }
                else
                {
                    // calculate enthalpies to determine region
                    double Ts = [_iapws4 TsForp:p];
                    double h = [_iapws2b hForP:p andT:T];
                    double hs = [_iapws2b hForP:p andT:Ts];
                    double frac = fabs((h-hs)/hs);

                    reg = (frac < 0.05) ? reg2b : reg2;
                    /*
                    if (reg == reg2b)
                    {
                        NSLog(@"reg2b: T=%g, p=%g, f=%g",T,p,frac);
                    }
                     */
                    //reg = reg2;
                }
            }
        }
        else
        {
            if (T <= 863.15)
            {
                double p23 = [self PsForT:T];
                if (p < p23)
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
                    reg = reg2;
                }
            }
        }
    }
    else
    {
        if (T < 2273.15)
        {
            if (p <= 50.0e+6)
            {
                reg = reg5;
            }
        }
    }
    
    //NSLog(@"p = %g, T = %g, reg = %d",p,T,reg);
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

-(double)uForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 uForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 uForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b uForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 uForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 uForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
}

-(double)hForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 hForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 hForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b hForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 hForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 hForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
}

-(double)sForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 sForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 sForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b sForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 sForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 sForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
}

-(double)cpForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 cpForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 cpForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b cpForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 cpForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 cpForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
}

-(double)cvForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 cvForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 cvForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b cvForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 cvForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 cvForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
}

-(double)wForP:(double)p andT:(long double)T
{
    region reg = [self setRegionForPressure:p andT:T];
    
    double value = 0.0;
    
    switch (reg) {
        case reg1:
            value = [_iapws1 wForP:p andT:T];
            break;
            
        case reg2:
            value = [_iapws2 wForP:p andT:T];
            break;
            
        case reg2b:
            value = [_iapws2b wForP:p andT:T];
            break;
            
        case reg3:
            value = [_iapws3 wForP:p andT:T];
            break;
            
        case reg5:
            value = [_iapws5 wForP:p andT:T];
            break;
            
        default:
            break;
    }
    
    return value;
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

-(BOOL)requirementsFulfilled
{
    
    BOOL fulfilled = YES;
    
    if (_iapws1 == nil)
    {
        fulfilled = NO;
    }
    else
    {
        Class fc = (NSClassFromString(@"iapws97_1"));
        if ([_iapws1 class] != [fc class])
        {
            fulfilled = NO;
        }
    }
    
    if (_iapws2 == nil)
    {
        fulfilled = NO;
    }
    else
    {
        Class fc = (NSClassFromString(@"iapws97_2"));
        if ([_iapws2 class] != [fc class])
        {
            fulfilled = NO;
        }
    }
    
    if (_iapws2b == nil)
    {
        fulfilled = NO;
    }
    else
    {
        Class fc = (NSClassFromString(@"iapws97_2b"));
        if ([_iapws2b class] != [fc class])
        {
            fulfilled = NO;
        }
    }

    if (_iapws3 == nil)
    {
        fulfilled = NO;
    }
    else
    {
        Class fc = (NSClassFromString(@"iapws97_3"));
        if ([_iapws3 class] != [fc class])
        {
            fulfilled = NO;
        }
    }

    if (_iapws4 == nil)
    {
        fulfilled = NO;
    }
    else
    {
        Class fc = (NSClassFromString(@"iapws97_4"));
        if ([_iapws4 class] != [fc class])
        {
            fulfilled = NO;
        }
    }

    if (_iapws5 == nil)
    {
        fulfilled = NO;
    }
    else
    {
        Class fc = (NSClassFromString(@"iapws97_5"));
        if ([_iapws5 class] != [fc class])
        {
            fulfilled = NO;
        }
    }

    return fulfilled;
}
@end
