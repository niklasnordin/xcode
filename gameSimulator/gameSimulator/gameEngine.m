//
//  gameEngine.m
//  gameSimulator
//
//  Created by Niklas Nordin on 2013-11-09.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "gameEngine.h"

@implementation gameEngine

- (int)indexWithI:(int)i J:(int)j
{
    int ii = (i + self.nx) % self.nx;
    int jj = (j + self.ny) % self.ny;
    
    int k = ii + jj*self.nx;
    
    return k;
}

- (void)setup
{
    self.grass = malloc(self.nx*self.ny*sizeof(double));
    self.rabbit = malloc(self.nx*self.ny*sizeof(double));
    self.predator = malloc(self.nx*self.ny*sizeof(double));

}

- (id)init
{
    self = [super init];
    if (self)
    {
        _nx = 0;
        _ny = 0;
        [self setup];
    }
    return self;
}

- (id)initWithNx:(int)Nx Ny:(int)Ny
{
    self = [super init];
    if (self)
    {
        _nx = Nx;
        _ny = Ny;
        [self setup];
    }
    return self;
}

- (void)updatePopulation:(double)dt
{
 
    // grass
    // a = linear growth rate
    // b = amount eaten by rabbits
    // (d/dt)grass = a - b*rabbit*grass
    
    // rabbits
    // c = reproduction/feeding rate of rabbits
    // d = feeding rate for predators
    //
    // (d/dt)rabbit = c*rabbit*grass - d*predators*rabbit
    
    // predators
    // e = reproduction rate for predators
    // (d/dt)predators = e*predators*rabbits
    
}

@end





