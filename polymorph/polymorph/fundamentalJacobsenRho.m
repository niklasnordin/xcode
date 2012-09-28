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
    self = [super initWithZero];
    return self;
}

-(fundamentalJacobsenRho *)initWithArray:(NSArray *)array
{
    self = [super initWithArray:array];
    return self;
}

-(NSString *) name
{
    return [fundamentalJacobsenRho name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double Temp = T;
    Tem = fmax(Temp,150);
    return [self rho:p T:Temp]*[self mw];
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

-(double)rho:(double)pressure T:(double)Temperature
{
    
    double t = [self tc]/Temperature;
    double r = [self rhoc];
    double q = [ self rhoc]*Rgas*Temperature;
    double pq = pressure/q;
    BOOL liquidState = YES;
    
    if (Temperature < [self tc])
    {
        double pvap = [_pv valueForT:Temperature andP:pressure];

        if (pressure > pvap)
        {
            r = [_rholSat valueForT:Temperature andP:pressure];
            //NSLog(@"State is in liquid");
        }
        else
        {
            r = [_rhovSat valueForT:Temperature andP:pressure];
            r *= 0.1;
            liquidState = NO;
        }
    }
    
    int i = 0;
    int N = 100;
    double err = 1.0;
    double delta = r/[self rhoc];
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
            d = fmin(0.7*delta,d);
        }
        else
        {
            d = -fmin(-d, 0.7*delta);
        }
        delta += 0.9*d;
        delta = fmax(1.0e-30, delta);

        i++;
    }
    
    if (i > N-2)
    {
        //NSLog(@"Warning! Density calculation did not converge. Error is %g",err);
    }
    
    return delta*[self rhoc];

}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"Pv", @"rholSat", @"rhovSat" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    //[_functionPointers setObject:function forKey:key];
    
    if ([key isEqualToString:@"Pv"])
    {
        _pv = function;
    }
    
    if ([key isEqualToString:@"rholSat"])
    {
        _rholSat = function;
    }
    
    if ([key isEqualToString:@"rhovSat"])
    {
        _rhovSat = function;
    }
}

@end
