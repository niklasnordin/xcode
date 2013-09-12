//
//  EGRCalculator.h
//  EGRCalculator
//
//  Created by Niklas Nordin on 2011-12-03.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGRCalculator : NSObject

@property (nonatomic) double cn;
@property (nonatomic) double cm;
@property (nonatomic) double cr;

@property (nonatomic) double lambda;
@property (nonatomic) double egr;

@property (nonatomic) double o2;
@property (nonatomic) double n2;

- (EGRCalculator *)initWithLambda:(NSString *)lambda
                             egr:(NSString*)egr
                              cn:(NSString *)cn
                              cm:(NSString *)cm
                              cr:(NSString *)cr
                          oxygen:(NSString *)oxygen
                           nitro:(NSString *)nitro;

- (NSString *)xCO2Ex;
- (NSString *)yCO2Ex;
- (NSString *)xH2OEx;
- (NSString *)yH2OEx;
- (NSString *)xO2Ex;
- (NSString *)yO2Ex;
- (NSString *)xN2Ex;
- (NSString *)yN2Ex;

- (NSString *)xCO2Cyl;
- (NSString *)yCO2Cyl;
- (NSString *)xH2OCyl;
- (NSString *)yH2OCyl;
- (NSString *)xO2Cyl;
- (NSString *)yO2Cyl;
- (NSString *)xN2Cyl;
- (NSString *)yN2Cyl;

- (NSString *)lambdaCyl;

@end
