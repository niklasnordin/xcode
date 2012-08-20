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

    if (D <= 0)
    {
        Complex *x2 = [[Am3c add:[ST multiplyWithRe:-0.5]] add:[SmT multiply:tt]];
        Complex *x3 = [[Am3c add:[ST multiplyWithRe:-0.5]] subtract:[SmT multiply:tt]];
        [sol addObject:x2];
        [sol addObject:x3];
    }
    
    
    return sol;
}

@end
