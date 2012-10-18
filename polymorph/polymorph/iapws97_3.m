//
//  iapws97_3.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-11.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_3.h"

static NSString *name = @"iapws97_3";
static int nCoeffs = 40;

@implementation iapws97_3

-(iapws97_3 *)initWithZero
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
    
    _tstar = 1386.0;
    _rhostar = 16.53e+6;
    _R = 461.526;

    return self;
}

-(iapws97_3 *)initWithArray:(NSArray *)array
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
    
    _tstar = [[[array objectAtIndex:3*nCoeffs] objectForKey:@"Tstar"] doubleValue];
    _rhostar = [[[array objectAtIndex:3*nCoeffs+1] objectForKey:@"rhostar"] doubleValue];
    _R     = [[[array objectAtIndex:3*nCoeffs+2] objectForKey:@"R"] doubleValue];

    return self;
}

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [iapws97_3 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return [self rhoForP:p andT:T];
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
    return 3*nCoeffs+3;
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return nil;
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
}

-(long double)phiForDelta:(long double)delta andTau:(long double)tau
{
    long double sum = _ni[0]*log(delta);
    for (int i=1; i<nCoeffs; i++)
    {
        long double a = powl(delta, _ii[i]);
        long double b = powl(tau, _ji[i]);
        sum += _ni[i]*a*b;
    }
    return sum;
}

-(long double)dphiddForDelta:(long double)delta andTau:(long double)tau
{
    long double sum = _ni[0]/delta;
    for (int i=1; i<nCoeffs; i++)
    {
        long double a = _ii[i]*powl(delta, _ii[i]-1.0);
        long double b = powl(tau, _ji[i]);
        sum += _ni[i]*a*b;
    }
    return sum;
}

-(long double)d2phidd2ForDelta:(long double)delta andTau:(long double)tau
{
    long double sum = -_ni[0]/delta/delta;
    for (int i=1; i<nCoeffs; i++)
    {
        long double a = _ii[i]*(_ii[i]-1.0)*powl(delta, _ii[i]-2.0);
        long double b = powl(tau, _ji[i]);
        sum += _ni[i]*a*b;
    }
    return sum;
}

-(long double)dphidtForDelta:(long double)delta andTau:(long double)tau
{
    long double sum = 0.0;
    for (int i=1; i<nCoeffs; i++)
    {
        long double a = powl(delta, _ii[i]);
        long double b = _ji[i]*powl(tau, _ji[i]-1.0);
        sum += _ni[i]*a*b;
    }
    return sum;
}

-(long double)d2phidt2ForDelta:(long double)delta andTau:(long double)tau
{
    long double sum = 0.0;
    for (int i=1; i<nCoeffs; i++)
    {
        long double a = powl(delta, _ii[i]);
        long double b = _ji[i]*(_ji[i]-1.0)*powl(tau, _ji[i]-2.0);
        sum += _ni[i]*a*b;
    }
    return sum;
}

-(long double)d2phidtddForDelta:(long double)delta andTau:(long double)tau
{
    long double sum = 0.0;
    for (int i=1; i<nCoeffs; i++)
    {
        long double a = _ii[i]*powl(delta, _ii[i]-1.0);
        long double b = _ji[i]*powl(tau, _ji[i]-1.0);
        sum += _ni[i]*a*b;
    }
    return sum;
}

-(double)vForP:(long double)p andT:(long double)T
{
    
    return 1.0/[self rhoForP:p andT:T];
}

-(double)rhoForP:(long double)p andT:(long double)T
{
    return 1.0/[self vForP:p andT:T];
/*
    double tau = _tstar/T;
    double q = _rhostar*_R*T;
    double pq = p/q;
    
    double rhox = _rhostar;
    
    if (T < _tstar)
    {
        double pvap = [_pv valueForT:T andP:p];
        
        if (p > pvap)
        {
            rhox = [_rholSat valueForT:T andP:p];
        }
        else
        {
            rhox = [_rhovSat valueForT:T andP:p];
        }
    }

    //rhox = 600.0;
    int i = 0;
    int N = 100;
    double err = 1.0;
    double delta = rhox/_rhostar;
    double tol = 1.0e-9;
    double urlx = 0.95;
    
    while ((err > tol) && (i < N))
    {
        // pq = delta*delta*(A + eps*B)
        // A delta^2 + delta - pq = 0
        double A = [self dphiddForDelta:delta andTau:tau];
        double B = [self d2phidd2ForDelta:delta andTau:tau];
        double d2 = delta*delta;
        
        double nom = pq - d2*A;
        double denom = delta*(delta*B + 2.0*A);
        //double nom = pq/d2 - A;
        //double denom = B;
        double d = nom/denom;
        err = fabs(d);
        
        // dont take too large steps
        if (d > 0)
        {
            d = fmin(urlx*delta, d);
        }
        else
        {
            d = -fmin(-d, urlx*delta);
        }
        
        delta += 0.9*d;
        delta = fmax(1.0e-30, delta);
        //NSLog(@"%d. e=%g, d")
        i++;
    }
    rhox = delta*_rhostar;
    double pRho = [self pForRho:rhox andT:T];
    if (fabs(pRho-p) > 1.0)
    {
        NSLog(@"rhox = %g, err = %g, p=%Lg, prho=%g, it=%d",rhox, err, p, pRho,i);
    }
    
    return rhox;
    //return delta*_rhostar;
*/
}

-(double)uForP:(long double)p andT:(long double)T
{
    long double rho = [self rhoForP:p andT:T];
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
    return _R*T*tau*[self dphidtForDelta:delta andTau:tau];
}

-(double)hForP:(long double)p andT:(long double)T
{
    long double rho = [self rhoForP:p andT:T];
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
    
    return _R*T*(tau*[self dphidtForDelta:delta andTau:tau] + delta*[self dphiddForDelta:delta andTau:tau]);
}

-(double)sForP:(long double)p andT:(long double)T
{
    long double rho = [self rhoForP:p andT:T];
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
    
    return _R*(tau*[self dphidtForDelta:delta andTau:tau] - [self phiForDelta:delta andTau:tau]);
}

-(double)cvForP:(long double)p andT:(long double)T
{
    long double rho = [self rhoForP:p andT:T];
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
    
    return _R*tau*tau*[self d2phidt2ForDelta:delta andTau:tau];
}

-(double)cpForP:(long double)p andT:(long double)T
{
    long double rho = [self rhoForP:p andT:T];
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
    
    double cv = -tau*tau*[self d2phidt2ForDelta:delta andTau:tau];
    
    double dphidd = [self dphiddForDelta:delta andTau:tau];
    double nom = delta*dphidd - delta*tau*[self d2phidtddForDelta:delta andTau:tau];
    double denom = 2.0*delta*dphidd + delta*delta*[self d2phidd2ForDelta:delta andTau:tau];
    return _R*(cv + nom*nom/denom);
}

-(double)wForP:(long double)p andT:(long double)T
{
    long double rho = [self rhoForP:p andT:T];
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
 
    long double dphidd = [self dphiddForDelta:delta andTau:tau];
    //long double dphidt = [self dphidtForDelta:delta andTau:tau];
    long double d2phidd = [self d2phidd2ForDelta:delta andTau:tau];
    long double d2phidt = [self d2phidt2ForDelta:delta andTau:tau];
    long double dddt = [self d2phidtddForDelta:delta andTau:tau];
    
    long nom = delta*dphidd - delta*tau*dddt;
    long denom = tau*tau*d2phidt;
    
    return _R*T*(2.0*delta*dphidd + delta*delta*d2phidd - nom*nom/denom);
}

-(double)pForRho:(long double)rho andT:(long double)T
{
    long double delta = rho/_rhostar;
    long double tau = _tstar/T;
    
    double dphi = [self dphiddForDelta:delta andTau:tau];
    
    return rho*_R*T*delta*dphi;
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
    [names addObject:@"rhostar"];
    [names addObject:@"R"];
    
    return names;

}

@end
