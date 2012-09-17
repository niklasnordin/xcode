//
//  nsrds_1.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-29.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "nsrds_1.h"

static NSString *name = @"nsrds_1";

@implementation nsrds_1

+(NSString *)name
{
    return name;
}

-(nsrds_1 *)initWithArray:(NSArray *)array
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
    return [nsrds_1 name];
}

-(double)valueForT:(double)T andP:(double)p
{
    double y = exp(_A[0] + _A[1]/T + _A[2]*log(T) + _A[3]*pow(T, _A[4]));
    return y;
}

-(bool)pressureDependent
{
    return NO;
}

-(int)nCoefficients
{
    return 5;
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
