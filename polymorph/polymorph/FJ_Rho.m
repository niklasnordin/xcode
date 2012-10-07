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
    Temp = fmax(Temp,150);
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

-(NSArray *)coefficientNames
{
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (int i=0; i<96; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
        [names addObject:name];
    }
    return names;
}

@end
