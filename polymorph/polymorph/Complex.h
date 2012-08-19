//
//  Complex.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complex : NSObject

@property (nonatomic) double re;
@property (nonatomic) double im;

- (Complex *)initWithRe:(double)re Im:(double)im;
- (Complex *)initWithRe:(double)re;
- (Complex *)initWithComplex:(Complex *)c;

- (Complex *)add:(Complex *)a;
- (Complex *)subtract:(Complex *)a;
- (Complex *)multiply:(Complex *)c;
- (Complex *)multiplyWithRe:(double)a;
- (Complex *)divide:(Complex *)c;
- (Complex *)sqrt;
- (Complex *)pow:(double)exponent;

@end
