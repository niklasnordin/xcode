//
//  fundamentalJacobsen.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

/*
 
 // Vapor pressure coefficients
 $a_[1] = -0.0514770863682;
 $a_[2] = -8.27075196981;
 $a_[3] = -5.4924538857;
 $a_[4] = 5.64828891406;
 
 // Saturated Liquid Density
 $b_[1] = 2.22194636037;
 $b_[2] = -0.0469267553094;
 $b_[3] = 10.3035666311;
 $b_[4] = -17.2304684516;
 $b_[5] = 8.23564165285;
 
 // Saturated Vapor Density
 $c_[1] = -8.35647816638;
 $c_[2] = -2.38721859682;
 $c_[3] = -39.6946441837;
 $c_[4] = -9.99133502692;
 
 // Ideal Gas Heat Capacity
 $d_[1] = 6.41129104405;
 $d_[2] = 1.95988750679;
 $d_[3] = 7.60084166080;
 $d_[4] = 3.89583440622;
 $d_[5] = 4.23238091363;
*/

#import "fundamentalJacobsenRho.h"

#define Rgas 8314.462175

static NSString *name = @"fundamentalJacobsenRho";

@implementation fundamentalJacobsenRho

+(NSString *)name
{
    return name;
}

-(fundamentalJacobsenRho *)initWithZero
{
    self = [super init];
    
    int n = 23;
    
    _ik = malloc(n*sizeof(double));
    _jk = malloc(n*sizeof(double));
    _lk = malloc(n*sizeof(double));
    _nk = malloc(n*sizeof(double));
    
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

-(fundamentalJacobsenRho *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = 23;

    _ik = malloc(n*sizeof(double));
    _jk = malloc(n*sizeof(double));
    _lk = malloc(n*sizeof(double));
    _nk = malloc(n*sizeof(double));
    
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
    return [fundamentalJacobsenRho name];
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
-(double)daResdd:(double)d t:(double)t
{
    double sum = 0.0;
    
    for (int i=0; i<23; i++)
    {
        double gamma = 0.0;
        
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }
        
        double a = _nk[i]*pow(t, _jk[i])*exp(-gamma*pow(d, _lk[i]));
        double da = -a*gamma*_lk[i]*pow(d, _lk[i] - 1.0);
        double b = pow(d, _ik[i]);
        double db = _ik[i]*pow(d, _ik[i] - 1.0);
        sum += a*db + b*da;
    }

    return sum;
}

// d = rho/rhoc (kmol/m^3)
// t = Tc/T
- (double)d2aResdd2:(double)d t:(double)t
{

    double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        double gamma = 0.0;
        if (fabs(_lk[i]) > 1.0e-3)
        {
            gamma = 1.0;
        }
        
        double a = _nk[i]*pow(t, _jk[i])*exp(-gamma*pow(d, _lk[i]));
        double da = -a*gamma*_lk[i]*pow(d, _lk[i]-1.0);
        double dda = -da*gamma*_lk[i]*pow(d, _lk[i]-1.0) - a*gamma*_lk[i]*(_lk[i]-1.0)*pow(d, _lk[i]-2.0);

        double b = pow(d, _ik[i]);
        double db = _ik[i]*pow(d, _ik[i]-1.0);
        double ddb = _ik[i]*(_ik[i]-1.0)*pow(d, _ik[i]-2.0);
        
        sum += a*ddb + da*db + db*da + b*dda;
        
    }

    return sum;
}


-(double)rho:(double)pressure T:(double)Temperature
{
    
    double t = _tc/Temperature;
    double r = 0.01*_rhoc;
    double q = _rhoc*Rgas*Temperature;
    double pq = pressure/q;
    
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
            r *= 0.5;

            //NSLog(@"T=%g, r=%g",Temperature,r);
            //NSLog(@"State is in vapor");
        }
    }

    int i = 0;
    int N = 200;
    double err = 1.0;
    double tol = 1.0e-7;
    double delta = r/_rhoc;
    while ((err > tol) && (i < N))
    {
        double A = [self daResdd:delta t:t];
        double nom = pq - delta*(A*delta + 1.0);

        double B = [self d2aResdd2:delta t:t];
        double denom = delta*(B*delta + 2.0*A) + 1.0;
        double d = nom/denom;
/*
        if (fabs(denom) < 1.0e-50)
        {
            //NSLog(@"divergence");
            denom = 2.0*B*delta + A;
            d = sqrt(nom/denom);
        }
        
        double d;
        double denom = 2.0*A*delta + 1.0;
        if (fabs(denom) > 1.0e-20)
        {
            d = nom/denom;
        }
        else
        {
            d = nom/A;
        }
        */
        err = fabs(d);
        delta += 0.7*d;
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
