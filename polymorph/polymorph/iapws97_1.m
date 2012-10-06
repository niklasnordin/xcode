//
//  iapws97_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-05.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_1.h"

static NSString *name = @"iapws97_1";

@implementation iapws97_1

+(NSString *)name
{
    return name;
}

-(iapws97_1 *)initWithZero
{
    self = [super init];
    
    int n = 34;
    
    _ii = malloc(n*sizeof(long double));
    _ji = malloc(n*sizeof(long double));
    _ni = malloc(n*sizeof(long double));
    
    for (int i=0; i<n; i++)
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

    int n = 34;
    
    _ii = malloc(n*sizeof(long double));
    _ji = malloc(n*sizeof(long double));
    _ni = malloc(n*sizeof(long double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Aidict = [array objectAtIndex:i];
        NSDictionary *Ajdict = [array objectAtIndex:i+n];
        NSDictionary *Andict = [array objectAtIndex:i+2*n];
        
        NSString *iname = [NSString stringWithFormat:@"A%d", i];
        NSString *jname = [NSString stringWithFormat:@"A%d", i+n];
        NSString *nname = [NSString stringWithFormat:@"A%d", i+2*n];
        
        NSNumber *aik = [Aidict objectForKey:iname];
        NSNumber *ajk = [Ajdict objectForKey:jname];
        NSNumber *ank = [Andict objectForKey:nname];
        
        _ii[i] = [aik doubleValue];
        _ji[i] = [ajk doubleValue];
        _ni[i] = [ank doubleValue];
        
    }
    
    _pstar = [[[array objectAtIndex:102] objectForKey:@"A102"] doubleValue];
    _tstar = [[[array objectAtIndex:103] objectForKey:@"A103"] doubleValue];
    _R     = [[[array objectAtIndex:104] objectForKey:@"A104"] doubleValue];
    
    return self;
}

-(NSString *) name
{
    return [iapws97_1 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double y = [self rhoForP:p andT:T];

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
    for (int i=0; i<34; i++)
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
    for (int i=0; i<34; i++)
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
    for (int i=0; i<34; i++)
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
    for (int i=0; i<34; i++)
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
    for (int i=0; i<34; i++)
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
    for (int i=0; i<34; i++)
    {
        a = -_ii[i]*powl(7.1 - pi, _ii[i]);
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
    
    return _R*( -tau*tau*gamma_tt + nom*nom/gamma_pp);
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
    
    return _R*T*gamma_p*gamma_p/denom;
}

@end
