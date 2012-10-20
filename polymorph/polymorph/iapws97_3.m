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

    _tbackstar = 1.0;
    _pbackstar = 1.0e+6;
    
    int nVar = 5;
    
    _it3ab = malloc(nVar*sizeof(long double));
    _nt3ab = malloc(nVar*sizeof(long double));
    
    for (int i=0; i<nVar; i++)
    {
        _it3ab[i] = 0.0;
        _nt3ab[i] = 0.0;
    }
    
    _it3cd = malloc(4*sizeof(long double));
    _nt3cd = malloc(4*sizeof(long double));

    for (int i=0; i<4; i++)
    {
        _it3cd[i] = 0.0;
        _nt3cd[i] = 0.0;
    }
    
    _ct3ef = malloc(3*sizeof(long double));

    for (int i=0; i<3; i++)
    {
        _ct3ef[i] = 0.0;
    }
    
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


    int nOff = 3*nCoeffs+3;
    int nVar = 5;
    NSLog(@"size = %d, nOff = %d",[array count],nOff);
    
    _it3ab = malloc(nVar*sizeof(long double));
    _nt3ab = malloc(nVar*sizeof(long double));
    
    // ab
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3ab_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3ab_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3ab[i] = [aik doubleValue];
        _nt3ab[i] = [ank doubleValue];
        
    }
    
    nOff += 2*nVar;
    nVar = 4;
    _it3cd = malloc(nVar*sizeof(long double));
    _nt3cd = malloc(nVar*sizeof(long double));
    
    // cd
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3cd_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3cd_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3cd[i] = [aik doubleValue];
        _nt3cd[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;
    
    _ct3ef = malloc(nVar*sizeof(long double));
    
    // ef
    for (int i=0; i<3; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSString *iname = [NSString stringWithFormat:@"t3ef_c%d", i+1];
        NSNumber *aik = [idict objectForKey:iname];
        _ct3ef[i] = [aik doubleValue];
        
    }
    nOff += 3;

    // gh
    nVar = 5;
    _it3gh = malloc(nVar*sizeof(long double));
    _nt3gh = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3gh_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3gh_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3gh[i] = [aik doubleValue];
        _nt3gh[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    // ij
    nVar = 5;
    _it3ij = malloc(nVar*sizeof(long double));
    _nt3ij = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3ij_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3ij_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3ij[i] = [aik doubleValue];
        _nt3ij[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    // jk
    nVar = 5;
    _it3jk = malloc(nVar*sizeof(long double));
    _nt3jk = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3jk_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3jk_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3jk[i] = [aik doubleValue];
        _nt3jk[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    // mn
    nVar = 4;
    _it3mn = malloc(nVar*sizeof(long double));
    _nt3mn = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3mn_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3mn_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3mn[i] = [aik doubleValue];
        _nt3mn[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;
    
    // op
    nVar = 5;
    _it3op = malloc(nVar*sizeof(long double));
    _nt3op = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3op_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3op_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3op[i] = [aik doubleValue];
        _nt3op[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    // qu
    nVar = 4;
    _it3qu = malloc(nVar*sizeof(long double));
    _nt3qu = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3qu_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3qu_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3qu[i] = [aik doubleValue];
        _nt3qu[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    // rx
    nVar = 4;
    _it3rx = malloc(nVar*sizeof(long double));
    _nt3rx = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3rx_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3rx_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3rx[i] = [aik doubleValue];
        _nt3rx[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    // wx
    nVar = 5;
    _it3wx = malloc(nVar*sizeof(long double));
    _nt3wx = malloc(nVar*sizeof(long double));
    for (int i=0; i<nVar; i++)
    {
        NSDictionary *idict = [array objectAtIndex:i+nOff];
        NSDictionary *ndict = [array objectAtIndex:i+nVar+nOff];
        
        NSString *iname = [NSString stringWithFormat:@"t3wx_i%d", i+1];
        NSString *nname = [NSString stringWithFormat:@"t3wx_n%d", i+1];
        
        NSNumber *aik = [idict objectForKey:iname];
        NSNumber *ank = [ndict objectForKey:nname];
        
        _it3wx[i] = [aik doubleValue];
        _nt3wx[i] = [ank doubleValue];
        
    }
    nOff += 2*nVar;

    _tstar = [[[array objectAtIndex:nOff] objectForKey:@"Tstar"] doubleValue];
    _rhostar = [[[array objectAtIndex:nOff+1] objectForKey:@"rhostar"] doubleValue];
    
    return self;
}

- (void)dealloc
{
    free(_ii);
    free(_ji);
    free(_ni);
    
    free(_it3ab);
    free(_nt3ab);
    free(_it3cd);
    free(_nt3cd);
    free(_ct3ef);
    free(_it3gh);
    free(_nt3gh);
    free(_it3ij);
    free(_nt3ij);
    free(_it3jk);
    free(_nt3jk);
    free(_it3mn);
    free(_nt3mn);
    free(_it3op);
    free(_nt3op);
    free(_it3qu);
    free(_nt3qu);
    free(_it3rx);
    free(_nt3rx);
    free(_it3uv);
    free(_nt3uv);
    free(_it3wx);
    free(_nt3wx);
    
    free(_para);
    free(_parb);
    free(_parc);
    free(_pard);
    free(_pare);
    free(_parf);
    free(_parg);
    free(_parh);
    free(_pari);
    free(_parj);
    free(_park);
    free(_parl);
    free(_parm);
    free(_parn);
    free(_paro);
    free(_parp);
    free(_parq);
    free(_parr);
    free(_pars);
    free(_part);
    free(_paru);
    free(_parv);
    free(_parw);
    free(_parx);
    free(_pary);
    free(_parz);
    
    free(_iv3a);
    free(_jv3a);
    free(_nv3a);
    
    free(_iv3b);
    free(_jv3b);
    free(_nv3b);
    
    free(_iv3c);
    free(_jv3c);
    free(_nv3c);

    free(_iv3d);
    free(_jv3d);
    free(_nv3d);

    free(_iv3e);
    free(_jv3e);
    free(_nv3e);

    free(_iv3f);
    free(_jv3f);
    free(_nv3f);

    free(_iv3g);
    free(_jv3g);
    free(_nv3g);

    free(_iv3h);
    free(_jv3h);
    free(_nv3h);

    free(_iv3i);
    free(_jv3i);
    free(_nv3i);

    free(_iv3j);
    free(_jv3j);
    free(_nv3j);

    free(_iv3k);
    free(_jv3k);
    free(_nv3k);

    free(_iv3l);
    free(_jv3l);
    free(_nv3l);

    free(_iv3m);
    free(_jv3m);
    free(_nv3m);

    free(_iv3n);
    free(_jv3n);
    free(_nv3n);

    free(_iv3o);
    free(_jv3o);
    free(_nv3o);

    free(_iv3p);
    free(_jv3p);
    free(_nv3p);

    free(_iv3q);
    free(_jv3q);
    free(_nv3q);

    free(_iv3r);
    free(_jv3r);
    free(_nv3r);

    free(_iv3s);
    free(_jv3s);
    free(_nv3s);

    free(_iv3t);
    free(_jv3t);
    free(_nv3t);

    free(_iv3u);
    free(_jv3u);
    free(_nv3u);

    free(_iv3v);
    free(_jv3v);
    free(_nv3v);

    free(_iv3w);
    free(_jv3w);
    free(_nv3w);

    free(_iv3x);
    free(_jv3x);
    free(_nv3x);

    free(_iv3y);
    free(_jv3y);
    free(_nv3y);

    free(_iv3z);
    free(_jv3z);
    free(_nv3z);

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
    //return 3*nCoeffs+3;
    return [[self coefficientNames] count];
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    //return @[ @"p23", @"iapws97_4" ];
    return @[ @"iapws97_4" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    /*
    if ([key isEqualToString:@"p23"])
    {
        _p23 = function;
    }
*/
    if ([key isEqualToString:@"iapws97_4"])
    {
        _iapws4 = function;
    }

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
    return 1.0;
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
    
    for (int i=0; i<5; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"t3ab_i%d", i+1];
        [names addObject:name];
    }

    for (int i=0; i<5; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"t3ab_n%d", i+1];
        [names addObject:name];
    }

    for (int i=0; i<5; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"t3cd_i%d", i+1];
        [names addObject:name];
    }
    
    for (int i=0; i<5; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"t3cd_n%d", i+1];
        [names addObject:name];
    }

    for (int i=0; i<3; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"t3ef_c%d", i+1];
        [names addObject:name];
    }

    [names addObject:@"Tv3Star"];
    [names addObject:@"Pv3Star"];
    
    return names;

}

-(subregion3)identifyRegionForP:(double)p andT:(double)T
{
    subregion3 reg = none3;
    
    if (p >= 100.0e+6)
    {
        return reg;
    }
    
    double pi = p/_pbackstar;
    //double tau = T/_tbackstar;
    
    if (p > 40.0e+6)
    {
        double t3ab = _tbackstar*[self T2splitForPi:pi coefficientsN:_nt3ab andI:_it3ab andN:5];
        reg = (T < t3ab) ? a : b;
    }
    else
    {
        if (p > 25.0e+6)
        {
            double t3ab = _tbackstar*[self T2splitForPi:pi coefficientsN:_nt3ab andI:_it3ab andN:5];
            double t3cd = _tbackstar*[self T1splitForPi:pi coefficientsN:_nt3cd andI:_it3cd andN:4];
            double t3ef = _tbackstar*[self T3splitForPi:pi coefficients:_ct3ef];

            if (T <= t3cd)
            {
                reg = c;
            }
            else
            {
                if (T <= t3ab)
                {
                    reg = d;
                }
                else
                {
                    reg = (T <= t3ef) ? e : f;
                }
            }
        }
        else
        {
            if (p > 23.5e+6)
            {
                
            }
            else
            {
                if (p > 23.0e+6)
                {
                    
                }
                else
                {
                    if (p > 22.5e+6)
                    {
                        
                    }
                    else
                    {
                        double T0 = 643.15;
                        double psat = [_iapws4 PsForT:T0];
                    }
                }
            }
        }
    }
    return reg;
}

-(double)T1splitForPi:(double)pi coefficientsN:(long double *)n andI:(long double *)ic andN:(int)N
{
    double sum = 0.0;
    
    for (int i=0; i<N; i++)
    {
        sum += n[i]*powl(pi, ic[i]);
    }
    return sum;
}

-(double)T2splitForPi:(double)pi coefficientsN:(long double *)n andI:(long double *)ic andN:(int)N
{
    double sum = 0.0;
    for (int i=0; i<N; i++)
    {
        sum += n[i]*powl(logl(pi), ic[i]);
    }
    return sum;
}

-(double)T3splitForPi:(double)pi coefficients:(long double *)c
{
    return c[0]*(pi - c[1]) + c[2];
}

-(double)vptForP:(long double)p andT:(long double)T
{
    double v = 0.0;
    return v;
}

@end
