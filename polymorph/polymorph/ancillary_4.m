//
//  ancillary_4.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-23.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "ancillary_4.h"

static NSString *name = @"ancillary_4";

@implementation ancillary_4

//#define Rgas 8314.462175

+(NSString *)name
{
    return name;
}

-(ancillary_4 *)initWithZero
{
    self = [super init];
    
    int n = 9;
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
    }
    _Rgas = 1.0;
    return self;
}

-(ancillary_4 *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = 9;
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d", i];
        NSNumber *a = [Adict objectForKey:name];
        _A[i] = [a doubleValue];
    }
    
    NSDictionary *Rdict = [array objectAtIndex:9];
    NSString *Rname = [NSString stringWithFormat:@"A%d", 9];
    NSNumber *R = [Rdict objectForKey:Rname];
    _Rgas = [R doubleValue];
    
    return self;
}

-(NSString *) name
{
    return [ancillary_4 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double sum = _A[0];
    
    for (int i=0; i<4; i++)
    {
        double theta = _A[i+5]/T;
        double eth = exp(theta);
        
        sum += _A[i+1]*theta*theta*eth*pow(eth-1.0, -2.0);
    }
    
    return sum*_Rgas;
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
