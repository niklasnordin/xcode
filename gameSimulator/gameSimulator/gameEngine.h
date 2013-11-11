//
//  gameEngine.h
//  gameSimulator
//
//  Created by Niklas Nordin on 2013-11-09.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gameEngine : NSObject

@property (nonatomic) int nx;
@property (nonatomic) int ny;
@property (nonatomic) double dt;

// these are the population of the individuals ranging from 0 to 100 %
@property (nonatomic) double *grass;
@property (nonatomic) double *rabbit;
@property (nonatomic) double *predator;

@property (nonatomic) double aGrass;
@property (nonatomic) double bGrass;
@property (nonatomic) double dGrass;

@property (nonatomic) double aRabbit;
@property (nonatomic) double bRabbit;
@property (nonatomic) double dRabbit;

@property (nonatomic) double aPredator;
@property (nonatomic) double dPredator;

- (id)init;
- (id)initWithNx:(int)Nx Ny:(int)Ny;
- (void)updatePopulation:(double)dt;

@end
