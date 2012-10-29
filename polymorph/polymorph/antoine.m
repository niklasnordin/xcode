//
//  antoine.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-13.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "antoine.h"

static NSString *name = @"antoine";

@implementation antoine

+(NSString *)name
{
    return name;
}

-(antoine *)initWithZero
{
    self = [super init];
    
    int n = 3;
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
    }
    _ref = 1.0;
    return self;
}


-(antoine *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = 3;
    
    _A = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d", i];
        NSNumber *a = [Adict objectForKey:name];
        _A[i] = [a doubleValue];
    }
    
    NSDictionary *dict = [array objectAtIndex:3];
    _ref = [[dict objectForKey:@"ref"] doubleValue];

    return self;
}

-(NSString *) name
{
    return [antoine name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double lg = _A[0] - _A[1]/(T + _A[2]);
    double y = _ref*pow(10.0, lg);
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

-(NSArray *)coefficientNames
{
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
        [names addObject:name];
    }
    
    [names addObject:@"ref"];
    return names;
}

-(BOOL)requirementsFulfilled
{
    return YES;
}

@end
