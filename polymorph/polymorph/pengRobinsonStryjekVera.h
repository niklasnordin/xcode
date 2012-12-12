//
//  pengRobinsonStryjekVera.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-12-12.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface pengRobinsonStryjekVera : NSObject <functionValue>

@property (nonatomic) double tc;
@property (nonatomic) double pc;
@property (nonatomic) double omega;
@property (nonatomic) double mw;
@property (nonatomic) double kappa1;

@end
