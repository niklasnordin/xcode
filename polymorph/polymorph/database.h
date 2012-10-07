//
//  database.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface database : NSObject

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableDictionary *json;

-(void)readFile:(NSString *)file;
-(void)readURL:(NSString *)link;
-(NSArray *)species;
-(NSArray *)orderedSpecies;
-(NSArray *)propertiesForSpecie:(NSString *)specie;
-(NSArray *)orderedPropertiesForSpecie:(NSString *)specie;
-(NSMutableDictionary *)createEmptyPropertyDict;
-(NSMutableArray *)createCoefficients:(int)numberOfCoefficients
                            withNames:(NSArray *)names;

@end
