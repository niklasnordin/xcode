//
//  iapws97_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-05.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_1.h"

static NSString *name = @"iapws97_1";
static int nCoeffs = 34;

@implementation iapws97_1

+(NSString *)name
{
    return name;
}

-(iapws97_1 *)initWithZero
{
    self = [super init];
    
    _ii = malloc(nCoeffs*sizeof(long double));
    _ji = malloc(nCoeffs*sizeof(long double));
    _ni = malloc(nCoeffs*sizeof(long double));
    
    for (int i=0; i<nCoeffs; i++)
    {
        _ii[i] = 0.0;
        _ji[i] = 0.0;
        _ni[i] = 0.0;
    }

    _pstar = 16.53e+6;
    _tstar = 1386.0;
    _R = 461.526;
    
    return self;
}

-(iapws97_1 *)initWithArray:(NSArray *)array
{
    self = [super init];

    _ii = malloc(nCoeffs*sizeof(long double));
    _ji = malloc(nCoeffs*sizeof(long double));
    _ni = malloc(nCoeffs*sizeof(long double));
    
    for (int i=0; i<nCoeffs; i++)
    {
        NSDictionary *Aidict = [array objectAtIndex:i];
        NSDictionary *Ajdict = [array objectAtIndex:i+nCoeffs];
        NSDictionary *Andict = [array objectAtIndex:i+2*nCoeffs];
        
        NSString *iname = [NSString stringWithFormat:@"i%d", i+1];
        NSString *jname = [NSString stringWithFormat:@"j%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"n%d", i+1];
        
        NSNumber *aik = [Aidict objectForKey:iname];
        NSNumber *ajk = [Ajdict objectForKey:jname];
        NSNumber *ank = [Andict objectForKey:nname];
        
        _ii[i] = [aik doubleValue];
        _ji[i] = [ajk doubleValue];
        _ni[i] = [ank doubleValue];
        
    }
    
    _tstar = [[[array objectAtIndex:102] objectForKey:@"Tstar"] doubleValue];
    _pstar = [[[array objectAtIndex:103] objectForKey:@"Pstar"] doubleValue];
    _R     = [[[array objectAtIndex:104] objectForKey:@"R"] doubleValue];
    
    return self;
}

-(NSString *) name
{
    return [iapws97_1 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double y = [self wForP:p andT:T];

    return y;
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
    return 105; //34*3 + 3;
}

- (NSString *)equationText
{
    return @"";
}

- (void)dealloc
{
    free(_ii);
    free(_ji);
    free(_ni);
}

-(NSArray *)dependsOnFunctions
{
    return nil;
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
}

-(long double)gammaForP:(long double)p andT:(long double)T
{
    long double pi = p/_pstar;
    long double tau = _tstar/T;
    
    long double a = 0.0;
    long double b = 0.0;
    long double sum = 0.0;
    for (int i=0; i<nCoeffs; i++)
    {
        a = powl(7.1 - pi, _ii[i]);
        b = powl(tau - 1.222, _ji[i]);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}

-(long double)dgdpForP:(long double)p andT:(long double)T
{
    long double pi = p/_pstar;
    long double tau = _tstar/T;
    
    long double a = 0.0;
    long double b = 0.0;
    long double sum = 0.0;
    for (int i=0; i<nCoeffs; i++)
    {
        a = -_ii[i]*powl(7.1 - pi, _ii[i]-1.0);
        b = powl(tau - 1.222, _ji[i]);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}

-(long double)d2gdp2ForP:(long double)p andT:(long double)T
{
    long double pi = p/_pstar;
    long double tau = _tstar/T;
    
    long double a = 0.0;
    long double b = 0.0;
    long double sum = 0.0;
    for (int i=0; i<nCoeffs; i++)
    {
        a = _ii[i]*(_ii[i]-1.0)*powl(7.1 - pi, _ii[i]-2.0);
        b = powl(tau - 1.222, _ji[i]);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}

-(long double)dgdtForP:(long double)p andT:(long double)T
{
    long double pi = p/_pstar;
    long double tau = _tstar/T;
    
    long double a = 0.0;
    long double b = 0.0;
    long double sum = 0.0;
    for (int i=0; i<nCoeffs; i++)
    {
        a = powl(7.1 - pi, _ii[i]);
        b = _ji[i]*powl(tau - 1.222, _ji[i]-1.0);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}


-(long double)d2gdt2ForP:(long double)p andT:(long double)T
{
    long double pi = p/_pstar;
    long double tau = _tstar/T;
    
    long double a = 0.0;
    long double b = 0.0;
    long double sum = 0.0;
    for (int i=0; i<nCoeffs; i++)
    {
        a = powl(7.1 - pi, _ii[i]);
        b = _ji[i]*(_ji[i]-1.0)*powl(tau - 1.222, _ji[i]-2.0);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}


-(long double)d2gdtdpForP:(long double)p andT:(long double)T
{
    long double pi = p/_pstar;
    long double tau = _tstar/T;
    
    long double a = 0.0;
    long double b = 0.0;
    long double sum = 0.0;
    for (int i=0; i<nCoeffs; i++)
    {
        a = -_ii[i]*powl(7.1 - pi, _ii[i]-1.0);
        b = _ji[i]*powl(tau - 1.222, _ji[i]-1.0);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}

-(double)vForP:(long double)p andT:(long double)T
{
    double gamma_p = [self dgdpForP:p andT:T];
    double pi = p/_pstar;
    
    double denom = _R*T*pi*gamma_p;
    return denom/p;
}

-(double)rhoForP:(long double)p andT:(long double)T
{
    return 1.0/[self vForP:p andT:T];
}

-(double)uForP:(long double)p andT:(long double)T
{
    double gamma_t = [self dgdtForP:p andT:T];
    double gamma_p = [self dgdpForP:p andT:T];
    
    double pi = p/_pstar;
    double tau = _tstar/T;

    return _R*T*(tau*gamma_t - pi*gamma_p);
}

-(double)hForP:(long double)p andT:(long double)T
{
    double gamma_t = [self dgdtForP:p andT:T];
    
    double tau = _tstar/T;
    
    return _R*T*tau*gamma_t;
}

-(double)sForP:(long double)p andT:(long double)T
{
    double gamma_t = [self dgdtForP:p andT:T];
    double gamma = [self gammaForP:p andT:T];
    
    double tau = _tstar/T;
    
    return _R*(tau*gamma_t - gamma);
}

-(double)cpForP:(long double)p andT:(long double)T
{
    double gamma_tt = [self d2gdt2ForP:p andT:T];
    
    double tau = _tstar/T;
    
    return -_R*tau*tau*gamma_tt;
}

-(double)cvForP:(long double)p andT:(long double)T
{
    double gamma_tt = [self d2gdt2ForP:p andT:T];
    double gamma_p = [self dgdpForP:p andT:T];
    double gamma_pp = [self d2gdp2ForP:p andT:T];
    double gamma_pt = [self d2gdtdpForP:p andT:T];
    
    double tau = _tstar/T;
    double nom = gamma_p - tau*gamma_pt;
    
    return _R*( -tau*tau*gamma_tt + nom*nom/gamma_pp );
}

-(double)wForP:(long double)p andT:(long double)T
{
    double gamma_tt = [self d2gdt2ForP:p andT:T];
    double gamma_p = [self dgdpForP:p andT:T];
    double gamma_pp = [self d2gdp2ForP:p andT:T];
    double gamma_pt = [self d2gdtdpForP:p andT:T];
    
    double tau = _tstar/T;
    
    double nom = gamma_p - tau*gamma_pt;
    double denom = nom*nom/(tau*tau*gamma_tt) - gamma_pp;
    
    return sqrt(_R*T*gamma_p*gamma_p/denom);
}

-(NSArray *)coefficientNames
{
     
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for (int i=0; i<nCoeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"i%d", i+1];
        [names addObject:name];
    }
    for (int i=0; i<nCoeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"j%d", i+1];
        [names addObject:name];
    }
    for (int i=0; i<nCoeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"n%d", i+1];
        [names addObject:name];
    }
    
    [names addObject:@"Tstar"];
    [names addObject:@"Pstar"];
    [names addObject:@"R"];

    return names;

}

@end
