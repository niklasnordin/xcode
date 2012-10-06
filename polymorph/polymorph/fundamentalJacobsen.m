//
//  fundamentalJacobsen.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "fundamentalJacobsen.h"
#import "functionValue.h"

@implementation fundamentalJacobsen

#define Rgas 8314.462175
#define Tref 273.15
#define Pref 0.001e+6

-(fundamentalJacobsen *)initWithZero
{
    self = [super init];
    
    int n = 23;
    
    _ik = malloc(n*sizeof(long double));
    _jk = malloc(n*sizeof(long double));
    _lk = malloc(n*sizeof(long double));
    _nk = malloc(n*sizeof(long double));
    
    for (int i=0; i<n; i++)
    {
        _ik[i] = 0.0;
        _jk[i] = 0.0;
        _lk[i] = 0.0;
        _nk[i] = 0.0;
    }
    
    return self;
}

-(fundamentalJacobsen *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = 23;
    
    _ik = malloc(n*sizeof(long double));
    _jk = malloc(n*sizeof(long double));
    _lk = malloc(n*sizeof(long double));
    _nk = malloc(n*sizeof(long double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Aidict = [array objectAtIndex:i];
        NSDictionary *Ajdict = [array objectAtIndex:i+n];
        NSDictionary *Aldict = [array objectAtIndex:i+2*n];
        NSDictionary *Andict = [array objectAtIndex:i+3*n];
        
        NSString *iname = [NSString stringWithFormat:@"A%d", i];
        NSString *jname = [NSString stringWithFormat:@"A%d", i+n];
        NSString *lname = [NSString stringWithFormat:@"A%d", i+2*n];
        NSString *nname = [NSString stringWithFormat:@"A%d", i+3*n];
        
        NSNumber *aik = [Aidict objectForKey:iname];
        NSNumber *ajk = [Ajdict objectForKey:jname];
        NSNumber *alk = [Aldict objectForKey:lname];
        NSNumber *ank = [Andict objectForKey:nname];
        
        _ik[i] = [aik doubleValue];
        _jk[i] = [ajk doubleValue];
        _lk[i] = [alk doubleValue];
        _nk[i] = [ank doubleValue];
        
    }
    
    _tc   = [[[array objectAtIndex:92] objectForKey:@"A92"] doubleValue];
    _pc   = [[[array objectAtIndex:93] objectForKey:@"A93"] doubleValue];
    _rhoc = [[[array objectAtIndex:94] objectForKey:@"A94"] doubleValue];
    _mw   = [[[array objectAtIndex:95] objectForKey:@"A95"] doubleValue];
    
    return self;
}

-(double)a0:(double)delta t:(double)tau
{
    /*
    double rho0 = Pref/(Rgas*Tref);
    double d0 = rho0/_rhoc;
    double t0 = _tc/Tref;
    double T = _tc/tau;

    $a1 = $h0*$t/$Tc;
    $a2 = 0.0;
    $a3 = 0.0;
    $sum = 0.0;
    
    if ($useFit == 0)
    {
        $dummy = integrateCp($t, $t0, $a2, $a3);
        $sum = $a2 - $t*$a3;
    }
    else
    {
        if (($T < 200.0) || ($T > 1500.0))
        {
            $dummy = integrateCp($t, $t0, $a2, $a3);
            $sum = $a2 - $t*$a3;
        }
        else
        {
            $sum = numFit($t);
        }
    }
    return ($a1 - $s0 + $sum)/$R - 1.0 + log($d*$t0/($d0*$t));
     */
    return 0.0;
} 


-(double)d2a0dt2:(double)pressure T:(double)temperature cp0:(id<functionValue>)cp0
{
    double tau = _tc/temperature;
    /*
     double tp = 1.000001*temperature;
     double tm = 0.999999*temperature;
     double cp = [_cp0 valueForT:tp andP:pressure];
     double cm = [_cp0 valueForT:tm andP:pressure];
     double taup = _tc/tp;
     double taum = _tc/tm;
     double dcpdt = (cp - cm)/(taup - taum);
     //NSLog(@"dcpdt=%g",dcpdt);
     */
    return (1.0 - [cp0 valueForT:temperature andP:pressure]/Rgas)/tau/tau;
    //+ 2.0*dcpdt/Rgas/tau;
}

// d = rho/rhoc (kmol/m^3)
// t = Tc/T
-(double)daResdd:(long double)d t:(long double)t
{
    long double sum = 0.0;
    
    for (int i=0; i<23; i++)
    {
        long double gamma = 0.0;
        
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }
        
        long double pl = powl(d, _lk[i]);
        
        long double K = _nk[i]*powl(t, _jk[i]);
        long double da = powl(d, _ik[i]-1.0)*expl(-gamma*pl);
        long double db = _ik[i] - gamma*_lk[i]*pl;
        
        sum += K*da*db;
    }
    
    return sum;
}

// d = rho/rhoc (kmol/m^3)
// t = Tc/T
- (double)d2aResdd2:(long double)d t:(long double)tau
{
    
    long double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        long double gamma = 0.0;
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }
        
        long double K = _nk[i]*powl(tau, _jk[i]);
        long double pl = powl(d, _lk[i]);
        long double a1 = powl(d, _ik[i]-2.0)*expl(-gamma*pl);
        long double a2 = -_ik[i]*(2.0*gamma*_lk[i]*pl + 1.0);
        long double a3 = gamma*_lk[i]*pl*(_lk[i]*(gamma*pl - 1.0) + 1.0) + _ik[i]*_ik[i];
        
        sum += K*a1*( a2 + a3 );
    }
    
    return sum;
}

-(double)d2aResdt2:(long double)delta t:(long double)tau
{
    long double sum = 0.0;
    
    for (int i=0; i<23; i++)
    {
        long double gamma = 0.0;
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }
        
        long double term1 = _nk[i]*powl(delta, _ik[i])*expl(-gamma*powl(delta, _lk[i]));
        sum += _jk[i]*(_jk[i] - 1.0)*powl(tau, _jk[i] - 2.0)*term1;
    }
    
    return sum;
}

-(double)d2aResdddt:(long double)delta t:(long double)tau
{
    
    long double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        long double gamma = 0.0;
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }
        
        long double b = powl(delta, _ik[i]);
        long double db = _ik[i]*powl(delta, _ik[i]-1.0);
        long double dat = _nk[i]*_jk[i]*powl(tau, _jk[i]-1.0)*expl(-gamma*powl(delta, _lk[i]));
        long double dadt = -dat*gamma*_lk[i]*powl(delta, _lk[i]-1.0);
        sum += dat*db + b*dadt;
        
        /*
         long double K = _nk[i]*_jk[i]*powl(tau, _jk[i]-1.0)*powl(delta, _lk[i]);
         long double pl = powl(delta, _lk[i]);
         long double dd = (1.0 - gamma*_lk[i]*pl)*expl(-gamma*pl);
         sum += K*pl*dd;
         */
    }
    
    return sum;
    
}

- (void)dealloc
{
    free(_ik);
    free(_jk);
    free(_lk);
    free(_nk);
}

-(NSArray *)coefficientNames
{
    return nil;
}

@end
