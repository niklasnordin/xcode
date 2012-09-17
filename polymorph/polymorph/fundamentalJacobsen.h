//
//  fundamentalJacobsen.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface fundamentalJacobsen : NSObject <functionValue>

@property (nonatomic) double *A;

@property (strong, nonatomic) NSMutableArray *ik;
@property (strong, nonatomic) NSMutableArray *jk;
@property (strong, nonatomic) NSMutableArray *nk;
@property (strong, nonatomic) NSMutableArray *lk;

@property (nonatomic) double tc;
@property (nonatomic) double pc;
@property (nonatomic) double rhoc;
@property (nonatomic) double mw;

@end
