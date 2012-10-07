//
//  ancillary_3.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface ancillary_3 : NSObject <functionValue>

@property (nonatomic) double *A;
@property (nonatomic) double *B;

@property (nonatomic) double rhoc;
@property (nonatomic) double tc;
@end
