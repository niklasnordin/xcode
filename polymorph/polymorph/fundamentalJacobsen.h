//
//  fundamentalJacobsen.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface fundamentalJacobsen : NSObject

@property (nonatomic) long double *ik;
@property (nonatomic) long double *jk;
@property (nonatomic) long double *lk;
@property (nonatomic) long double *nk;

@property (nonatomic) long double tc;
@property (nonatomic) long double pc;
@property (nonatomic) long double rhoc;
@property (nonatomic) long double mw;

-(fundamentalJacobsen *)initWithZero;
-(fundamentalJacobsen *)initWithArray:(NSArray *)array;

-(double)d2a0dt2:(double)pressure T:(double)temperature cp0:(id<functionValue>)cp0;
-(double)daResdd:(long double)d t:(long double)t;
-(double)d2aResdd2:(long double)d t:(long double)tau;
-(double)d2aResdt2:(long double)delta t:(long double)tau;
-(double)d2aResdddt:(long double)delta t:(long double)tau;

@end
