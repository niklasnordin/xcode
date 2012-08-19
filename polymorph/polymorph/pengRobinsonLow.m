//
//  pengRobinsonLow.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "pengRobinsonLow.h"
//#import "Polynomial.h"
#import "Complex.h"

#define Rgas 8314.462175

@implementation pengRobinsonLow 

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [pengRobinsonLow name];
}

-(double)value:(NSArray *)coeff T:(double)T p:(double)p
{
    double returnValue = 0.0;
    double a[self.nCoefficients];
    a[0] = 0.0;
    a[1] = 0.0;
    a[2] = 0.0;
    a[3] = 0.0;
    a[4] = 0.0;
    
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
    
    //NSArray *rts = [Polynomial solveThirdOrder:zA coeffB:zB coeffC:zC];
    
    NSArray *rts = [[NSArray alloc] init];
    if ([rts count] == 1)
    {
        Complex *rt0 = [rts objectAtIndex:0];
        returnValue = rt0.re;
    }
    else
    {
        Complex *rt0 = [rts objectAtIndex:0];
        Complex *rt1 = [rts objectAtIndex:1];
        Complex *rt2 = [rts objectAtIndex:2];
        // find the correct root
        //NSLog(@"rts = %@", rts);
        //return @"three roots";
        //W=1; // for molar volume
        double Zmin = fmin(rt0.re, fmin(rt1.re, rt2.re));
        double Zmax = fmax(rt0.re, fmax(rt1.re, rt2.re));
        double rho1 = p*W/Rgas/T/Zmin;
        double rho2 = p*W/Rgas/T/Zmax;
        
        returnValue = rho1;
        if (rho2 < rho1)
        {
            returnValue = rho2;
        }
    }
    
        //double rho = self.pressure*W/Rgas/self.temperature/Z;
    
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
