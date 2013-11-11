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

- (double)averageForField:(double *)f I:(int)i J:(int)j
{
    int indices[9];
    indices[0] = [self indexWithI:i-1 J:j-1];
    indices[1] = [self indexWithI:i J:j-1];
    indices[2] = [self indexWithI:i+1 J:j-1];
    indices[3] = [self indexWithI:i-1 J:j];
    indices[4] = [self indexWithI:i J:j];
    indices[5] = [self indexWithI:i+1 J:j];
    indices[6] = [self indexWithI:i-1 J:j+1];
    indices[7] = [self indexWithI:i J:j+1];
    indices[8] = [self indexWithI:i+1 J:j+1];
    
    double sum = 0.0;
    for (int i=0; i<9; i++)
    {
        sum += f[indices[i]];
    }
    
    return sum;
}

- (double)solveForGrassI:(int)i J:(int)j dT:(double)dt
{
    int k = [self indexWithI:i J:j];
    return dt*(self.aGrass + self.grass[k])/(1.0 + self.bGrass*self.rabbit[k]);
}

- (double)solveForRabbitI:(int)i J:(int)j dT:(double)dt
{
    int k = [self indexWithI:i J:j];
    return dt*self.rabbit[k]/(1.0 - self.aRabbit*self.grass[k] + self.bRabbit*self.predator[k]);
}

- (double)solveForPredatorI:(int)i J:(int)j dT:(double)dt
{
    int k = [self indexWithI:i J:j];
    return dt*self.predator[k]/(1.0 - self.aPredator*self.rabbit[k]);
}

- (void)updatePopulation:(double)dt
{
 
    double averageGrass[self.nx][self.ny];
    double averageRabbit[self.nx][self.ny];
    double averagePredator[self.nx][self.ny];
    
    // grass
    // a = linear growth rate
    // b = amount eaten by rabbits
    // d = spread rate for grass
    // (d/dt)grass = a - b*rabbit*grass
    
    // rabbits
    // a = reproduction/feeding rate of rabbits
    // b = feeding rate for predators
    // d = spread rate for rabbits
    // (d/dt)rabbit = a*rabbit*grass - b*predators*rabbit
    
    // predators
    // a = reproduction rate for predators
    // d = spread rate for predators
    // (d/dt)predators = a*predators*rabbits
    
    for (int i=0; i<self.nx; i++)
    {
        for (int j=0; j<self.ny; j++)
        {
            // update i, j
            int k = [self indexWithI:i J:j];
            self.grass[k] = [self solveForGrassI:i J:j dT:dt];
            self.rabbit[k] = [self solveForRabbitI:i J:j dT:dt];
            self.predator[k] = [self solveForPredatorI:i J:j dT:dt];
            
            averageGrass[i][j] = [self averageForField:self.grass I:i J:j];
            averageRabbit[i][j] = [self averageForField:self.rabbit I:i J:j];
            averagePredator[i][j] = [self averageForField:self.predator I:i J:j];
        }
    }
    
    // diffusion
    for (int i=0; i<self.nx; i++)
    {
        for (int j=0; j<self.ny; j++)
        {
            // update i, j
            int k = [self indexWithI:i J:j];
            self.grass[k] += dt*self.dGrass*(averageGrass[i][j] - self.grass[k]);
            self.rabbit[k] += dt*self.dRabbit*(averageRabbit[i][j] - self.rabbit[k]);
            self.predator[k] += dt*self.dPredator*(averagePredator[i][j] - self.predator[k]);
        }
    }
    
}

@end





