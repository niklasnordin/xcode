//
//  fundamentalJacobsen.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface fundamentalJacobsenRho : NSObject <functionValue>

@property (nonatomic) double *A;

@property (nonatomic) double *ik;
@property (nonatomic) double *jk;
@property (nonatomic) double *lk;
@property (nonatomic) double *nk;

@property (nonatomic) double tc;
@property (nonatomic) double pc;
@property (nonatomic) double rhoc;
@property (nonatomic) double mw;

@property NSMutableDictionary *functionPointers;
@end
