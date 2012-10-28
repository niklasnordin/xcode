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
    
    int n = 5;
    
    _A = malloc(n*sizeof(double));
    _theta = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
        _theta[i] = 0.0;
    }

    return self;
}

-(ancillary_4 *)initWithArray:(NSArray *)array
{
    self = [super init];
    int n = 5;
    
    _A = malloc(n*sizeof(double));
    _theta = malloc(n*sizeof(double));

    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d", i];
        NSNumber *a = [Adict objectForKey:name];
        _A[i] = [a doubleValue];
    }
    
    for (int i=0; i<4; i++)
    {
        NSDictionary *thetaDict = [array objectAtIndex:i+n];
        NSString *name = [NSString stringWithFormat:@"theta%d", i+1];
        NSNumber *theta = [thetaDict objectForKey:name];
        _theta[i+1] = [theta doubleValue];
    }

    _R  = [[[array objectAtIndex:9] objectForKey:@"R"] doubleValue];

    return self;
}

-(NSString *) name
{
    return [ancillary_4 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    long double sum = _A[0];
    
    for (int i=1; i<5; i++)
    {
        long double theta = _theta[i]/T;
        long double eth = expl(theta);
        long double denom = (eth-1.0)*(eth-1.0);
        sum += _A[i]*theta*theta*eth/denom;
    }
    
    return sum*_R;
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
    free(_theta);
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
    for (int i=0; i<5; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
        [names addObject:name];
    }
    for (int i=0; i<4; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"theta%d", i+1];
        [names addObject:name];
    }
    [names addObject:@"R"];
    return names;

}

-(BOOL)requirementsFulfilled
{
    return YES;
}

@end
