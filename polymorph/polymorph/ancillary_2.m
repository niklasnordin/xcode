//
//  ancillary_2.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "ancillary_2.h"

static NSString *name = @"ancillary_2";

@implementation ancillary_2

+(NSString *)name
{
    return name;
}

-(ancillary_2 *)initWithZero
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

-(ancillary_2 *)initWithArray:(NSArray *)array
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
    return [ancillary_2 name];
}

-(double)valueForT:(double)T andP:(double)p
{

    double rhoc = _A[10];
    double Tc   = _A[11];
    
    double phi = 1.0 - T/Tc;
    //phi = fmax(0.0, phi);
    
    double rhs = 1.0 + _A[0]*pow(phi, _A[5]) + _A[1]*pow(phi, _A[6])
        + _A[2]*pow(phi, _A[7]) + _A[3]*pow(phi, _A[8]) + _A[4]*pow(phi, _A[9]);
    
    return rhoc*rhs;
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
    return 12;
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
