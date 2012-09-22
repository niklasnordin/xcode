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

@property (nonatomic) long double *ik;
@property (nonatomic) long double *jk;
@property (nonatomic) long double *lk;
@property (nonatomic) long double *nk;

@property (nonatomic) long double tc;
@property (nonatomic) long double pc;
@property (nonatomic) long double rhoc;
@property (nonatomic) long double mw;

@property NSMutableDictionary *functionPointers;
@end
