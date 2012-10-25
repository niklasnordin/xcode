//
//  iapws97_4.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_4.h"

static NSString *name = @"iapws97_4";
static int nCoeffs = 10;

@implementation iapws97_4

-(iapws97_4 *)initWithZero
{
    self = [super init];

    _ni = malloc(nCoeffs*sizeof(double));
    
    for (int i=0; i<nCoeffs; i++)
    {
        _ni[i] = 0.0;
    }
    
    _tstar = 1.0;
    _pstar = 1.0e+6;
    //_R = 461.526;

    return self;
}

-(iapws97_4 *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    _ni = malloc(nCoeffs*sizeof(double));

    for (int i=0; i<nCoeffs; i++)
    {
        NSDictionary *dict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"n%d", i+1];
        NSNumber *a = [dict objectForKey:name];
        
        _ni[i] = [a doubleValue];
    }
    
    _tstar = [[[array objectAtIndex:nCoeffs] objectForKey:@"Tstar"] doubleValue];
    _pstar = [[[array objectAtIndex:nCoeffs+1] objectForKey:@"Pstar"] doubleValue];

    return self;
}

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [iapws97_4 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return [self PsForT:T];
}

-(double)PsForT:(double)T
{
    double tr = T/_tstar;
    double v = tr + _ni[8]/(tr - _ni[9]);
    
    double A = v*v + _ni[0]*v + _ni[1];
    double B = _ni[2]*v*v + _ni[3]*v + _ni[4];
    double C = _ni[5]*v*v + _ni[6]*v + _ni[7];
    
    double denom = -B + sqrt(B*B - 4.0*A*C);
    double q = pow(2.0*C/denom, 4.0);
    return q*_pstar;
}

-(double)TsForp:(double)p
{
    double beta = pow(p/_pstar, 0.25);
    double E = beta*beta + _ni[2]*beta + _ni[5];
    double F = _ni[0]*beta*beta + _ni[3]*beta + _ni[6];
    double G = _ni[1]*beta*beta + _ni[4]*beta + _ni[7];
    
    double D = 2.0*G/( -F - sqrt(F*F - 4.0*E*G));
    
    double s = (_ni[9]+D)*(_ni[9]+D) - 4.0*(_ni[8] + _ni[9]*D);
    double q = _ni[9] + D - sqrt(s);
    
    return 0.5*q*_tstar;
}

-(bool)pressureDependent
{
    return NO;
}

-(bool)temperatureDependent
{
    return YES;
}

-(int)nCoefficients
{
    return nCoeffs+2;
}

- (NSString *)equationText
{
    return @"";
}

- (void)dealloc
{
    free(_ni);
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
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for (int i=0; i<nCoeffs; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"n%d", i+1];
        [names addObject:name];
    }
    
    [names addObject:@"Tstar"];
    [names addObject:@"Pstar"];
    
    return names;
}

@end
