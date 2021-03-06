//
//  database.h
//  myFlow
//
//  Created by Niklas Nordin on 2012-11-17.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface database : NSObject

@property (nonatomic) double length;
@property (nonatomic) double dx;
//@property (nonatomic) double dy;
@property (nonatomic) int nx;
@property (nonatomic) int ny;

@property (nonatomic) double **u;
@property (nonatomic) double **v;
@property (nonatomic) double **p;
@property (nonatomic) double **rho;
@property (nonatomic) double **T;
@property (nonatomic) double mu;

-(database *)initWithBounds:(CGRect)bounds;
-(void)dealloc;

-(double)laplacian:(double **)phi forI:(int)i andJ:(int)j;
-(void)solve;

@end
