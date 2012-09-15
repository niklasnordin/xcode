//
//  database.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "database.h"

@implementation database

-(void)readFile:(NSString *)file
{
    //NSURL *url = [NSURL fileURLWithPath:@"/Users/niklasnordin/Documents/dropbox.git/polymorph/polymorph/database2.json"];
    _url = [NSURL fileURLWithPath:file];

}

-(void)readURL:(NSString *)link
{
    //NSLog(@"readURL:%@",link);
    //NSURL *url = [NSURL URLWithString:@"http://properties.nequam.se/database.json"];
    
    _url = nil;
    _jsonData = nil;
    _json = nil;
    
    NSError *error = nil;

    _url = [NSURL URLWithString:link];
    _jsonData = [NSData dataWithContentsOfURL:_url];
    
    if (_jsonData)
    {
        _json = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingMutableContainers error:&error];
    }
}

-(NSArray *)species
{
    return [_json allKeys];
}

-(NSArray *)orderedSpecies
{
    NSArray *names = [[self species] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return names;
}

-(NSArray *)propertiesForSpecie:(NSString *)specie
{
    NSDictionary *dict = [_json objectForKey:specie];
    return [dict allKeys];
}

-(NSArray *)orderedPropertiesForSpecie:(NSString *)specie
{
    NSArray *names = [[self propertiesForSpecie:specie]
                      sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return names;
}

-(NSMutableDictionary *)createEmptyPropertyDict
{
    
    NSDictionary *tempRangeDict = @{ @"min" : @250.0 , @"max" : @500.0 };
    NSDictionary *pressureRangeDict = @{ @"min" : @0.0, @"max" : @1.0e+10 };

    NSMutableDictionary *mTempRangeDict = [[NSMutableDictionary alloc] initWithDictionary:tempRangeDict];
    NSMutableDictionary *mPressureRangeDict = [[NSMutableDictionary alloc] initWithDictionary:pressureRangeDict];
    NSMutableArray *coefficients = [self createCoefficients:6];
    
    NSDictionary *dict = @{
        @"function" : @"nsrds_0",
        @"temperatureRange" : mTempRangeDict,
        @"pressureRange" : mPressureRangeDict,
        @"coefficients" : coefficients,
        @"unit" : @"-",
        @"comment" : @""
    };
    
    NSMutableDictionary *muteDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    return muteDict;
}

-(NSMutableArray *)createCoefficients:(int)numberOfCoefficients
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<numberOfCoefficients; i++) {
        NSString *name = [NSString stringWithFormat:@"A%d",i];
        NSNumber *num = @0.0;
        NSDictionary *dict = @{ name : num };
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [arr addObject:mDict];
    }
    return arr;
}
@end
