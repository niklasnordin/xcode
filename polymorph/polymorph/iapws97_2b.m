//
//  iapws97_2b.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-11.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_2b.h"

static NSString *name = @"iapws97_2b";
static int nCoeffs = 13;
static int n0Coeffs = 9;

@implementation iapws97_2b

+(NSString *)name
{
    return name;
}

-(iapws97_2b *)initWithZero
{
    self = [super init];
    
    _ii = malloc(nCoeffs*sizeof(long double));
    _ji = malloc(nCoeffs*sizeof(long double));
    _ni = malloc(nCoeffs*sizeof(long double));
    
    _j0i = malloc(n0Coeffs*sizeof(long double));
    _n0i = malloc(n0Coeffs*sizeof(long double));
    
    for (int i=0; i<nCoeffs; i++)
    {
        _ii[i] = 0.0;
        _ji[i] = 0.0;
        _ni[i] = 0.0;
    }
    
    
    for (int i=0; i<n0Coeffs; i++)
    {
        _j0i[i] = 0.0;
        _n0i[i] = 0.0;
    }
    
    _pstar = 1.0e+6;
    _tstar = 540.0;
    _R = 461.526;
    
    return self;
}

-(iapws97_2b *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    _ii = malloc(nCoeffs*sizeof(long double));
    _ji = malloc(nCoeffs*sizeof(long double));
    _ni = malloc(nCoeffs*sizeof(long double));
    
    _j0i = malloc(n0Coeffs*sizeof(long double));
    _n0i = malloc(n0Coeffs*sizeof(long double));
    
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
    
    for (int i=0; i<n0Coeffs; i++)
    {
        NSDictionary *Ajdict = [array objectAtIndex:i+3*nCoeffs];
        NSDictionary *Andict = [array objectAtIndex:i+3*nCoeffs + n0Coeffs];
        
        NSString *jname = [NSString stringWithFormat:@"j0_%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"n0_%d", i+1];
        
        NSNumber *ajk = [Ajdict objectForKey:jname];
        NSNumber *ank = [Andict objectForKey:nname];
        
        _j0i[i] = [ajk doubleValue];
        _n0i[i] = [ank doubleValue];
        
    }
    
    _tstar = [[[array objectAtIndex:nCoeffs*3+2*n0Coeffs] objectForKey:@"Tstar"] doubleValue];
    _pstar = [[[array objectAtIndex:nCoeffs*3+2*n0Coeffs + 1] objectForKey:@"Pstar"] doubleValue];
    _R     = [[[array objectAtIndex:nCoeffs*3+2*n0Coeffs + 2] objectForKey:@"R"] doubleValue];
    
    return self;
}

-(NSString *) name
{
    return [iapws97_2b name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double y = [self vForP:p andT:T];
    
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
    return nCoeffs*3 + n0Coeffs*2 + 3;
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
        a = powl(pi, _ii[i]);
        b = powl(tau - 0.5, _ji[i]);
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
        a = _ii[i]*powl(pi, _ii[i]-1.0);
        b = powl(tau - 0.5, _ji[i]);
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
        a = _ii[i]*(_ii[i]-1.0)*powl(pi, _ii[i]-2.0);
        b = powl(tau - 0.5, _ji[i]);
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
        a = powl(pi, _ii[i]);
        b = _ji[i]*powl(tau - 0.5, _ji[i]-1.0);
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
        a = powl(pi, _ii[i]);
        b = _ji[i]*(_ji[i]-1.0)*powl(tau - 0.5, _ji[i]-2.0);
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
        a = _ii[i]*powl(pi, _ii[i]-1.0);
        b = _ji[i]*powl(tau - 0.5, _ji[i]-1.0);
        sum += _ni[i]*a*b;
    }
    
    return sum;
}

-(double)gamma0ForP:(long double)p andT:(long double)T
{
    double pi = p/_pstar;
    double tau = _tstar/T;
    
    double g0 = log(pi);
    for (int i=0; i<n0Coeffs; i++)
    {
        g0 += _n0i[i]*powl(tau, _j0i[i]);
    }
    return g0;
}

-(double)dg0dpForP:(long double)p andT:(long double)T
{
    double pi = p/_pstar;
    
    return 1.0/pi;
}

-(double)d2g0dp2ForP:(long double)p andT:(long double)T
{
    double pi = p/_pstar;
    
    return -1.0/(pi*pi);
}

-(double)dg0dtForP:(long double)p andT:(long double)T
{
    double tau = _tstar/T;
    
    double g0 = 0.0;
    for (int i=0; i<n0Coeffs; i++)
    {
        g0 += _n0i[i]*_j0i[i]*powl(tau, _j0i[i]-1.0);
    }
    return g0;
}

-(double)d2g0dt2ForP:(long double)p andT:(long double)T
{
    double tau = _tstar/T;
    
    double g0 = 0.0;
    for (int i=0; i<n0Coeffs; i++)
    {
        g0 += _n0i[i]*_j0i[i]*(_j0i[i]-1.0)*powl(tau, _j0i[i]-2.0);
    }
    return g0;
}

-(double)d2g0dtdpForP:(long double)p andT:(long double)T
{
    return 0.0;
}

-(double)vForP:(long double)p andT:(long double)T
{
    double gamma_p = [self dgdpForP:p andT:T];
    double gamma0_p = [self dg0dpForP:p andT:T];
    double pi = p/_pstar;
    
    double denom = _R*T*pi*(gamma0_p + gamma_p);
    return denom/p;
}

-(double)rhoForP:(long double)p andT:(long double)T
{
    return 1.0/[self vForP:p andT:T];
}

-(double)uForP:(long double)p andT:(long double)T
{
    double gamma0_t = [self dg0dtForP:p andT:T];
    double gamma0_p = [self dg0dpForP:p andT:T];
    
    double gamma_t = [self dgdtForP:p andT:T];
    double gamma_p = [self dgdpForP:p andT:T];
    
    double pi = p/_pstar;
    double tau = _tstar/T;
    
    return _R*T*(tau*(gamma0_t + gamma_t) - pi*(gamma0_p+gamma_p));
}

-(double)hForP:(long double)p andT:(long double)T
{
    double gamma0_t = [self dg0dtForP:p andT:T];
    double gamma_t = [self dgdtForP:p andT:T];
    
    double tau = _tstar/T;
    
    return _R*T*tau*(gamma0_t+gamma_t);
}

-(double)sForP:(long double)p andT:(long double)T
{
    double gamma0_t = [self dg0dtForP:p andT:T];
    double gamma0 = [self gamma0ForP:p andT:T];
    
    double gamma_t = [self dgdtForP:p andT:T];
    double gamma = [self gammaForP:p andT:T];
    
    double tau = _tstar/T;
    
    return _R*(tau*(gamma0_t + gamma_t) - (gamma0 + gamma));
}

-(double)cpForP:(long double)p andT:(long double)T
{
    double gamma_tt = [self d2gdt2ForP:p andT:T];
    double gamma0_tt = [self d2g0dt2ForP:p andT:T];
    
    double tau = _tstar/T;
    
    return -_R*tau*tau*(gamma0_tt+gamma_tt);
}

-(double)cvForP:(long double)p andT:(long double)T
{
    double pi = p/_pstar;
    double tau = _tstar/T;
    
    double gamma0_tt = [self d2g0dt2ForP:p andT:T];
    
    double gamma_tt = [self d2gdt2ForP:p andT:T];
    double gamma_p = [self dgdpForP:p andT:T];
    double gamma_pp = [self d2gdp2ForP:p andT:T];
    double gamma_pt = [self d2gdtdpForP:p andT:T];
    
    double nom = 1.0 + pi*gamma_p - tau*pi*gamma_pt;
    double denom = 1.0 - pi*pi*gamma_pp;
    
    return -_R*( tau*tau*(gamma0_tt+gamma_tt) + nom*nom/denom );
}

-(double)wForP:(long double)p andT:(long double)T
{
    double pi = p/_pstar;
    double tau = _tstar/T;
    
    double gamma0_tt = [self d2g0dt2ForP:p andT:T];
    
    double gamma_tt = [self d2gdt2ForP:p andT:T];
    double gamma_p = [self dgdpForP:p andT:T];
    double gamma_pp = [self d2gdp2ForP:p andT:T];
    double gamma_pt = [self d2gdtdpForP:p andT:T];
    
    double nom = 1.0 + 2.0*pi*gamma_p + pi*pi*gamma_p*gamma_p;
    double A = 1.0 + pi*gamma_p - tau*pi*gamma_pt;
    double B = tau*tau*(gamma0_tt + gamma_tt);
    double denom = (1.0 - pi*pi*gamma_pp) + A*A/B;
    
    return sqrt(_R*T*nom/denom);
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
    
    
    for (int i=0; i<n0Coeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"j0_%d", i+1];
        [names addObject:name];
    }
    
    for (int i=0; i<n0Coeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"n0_%d", i+1];
        [names addObject:name];
    }
    
    [names addObject:@"Tstar"];
    [names addObject:@"Pstar"];
    [names addObject:@"R"];
    
    return names;
}

@end
