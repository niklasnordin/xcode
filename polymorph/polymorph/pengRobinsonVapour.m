//
//  pengRobinsonVapour.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-13.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "pengRobinsonVapour.h"
#import "Polynomial.h"
#import "Complex.h"

#define Rgas 8314.462175
static NSString *name = @"pengRobinsonVapour";

@implementation pengRobinsonVapour

+(NSString *)name
{
    return name;
}

-(pengRobinsonVapour *)initWithZero
{
    self = [super init];
    return self;
}

-(pengRobinsonVapour *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    NSDictionary *A0dict = [array objectAtIndex:0];
    _tc = [[A0dict objectForKey:@"Tc"] doubleValue];
    
    NSDictionary *A1dict = [array objectAtIndex:1];
    _pc = [[A1dict objectForKey:@"Pc"] doubleValue];
    
    NSDictionary *A2dict = [array objectAtIndex:2];
    _omega = [[A2dict objectForKey:@"omega"] doubleValue];
    
    NSDictionary *A3dict = [array objectAtIndex:3];
    _mw = [[A3dict objectForKey:@"Mw"] doubleValue];
    
    return self;
}

-(NSString *) name
{
    return [pengRobinsonVapour name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double returnValue = 0.0;
    double Tr = T/_tc;
    
    double aPR = 0.457235*Rgas*Rgas*_tc*_tc/_pc;
    double bPR = 0.0777961*Rgas*_tc/_pc;
    double kappa = 0.37464+1.54226*_omega-0.26992*_omega*_omega;
    double alpha = pow(1.0 + kappa*(1.0-sqrt(Tr)), 2.0);
    
    double capA = aPR*alpha*p/(Rgas*Rgas*T*T);
    double capB = bPR*p/(Rgas*T);
    
    double zA = -(1.0 - capB);
    double zB = capA - 3.0*capB*capB - 2.0*capB;
    double zC = -capB*(capA - capB - capB*capB);
    
    NSArray *rts = [Polynomial solveThirdOrderReal:zA coeffB:zB coeffC:zC];
    
    if ([rts count] == 1)
    {
        Complex *rt0 = [rts objectAtIndex:0];
        double z = rt0.re;
        double rho = p*_mw/Rgas/T/z;
        
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
        //double zLiq = fmin(z0, fmin(z1, z2));
        double zVap = fmax(z0, fmax(z1, z2));
                
        double rho = p*_mw/Rgas/T/zVap;
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

-(bool)temperatureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return 4;
}


- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return nil;
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    
}

-(NSArray *)coefficientNames
{
    return @[ @"Tc", @"Pc", @"omega", @"Mw" ];
}


@end
