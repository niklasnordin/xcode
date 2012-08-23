//
//  Polynomial.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Polynomial : NSObject

+ (NSArray *)solveSecondOrder:(double)a coeffB:(double)b;
+ (NSMutableArray *)solveThirdOrder:(double)ca coeffB:(double)cb coeffC:(double)cc;
+ (NSMutableArray *)solveThirdOrderReal:(double)ca coeffB:(double)cb coeffC:(double)cc;

@end
