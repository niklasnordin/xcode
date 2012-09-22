//
//  fundamentalJacobsenCv.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-22.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "fundamentalJacobsenCv.h"

static NSString *name = @"fundamentalJacobsenCv";

@implementation fundamentalJacobsenCv

#define Rgas 8314.462175


+(NSString *)name
{
    return name;
}

-(fundamentalJacobsenCv *)initWithZero
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
    _functionPointers = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(fundamentalJacobsenCv *)initWithArray:(NSArray *)array
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
    
    _functionPointers = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSString *) name
{
    return [fundamentalJacobsenCv name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return [self rho:p T:T]*_mw;
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
    return 96;
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
- (double)d2aResdd2:(long double)d t:(long double)t
{
    
    long double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        long double gamma = 0.0;
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }

        long double K = _nk[i]*powl(t, _jk[i]);
        long double pl = powl(d, _lk[i]);
        long double a1 = powl(d, _ik[i]-2.0)*expl(-gamma*pl);
        long double a2 = -_ik[i]*(2.0*gamma*_lk[i]*pl + 1.0);
        long double a3 = gamma*_lk[i]*pl*(_lk[i]*(gamma*pl - 1.0) + 1.0) + _ik[i]*_ik[i];
        
        sum += K*a1*( a2 + a3 );
    }
    
    return sum;
}
-(doubled)2a0dt2:(double)delta t:(double)t
{
    
}

-(double)cv:(double)pressure T:(double)Temperature
{
    double t = _tc/Temperature;
    //double cv1 = [self d2a
    //return -$R*$t*$t*(d2a0dt2($d, $t) + d2aResdt2($d, $t));

}

-(double)rho:(double)pressure T:(double)Temperature
{
    
    double t = _tc/Temperature;
    double r = _rhoc;
    double q = _rhoc*Rgas*Temperature;
    double pq = pressure/q;
    BOOL liquidState = YES;
    
    if (Temperature < _tc)
    {
        id<functionValue> pv = [_functionPointers objectForKey:@"Pv"];
        double pvap = [pv valueForT:Temperature andP:pressure];
        
        if (pressure > pvap)
        {
            id<functionValue> rholSat = [_functionPointers objectForKey:@"rholSat"];
            r = [rholSat valueForT:Temperature andP:pressure];
            //NSLog(@"State is in liquid");
        }
        else
        {
            id<functionValue> rhovSat = [_functionPointers objectForKey:@"rhovSat"];
            r = [rhovSat valueForT:Temperature andP:pressure];
            r *= 0.1;
            liquidState = NO;
        }
    }
    
    int i = 0;
    int N = 100;
    double err = 1.0;
    double delta = r/_rhoc;
    double tol = 1.0e-7;
    while ((err > tol) && (i < N))
    {
        // pq = delta*(1 + delta*A)
        // A delta^2 + delta - pq = 0
        double A = [self daResdd:delta t:t];
        double B = [self d2aResdd2:delta t:t];
        
        double nom = pq - delta*(1.0 + delta*A);
        double denom = 1.0 + delta*(delta*B + 2.0*A);
        
        double d = nom/denom;
        //NSLog(@"%d: d=%g, %g",i,d,delta);
        if (fabs(denom) < 1.0e-10)
        {
            //NSLog(@"denom = %g",denom);
        }
        err = fabs(d);
        
        // dont take too large steps
        if (d > 0)
        {
            d = fmin(delta,d);
        }
        else
        {
            d = -fmin(-d, delta);
        }
        delta += 0.9*d;
        delta = fmax(1.0e-30, delta);
        
        i++;
    }
    
    if (i > N-2)
    {
        //NSLog(@"Warning! Density calculation did not converge. Error is %g",err);
    }
    
    return delta*_rhoc;
    
}

- (NSString *)equationText
{
    return @"";
}

- (void)dealloc
{
    free(_ik);
    free(_jk);
    free(_lk);
    free(_nk);
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"Pv", @"rholSat", @"rhovSat" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    [_functionPointers setObject:function forKey:key];
}

@end
