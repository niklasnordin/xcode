//
//  pengRobinsonLow.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "pengRobinson.h"
#import "Polynomial.h"
#import "Complex.h"

#define Rgas 8314.462175

static NSString *name = @"pengRobinson";

@implementation pengRobinson

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [pengRobinson name];
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
    double kappa = 0.37464+1.54226*omega-0.26992*omega*omega;
    double alpha = pow(1.0 + kappa*(1.0-sqrt(Tr)), 2.0);
    
    double capA = aPR*alpha*p/(Rgas*Rgas*T*T);
    double capB = bPR*p/(Rgas*T);
    
    double zA = -(1.0 - capB);
    double zB = capA - 3.0*capB*capB - 2.0*capB;
    double zC = -capB*(capA - capB - capB*capB);
    
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
        double zLiq = fmin(z0, fmin(z1, z2));
        double zVap = fmax(z0, fmax(z1, z2));
        
        double logFugOverPliq = [self logFugacityOverP:zLiq A:capA B:capB];
        double logFugOverPvap = [self logFugacityOverP:zVap A:capA B:capB];
        double pliq = p*exp(logFugOverPliq);
        double pvap = p*exp(logFugOverPvap);
        
        // if fugacity of ph > pl, then equilibrium drives towards phase low
        double z = zVap;
        
        if (pvap > pliq)
        {
            if (zLiq > 0) z = zLiq;
        }
                
        double rho = p*W/Rgas/T/z;
        returnValue = rho;

    }
        
    return returnValue;
}

-(double)logFugacityOverP:(double)Z A:(double)A B:(double)B
{
    double c1 = 1.0/(2.0*sqrt(2.0));
    double help1 = (Z + (1.0 + sqrt(2.0))*B)/(Z + (1.0 - sqrt(2.0))*B);
    
    return Z - 1.0 - log(Z-B) - (c1*A/B)*log(help1);
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
