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
    
    int n = 4;
    
    _A = malloc(n*sizeof(double));
    _B = malloc(n*sizeof(double));
    
    for (int i=0; i<n; i++)
    {
        _A[i] = 0.0;
        _B[i] = 0.0;
    }
    return self;
}

-(ancillary_1 *)initWithArray:(NSArray *)array
{
    self = [super init];
    
    int n = 4;
    
    _A = malloc(n*sizeof(double));
    _B = malloc(n*sizeof(double));

    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [array objectAtIndex:i];
        NSDictionary *Bdict = [array objectAtIndex:i+n];

        NSString *Aname = [NSString stringWithFormat:@"A%d", i];
        NSString *Bname = [NSString stringWithFormat:@"B%d", i];

        NSNumber *a = [Adict objectForKey:Aname];
        _A[i] = [a doubleValue];
        
        NSNumber *b = [Bdict objectForKey:Bname];
        _B[i] = [b doubleValue];
    }
    
    return self;
}

-(NSString *) name
{
    return [ancillary_1 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    
    double phi = 1.0 - T/_tc;
    
    double rhs = 0;
    for (int i=0; i<4; i++)
    {
        rhs += _A[i]*pow(phi, _B[i]);
    }
    
    return _pc*exp(_tc*rhs/T);
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
    free(_B);
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
    for (int i=0; i<4; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"A%d", i];
        [names addObject:name];
    }

    for (int i=0; i<4; i++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"B%d", i];
        [names addObject:name];
    }

    [names addObject:@"Pc"];
    [names addObject:@"Tc"];
    
    return names;

}

@end
