//
//  functionValue.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol functionValue <NSObject>

-(id)initWithArray:(NSArray *)coeffs;
-(id)initWithZero;
-(NSArray *)dependsOnFunctions;
-(void)setFunction:(id)function forKey:(NSString *)key;
-(double) valueForT:(double)T andP:(double)p;
-(int) nCoefficients;
-(bool) pressureDependent;
-(bool) temperatureDependent;
-(NSString *) name;
-(NSString *) equationText;
+(NSString *) name;
-(NSArray *)coefficientNames;

@end
