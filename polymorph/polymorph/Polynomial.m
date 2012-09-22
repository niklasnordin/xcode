//
//  Polynomial.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "Polynomial.h"
#import "Complex.h"

@implementation Polynomial

// y = x^2 + a x + b
+ (NSArray *)solveSecondOrder:(double)a coeffB:(double)b
{
    NSMutableArray *sol = [[NSMutableArray alloc] init];
    
    double sRoot = a*a - 4*b;
    if (sRoot >= 0.0)
    {
        double r1 = 0.5*(-a-sqrt(sRoot));
        double r2 = 0.5*(-a+sqrt(sRoot));
        [sol addObject:[NSNumber numberWithDouble:r1]];
        [sol addObject:[NSNumber numberWithDouble:r2]];
    }
    
    return sol;
}

+ (NSMutableArray *)solveThirdOrder:(double)a coeffB:(double)b coeffC:(double)c
{
    NSMutableArray *sol = [[NSMutableArray alloc] init];
    
    double third = 1.0/3.0;
    double threeTwo = sqrt(3.0)/2.0;
    Complex *tt = [[Complex alloc] initWithRe:0 Im:threeTwo];
    double Q = (3.0*b - a*a)/9.0;
    double R = (9.0*a*b - 27.0*c - 2.0*a*a*a)/54.0;
    double D = Q*Q*Q + R*R;
    // D < 0 -> 3 real roots
    // D = 0 -> 3 real roots, at least a double root
    // D > 0 -> 1 real root
    
    Complex *Rc = [[Complex alloc] initWithRe:R];
    Complex *Dc = [[Complex alloc] initWithRe:D];
    Complex *sqrtD = [Dc sqrt];
    Complex *Sc = [[Rc add:sqrtD] pow:third];
    Complex *Tc = [[Rc subtract:sqrtD] pow:third];
    Complex *ST = [Sc add:Tc];
    Complex *SmT = [Sc subtract:Tc];
    Complex *A = [[Complex alloc] initWithRe:a];
    
    Complex *Am3c = [A multiplyWithRe:-third];
    
    Complex *x1 = [Am3c add:ST];
    [sol addObject:x1];
    /*
    NSLog(@"coeffs %g, %g, %g",a,b,c);
    NSLog(@"x1 = %g",x1.re);
    */
    if (D <= 0)
    {
        Complex *x2 = [[Am3c add:[ST multiplyWithRe:-0.5]] add:[SmT multiply:tt]];
        Complex *x3 = [[Am3c add:[ST multiplyWithRe:-0.5]] subtract:[SmT multiply:tt]];
        [sol addObject:x2];
        [sol addObject:x3];
        //NSLog(@"x2 = %g, x3 = %g",x2.re, x3.re);
    }
    
    
    return sol;
}

// x^3 + a*x^2 + b*x + c = 0
// A     B       C     D
+ (NSMutableArray *)solveThirdOrderReal:(double)ca coeffB:(double)cb coeffC:(double)cc
{
    NSMutableArray *sol = [[NSMutableArray alloc] init];
  
    // x = t - ca/3.0 transformation
    // t^3 + pt + q = 0;
    double p = cb - ca*ca/3.0;
    double q = (2.0*ca*ca*ca - 9.0*ca*cb + 27.0*cc)/27.0;
    
    // requirement for only real roots
    if (p <= 0.0)
    {
        double r = sqrt(-4.0*p/3.0);
        double arg = -4.0*q/r/r/r;
        double chk = 4*p*p*p + 27.0*q*q;
        if (chk > 0.0)
        {
            //NSLog(@"argument > 1, arg = %g",arg);
            double r = -2.0*fabs(q)/q*sqrt(-p/3.0)*cosh(acosh(-3.0/2.0*fabs(q)/p*sqrt(-3.0/p))/3.0) - ca/3.0;
            Complex *z = [[Complex alloc] initWithRe:r];
            [sol addObject:z];
        }
        else
        {
            double tp3 = M_PI*2.0/3.0;
            double a = acos(arg)/3.0;
            double r1 = r*cos(a) - ca/3.0;
            double r2 = r*cos(a+tp3) - ca/3.0;
            double r3 = r*cos(a-tp3) - ca/3.0;
            Complex *z1 = [[Complex alloc] initWithRe:r1];
            Complex *z2 = [[Complex alloc] initWithRe:r2];
            Complex *z3 = [[Complex alloc] initWithRe:r3];
            [sol addObject:z1];
            [sol addObject:z2];
            [sol addObject:z3];
        }
    }
    else
    {
        //NSLog(@"Error no 3 real roots");
        double r = -2.0*sqrt(p/3.0)*sinh(asinh(3.0*q*sqrt(3.0/p)/2.0/p)/3.0) - ca/3.0;
        Complex *z = [[Complex alloc] initWithRe:r];
        [sol addObject:z];

    }
    return sol;
}

@end
