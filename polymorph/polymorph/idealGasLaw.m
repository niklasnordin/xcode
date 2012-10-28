//
//  idealGasLaw.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-18.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "idealGasLaw.h"

static NSString *name = @"idealGasLaw";

@implementation idealGasLaw

+(NSString *)name
{
    return name;
}

-(idealGasLaw *)initWithZero
{
    self = [super init];
    return self;
}

-(idealGasLaw *)initWithArray:(NSArray *)array
{
    self = [super init];

    NSDictionary *Adict = [array objectAtIndex:0];
    NSNumber *a = [Adict objectForKey:@"R"];
    _R = [a doubleValue];

    return self;
}

-(NSString *) name
{
    return [idealGasLaw name];
}

-(double)valueForT:(double)T andP:(double)p
{
    return p/( _R*T );
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
    return 1;
}

- (NSString *)equationText
{
    return @"";
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
    [names addObject:@"R"];
    return names;
}

-(BOOL)requirementsFulfilled
{
    return YES;
}

@end
