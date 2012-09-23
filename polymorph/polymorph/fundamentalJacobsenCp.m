//
//  fundamentalJacobsenCp.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-23.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "fundamentalJacobsenCp.h"

static NSString *name = @"fundamentalJacobsenCp";

@implementation fundamentalJacobsenCp

#define Rgas 8314.462175

+(NSString *)name
{
    return name;
}

-(fundamentalJacobsenCp *)initWithZero
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
    //_functionPointers = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(fundamentalJacobsenCp *)initWithArray:(NSArray *)array
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
    
    //_functionPointers = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSString *) name
{
    return [fundamentalJacobsenCp name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return [self cp:p T:T]*_mw;
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

-(double)d2aResdt2:(long double)delta t:(long double)t
{
    long double sum = 0.0;
    
    for (int i=0; i<23; i++)
    {
        long double gamma = 0.0;
        if (fabs(_lk[i]) > 1.0e-8)
        {
            gamma = 1.0;
        }
        
        long double term1 = _nk[i]*powl(delta, _ik[i])*expl(-gamma*powl(delta, _lk[i]));
        sum += _jk[i]*(_jk[i] - 1.0)*powl(t, _jk[i] - 2.0)*term1;
    }
    
    return sum;
}

-(double)d2aResdddt:(long double)delta t:(long double)t
{
    
    long double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        long double gamma = 1.0;
        if (fabs(_lk[i]) < 1.0e-8)
        {
            gamma = 0.0;
        }
        
        //long double a = _nk[i]*powl(t, _jk[i])*expl(-gamma*powl(delta, _lk[i]));
        long double b = powl(delta, _ik[i]);
        long double db = _ik[i]*powl(delta, _ik[i]-1.0);
        long double dat = _nk[i]*_jk[i]*powl(t, _jk[i]-1.0)*expl(-gamma*powl(delta, _lk[i]));
        long double dadt = -dat*gamma*_lk[i]*powl(delta, _lk[i]-1.0);
        sum += dat*db + b*dadt;
    }
    
    return sum;

}

-(double)cp:(double)pressure T:(double)Temperature
{
    double cv = [_cv valueForT:Temperature andP:pressure]/_mw;
    
    double t = _tc/Temperature;
    double rho = [_rho valueForT:Temperature andP:pressure]*_mw;
    double delta = rho/_rhoc;
    
    double t1 = [self daResdd:delta t:t];
    double t2 = [self d2aResdddt:delta t:t];
    double t3 = [self d2aResdd2:delta t:t];
    
    double nom = 1.0 + delta*t1 - delta*t*t2;
    double denom = 1.0 + 2.0*delta*t1 + delta*delta*t3;

    double cp = cv + nom/denom;
    return cp*_mw;
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
    return @[ @"cv", @"rho" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    
    if ([key isEqualToString:@"rho"])
    {
        _rho = function;
    }
    
    if ([key isEqualToString:@"cv"])
    {
        _cv = function;
    }
}


@end
