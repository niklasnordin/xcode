//
//  nsrds_2.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-28.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_2.h"

static NSString *name = @"nsrds_2";

@implementation nsrds_2

+(NSString *)name
{
    return name;
}

-(nsrds_2 *)initWithZero
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


-(nsrds_2 *)initWithArray:(NSArray *)array
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
    return [nsrds_2 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double y = _A[0]*pow(T, _A[1])/(1.0 + _A[2]/T + _A[3]/T/T);
    return y;
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
    return 4;
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
