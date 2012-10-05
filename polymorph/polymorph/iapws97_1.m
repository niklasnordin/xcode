//
//  iapws97_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-05.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97_1.h"

static NSString *name = @"iapws97_1";

@implementation iapws97_1

+(NSString *)name
{
    return name;
}

-(iapws97_1 *)initWithZero
{
    self = [super init];
    
    int n = 34;
    
    _ik = malloc(n*sizeof(long double));
    _jk = malloc(n*sizeof(long double));
    _nk = malloc(n*sizeof(long double));
    
    for (int i=0; i<n; i++)
    {
        _ik[i] = 0.0;
        _jk[i] = 0.0;
        _nk[i] = 0.0;
    }

    _pstar = 16.53e+6;
    _tstar = 1386.0;
    _R = 461.526;
    
    return self;
}

-(iapws97_1 *)initWithArray:(NSArray *)array
{
    self = [super init];

    int n = 34;
    
    _ik = malloc(n*sizeof(long double));
    _jk = malloc(n*sizeof(long double));
    _nk = malloc(n*sizeof(long double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Aidict = [array objectAtIndex:i];
        NSDictionary *Ajdict = [array objectAtIndex:i+n];
        NSDictionary *Andict = [array objectAtIndex:i+2*n];
        
        NSString *iname = [NSString stringWithFormat:@"A%d", i];
        NSString *jname = [NSString stringWithFormat:@"A%d", i+n];
        NSString *nname = [NSString stringWithFormat:@"A%d", i+2*n];
        
        NSNumber *aik = [Aidict objectForKey:iname];
        NSNumber *ajk = [Ajdict objectForKey:jname];
        NSNumber *ank = [Andict objectForKey:nname];
        
        _ik[i] = [aik doubleValue];
        _jk[i] = [ajk doubleValue];
        _nk[i] = [ank doubleValue];
        
    }
    
    _pstar = [[[array objectAtIndex:92] objectForKey:@"A102"] doubleValue];
    _tstar = [[[array objectAtIndex:93] objectForKey:@"A103"] doubleValue];
    _R     = [[[array objectAtIndex:94] objectForKey:@"A104"] doubleValue];
    
    return self;
}

-(NSString *) name
{
    return [iapws97_1 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return 0.0;
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
    return 105; //34*3 + 3;
}

- (NSString *)equationText
{
    return @"";
}

- (void)dealloc
{
    free(_ik);
    free(_jk);
    free(_nk);
}

-(NSArray *)dependsOnFunctions
{
    return nil;
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
}

-(long double)gammaForP:(long double)p andT:(long double)T
{
    return 0.0;
}

@end
