//
//  nsrds_6.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-24.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_6.h"

static NSString *name = @"nsrds_6";

@implementation nsrds_6


-(nsrds_6 *)initWithZero
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


-(nsrds_6 *)initWithArray:(NSArray *)array
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

+(NSString *)name
{
    return name;
}

-(NSString *) name
{
    return [nsrds_6 name];
}

-(double)valueForT:(double)T andP:(double)p
{

    double Tr = T/_A[5];
    double eVal = _A[1] + Tr*(_A[2] + Tr*(_A[3] + _A[4]*Tr));

    double y = _A[0]*pow(1 - Tr, eVal);

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
    return 6;
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

-(NSArray *)coefficientNames
{
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (int i=0; i<[self nCoefficients]; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
        [names addObject:name];
    }
    return names;
}
@end
