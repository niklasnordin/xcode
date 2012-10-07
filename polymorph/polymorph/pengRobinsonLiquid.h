//
//  pengRobinsonHigh.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface pengRobinsonLiquid: NSObject <functionValue>

@property (nonatomic) double tc;
@property (nonatomic) double pc;
@property (nonatomic) double omega;
@property (nonatomic) double mw;

@end
