//
//  polynomial.h
//  PropertyCalculator
//
//  Created by Niklas Nordin on 2011-12-07.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Polynomial : NSObject

+ (NSArray *)solveSecondOrder:(double)a coeffB:(double)b;
+ (NSMutableArray *)solveThirdOrder:(double)ca coeffB:(double)cb coeffC:(double)cc;

@end
