//
//  FJ_u.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-28.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fundamentalJacobsen.h"
#import "functionValue.h"

@interface FJ_u : fundamentalJacobsen <functionValue>

@property (strong, nonatomic) id<functionValue> rho;

@end
