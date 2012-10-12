//
//  iapws97.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "iapws97.h"

static NSString *name = @"iapws97";
static int nCoeffs = 0;

@implementation iapws97

-(iapws97 *)initWithZero
{
    self = [super init];
    /*
     _ii = malloc(nCoeffs*sizeof(long double));
     _ji = malloc(nCoeffs*sizeof(long double));
     _ni = malloc(nCoeffs*sizeof(long double));
     
     for (int i=0; i<nCoeffs; i++)
     {
     _ii[i] = 0.0;
     _ji[i] = 0.0;
     _ni[i] = 0.0;
     }
     
     _tstar = 1386.0;
     _pstar = 16.53e+6;
     _R = 461.526;
     */
    return self;
}

-(iapws97 *)initWithArray:(NSArray *)array
{
    self = [super init];
    /*
     for (int i=0; i<nCoeffs; i++)
     {
     NSDictionary *Aidict = [array objectAtIndex:i];
     NSDictionary *Ajdict = [array objectAtIndex:i+nCoeffs];
     NSDictionary *Andict = [array objectAtIndex:i+2*nCoeffs];
     
     NSString *iname = [NSString stringWithFormat:@"i%d", i+1];
     NSString *jname = [NSString stringWithFormat:@"j%d", i+1];
     NSString *nname = [NSString stringWithFormat:@"n%d", i+1];
     
     NSNumber *aik = [Aidict objectForKey:iname];
     NSNumber *ajk = [Ajdict objectForKey:jname];
     NSNumber *ank = [Andict objectForKey:nname];
     
     _ii[i] = [aik doubleValue];
     _ji[i] = [ajk doubleValue];
     _ni[i] = [ank doubleValue];
     
     }
     
     _tstar = [[[array objectAtIndex:3*nCoeffs] objectForKey:@"Tstar"] doubleValue];
     _pstar = [[[array objectAtIndex:3*nCoeffs+1] objectForKey:@"Pstar"] doubleValue];
     _R     = [[[array objectAtIndex:3*nCoeffs+2] objectForKey:@"R"] doubleValue];
     */
    return self;
}

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [iapws97 name];
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
    return 3*nCoeffs+3;
}

- (NSString *)equationText
{
    return @"";
}

-(NSArray *)dependsOnFunctions
{
    return @[ @"iapws97_1", @"iapws97_2", @"iapws97_2b", @"iapws97_3", @"iapws97_4", @"iapws97_5" ];
}

-(void)setFunction:(id)function forKey:(NSString *)key
{
    if ([key isEqualToString:@"iapws97_1"])
    {
        _iapws1 = function;
    }
    
    if ([key isEqualToString:@"iapws97_2"])
    {
        _iapws2 = function;
    }
    
    if ([key isEqualToString:@"iapws97_2b"])
    {
        _iapws2b = function;
    }
    
    if ([key isEqualToString:@"iapws97_3"])
    {
        _iapws3 = function;
    }
    
    if ([key isEqualToString:@"iapws97_4"])
    {
        _iapws4 = function;
    }
    
    if ([key isEqualToString:@"iapws97_5"])
    {
        _iapws5 = function;
    }
}

-(NSArray *)coefficientNames
{
    return nil;
    /*
     NSMutableArray *names = [[NSMutableArray alloc] init];
     
     for (int i=0; i<nCoeffs; i++)
     {
     NSString *name = [[NSString alloc] initWithFormat:@"i%d", i+1];
     [names addObject:name];
     }
     for (int i=0; i<nCoeffs; i++)
     {
     NSString *name = [[NSString alloc] initWithFormat:@"j%d", i+1];
     [names addObject:name];
     }
     for (int i=0; i<nCoeffs; i++)
     {
     NSString *name = [[NSString alloc] initWithFormat:@"n%d", i+1];
     [names addObject:name];
     }
     
     [names addObject:@"Tstar"];
     [names addObject:@"Pstar"];
     [names addObject:@"R"];
     
     return names;
     */
}

@end
