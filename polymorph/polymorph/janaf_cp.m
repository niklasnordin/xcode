//
//  janaf_cp.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-16.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "janaf_cp.h"

static NSString *name = @"janaf_cp";

@implementation janaf_cp

+(NSString *)name
{
    return name;
}

-(janaf_cp *)initWithZero
{
    self = [super init];
    
    int n = [self nCoefficients]-1;
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
    }
    return self;
}

-(janaf_cp *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = [self nCoefficients]-1;
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d", i];
        NSNumber *a = [Adict objectForKey:name];
        _A[i] = [a doubleValue];
    }
    
    NSDictionary *Adict = [array objectAtIndex:7];
    NSNumber *a = [Adict objectForKey:@"R"];
    _R = [a doubleValue];
    return self;
}

-(NSString *) name
{
    return [janaf_cp name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double y = ((((_A[4]*T + _A[3])*T + _A[2])*T + _A[1])*T + _A[0] )*_R;
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
    return 8;
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
    for (int i=0; i<[self nCoefficients]-1; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
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
