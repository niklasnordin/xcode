//
//  fundamentalJacobsen.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "FJ_Rho.h"

#define Rgas 8314.462175

static NSString *name = @"FJ_Rho";

@implementation FJ_Rho

+(NSString *)name
{
    return name;
}

-(FJ_Rho *)initWithZero
{
    self = [super initWithZero];
    return self;
}

-(FJ_Rho *)initWithArray:(NSArray *)array
{
    self = [super initWithArray:array];
    return self;
}

-(NSString *) name
{
    return [FJ_Rho name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double Temp = T;
    //Temp = fmax(Temp,150);
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
    double mw = [self mw];
    double t = [self tc]/Temperature;
    double r = [self rhoc];
    double q = r*Rgas*Temperature;
    double pq = pressure/q;
    BOOL liquidState = YES;
    
    if (Temperature < [self tc])
    {
        double pvap = [_pv valueForT:Temperature andP:pressure];

        if (pressure > pvap)
        {
            r = [_rholSat valueForT:Temperature andP:pressure]/mw;
            //NSLog(@"State is in liquid");
            //r *= 2.0;
        }
        else
        {
            r = [_rhovSat valueForT:Temperature andP:pressure]/mw;
            //r *= 0.2;
            liquidState = NO;
        }
    }

    int i = 0;
    int N = 200;
    double err = 1.0;
    double delta = r/[self rhoc];
    double tol = 1.0e-9;
    double urlx = 0.9;
    while ((err > tol) && (i < N))
    {
        // pq = delta*(1 + delta*A)
        // A delta^2 + delta - pq = 0
        double A = [self daResdd:delta t:t];
        double B = [self d2aResdd2:delta t:t];

        double nom = pq - delta*(1.0 + delta*A);
        double denom = 1.0 + delta*(delta*B + 1.0*A);
        
        double d = nom/denom;
        err = fabs(d);
        
        // dont take too large steps
        if (d > 0)
        {
            d = fmin(urlx*delta,d);
        }
        else
        {
            d = -fmin(-d, urlx*delta);
        }
        delta += urlx*d;
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

-(BOOL)requirementsFulfilled
{
    return YES;
}

@end
