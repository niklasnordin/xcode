//
//  pengRobinsonHigh.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "pengRobinsonHigh.h"
#import "Polynomial.h"
#import "Complex.h"

#define Rgas 8314.462175

static NSString *name = @"pengRobinsonHigh";

@implementation pengRobinsonHigh


+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [pengRobinsonHigh name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double returnValue = 0.0;
    double a[self.nCoefficients];
    
    for(int i=0; i<self.nCoefficients; i++)
    {
        a[i] = [[coeff objectAtIndex:i] doubleValue];
    }
    
    double Tc    = a[0];
    double Pc    = a[1];
    double omega = a[2];
    double W     = a[3];
    
    double Tr = T/Tc;
    
    double aPR = 0.457236*Rgas*Rgas*Tc*Tc/Pc;
    double bPR = 0.0777961*Rgas*Tc/Pc;
    double alpha = pow(1.0 + (0.37464+1.54226*omega-0.26992*omega*omega)*(1.0-sqrt(Tr)), 2.0);
    
    double capA = aPR*alpha*p/(Rgas*Rgas*T*T);
    double capB = bPR*p/(Rgas*T);
    
    double zA = -(1.0 - capB);
    double zB = capA - 3.0*capB*capB - 2.0*capB;
    double zC = -(capA*capB - capB*capB - capB*capB*capB);
    
    NSArray *rts = [Polynomial solveThirdOrder:zA coeffB:zB coeffC:zC];
    
    if ([rts count] == 1)
    {
        Complex *rt0 = [rts objectAtIndex:0];
        double z = rt0.re;
        double rho = p*W/Rgas/T/z;
        
        returnValue = rho;
    }
    else
    {
        Complex *rt0 = [rts objectAtIndex:0];
        Complex *rt1 = [rts objectAtIndex:1];
        Complex *rt2 = [rts objectAtIndex:2];
        
        double z0 = rt0.re;
        double z1 = rt1.re;
        double z2 = rt2.re;
        
        double rho0 = p*W/Rgas/T/z0;
        double rho1 = p*W/Rgas/T/z1;
        double rho2 = p*W/Rgas/T/z2;
        
        BOOL allPositive = ((rho0 > 0) && (rho1 > 0) && (rho2 > 0)) ? YES : NO;
        
        if (allPositive)
        {
            returnValue = fmin(rho0, fmin(rho1, rho2));
        }
        else
        {
            if (rho0 > 0)
            {
                if (rho1 > 0)
                {
                    // rho2 must be < 0
                    returnValue = fmax(rho0, rho1);
                }
                else
                {
                    // rho1 < 0
                    if (rho2 > 0)
                    {
                        returnValue = fmax(rho0, rho2);
                    }
                    else
                    {
                        returnValue = rho0;
                    }
                }
            }
            else
            {
                // rho0 < 0, can disregard that one
                if (rho1 > 0)
                {
                    if (rho2 > 0)
                    {
                        returnValue = fmax(rho1, rho2);
                    }
                    else
                    {
                        returnValue = rho1;
                    }
                }
                else
                {
                    returnValue = rho2;
                }
            }
        }
        
    }
    
    return returnValue;
}

-(bool)pressureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return 4;
}

@end
