//
//  fundamentalJacobsen.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fundamentalJacobsen.h"
#import "functionValue.h"

@interface fundamentalJacobsenRho : fundamentalJacobsen <functionValue>

@property (strong, nonatomic) id<functionValue> pv;
@property (strong, nonatomic) id<functionValue> rholSat;
@property (strong, nonatomic) id<functionValue> rhovSat;

@end
