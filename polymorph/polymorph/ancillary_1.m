//
//  ancillary_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-26.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "ancillary_1.h"

static NSString *name = @"ancillary_1";

@implementation ancillary_1

+(NSString *)name
{
    return name;
}

-(ancillary_1 *)initWithZero
{
    self = [super init];
    
    int n = [self nCoefficients];
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
    }
    return self;
}

-(ancillary_1 *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = [self nCoefficients];
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d", i];
        NSNumber *a = [Adict objectForKey:name];
        _A[i] = [a doubleValue];
    }
    
    return self;
}

-(NSString *) name
{
    return [ancillary_1 name];
}

-(double)valueForT:(double)T andP:(double)p
{

    double pc = _A[8];
    double Tc = _A[9];
    
    double phi = 1.0 - T/Tc;
    //phi = fmax(0.0, phi);
    double rhs = _A[0]*pow(phi, _A[4]) + _A[1]*pow(phi, _A[5]) + _A[2]*pow(phi, _A[6]) + _A[3]*pow(phi, _A[7]);
    
    return pc*exp(Tc*rhs/T);
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
    return 10;
}

- (NSString *)equationText
{
    return @"";
}

- (void)dealloc
{
    free(_A);
}

-(NSArray *)dependsOnFunctions
{
    return nil;
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    
}

@end
