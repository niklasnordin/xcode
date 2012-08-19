//
//  fundamentalJacobsen.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "fundamentalJacobsen.h"

#define Rgas 8314.462175

static NSString *name = @"fundamentalJacobsen";

@implementation fundamentalJacobsen

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [fundamentalJacobsen name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    /*
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    */
    [self setCoeffs:coeff];
    
    double y = 0.0;
    //double y1 = p/( a[0]*T );
    
    //if (y1) y = y1;
    return y;
}

-(bool)pressureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return 96;
}

-(void)setCoeffs:(NSArray *)coeffs
{
    for (int i=0; i<23; i++)
    {
        [_nk addObject:[coeffs objectAtIndex:i]];
        [_ik addObject:[coeffs objectAtIndex:i+23]];
        [_jk addObject:[coeffs objectAtIndex:i+46]];
        [_lk addObject:[coeffs objectAtIndex:i+69]];
    }
    
    _tc   = [[coeffs objectAtIndex:92] doubleValue];
    _pc   = [[coeffs objectAtIndex:93] doubleValue];
    _rhoc = [[coeffs objectAtIndex:94] doubleValue];
    _mw   = [[coeffs objectAtIndex:95] doubleValue];
    /*
     $rho = rho($pressure, $temp);
    $d = $rho/$rhoc;
    $t = $Tc/$temp;
    
    $cp = cp($d, $t)*1.0e-3/$Mw;
     */
    
}

-(double)daResdd:(double)d t:(double)t
{
    double sum = 0.0;
    for (int i=0; i<23; i++)
    {
        double gamma = 1.0;
        double nk = [[_nk objectAtIndex:i] doubleValue];
        double ik = [[_ik objectAtIndex:i] doubleValue];
        double jk = [[_jk objectAtIndex:i] doubleValue];
        double lk = [[_lk objectAtIndex:i] doubleValue];
        
        if (abs(lk) < 1.0e-8)
        {
            gamma = 0.0;
        }
        
        double a = nk*pow(t, jk)*exp(-gamma*pow(d, lk));
        double da = -a*gamma*lk*pow(d, lk - 1.0);
        double b = pow(d, ik);
        double db = ik*pow(d, ik - 1.0);
        sum += a*db + b*da;
    }
    
    return sum;
}

@end
