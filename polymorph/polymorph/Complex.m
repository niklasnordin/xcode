//
//  Complex.m
//  PropertyCalculator
//
//  Created by Niklas Nordin on 2011-12-08.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import "Complex.h"

@implementation Complex
@synthesize re = _re;
@synthesize im = _im;

- (Complex *)initWithRe:(double)r Im:(double)i
{
    Complex *tmp = [[Complex alloc] init];
    tmp.re = r;
    tmp.im = i;
    return tmp;
}

- (Complex *)initWithRe:(double)reNum
{
    Complex *tmp = [[Complex alloc] init];
    tmp.re = reNum;
    tmp.im = 0.0;
    return tmp;
}

- (Complex *)initWithComplex:(Complex *)c
{
    Complex *tmp = [[Complex alloc] init];
    tmp.re = c.re;
    tmp.im = c.im;
    return tmp;
}

- (Complex *)add:(Complex *)a
{
    Complex *tmp = [[Complex alloc] initWithComplex:self];
    tmp.re += a.re;
    tmp.im += a.im;
    return tmp;
}

- (Complex *)subtract:(Complex *)a
{
    Complex *tmp = [[Complex alloc] initWithComplex:self];
    tmp.re -= a.re;
    tmp.im -= a.im;
    return tmp;
}

- (Complex *)multiply:(Complex *)c
{
    Complex *tmp = [[Complex alloc] init];
    tmp.re = (self.re*c.re) - (self.im*c.im);
    tmp.im = (self.re*c.im) + (self.im*c.re);
    return tmp;
}

- (Complex *)multiplyWithRe:(double)a
{
    Complex *tmp = [[Complex alloc] initWithComplex:self];
    tmp.re *= a;
    tmp.im *= a;
    return tmp;
}

- (Complex *)divide:(Complex *)c
{
    Complex *tmp = [[Complex alloc] init];
    double div = (c.re*c.re) + (c.im*c.im);
    tmp.re = ((self.re*c.re)+(self.im*c.im))/div;
    tmp.im = ((self.im*c.re)-(self.re*c.im))/div;
    return tmp;
}

- (Complex *)sqrt
{
    Complex *tmp = [[Complex alloc] init];
    double phi = M_PI_2;
    if (self.re) 
    {
        phi = atan(self.im/self.re);
        if (self.re < 0) phi += M_PI;
    }
    else
    {
        if (self.im < 0) phi = -M_PI_2;
    }
    
    double rad = sqrt(self.re*self.re + self.im*self.im);
    tmp.re = sqrt(rad)*cos(0.5*phi);
    tmp.im = sqrt(rad)*sin(0.5*phi);
    return tmp;
}

- (Complex *)pow:(double)exponent
{
    Complex *tmp = [[Complex alloc] init];

    double phi = M_PI_2;
    if (self.re) 
    {
        phi = atan(self.im/self.re);
        if (self.re < 0) phi += M_PI;
    }
    else
    {
        if (self.im < 0) phi = -M_PI_2;
    }

    double rad = sqrt(self.re*self.re + self.im*self.im);
    tmp.re = pow(rad, exponent)*cos(exponent*phi);
    tmp.im = pow(rad, exponent)*sin(exponent*phi);
    return tmp;
}

@end







