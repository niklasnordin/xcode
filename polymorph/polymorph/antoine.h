//
//  antoine.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-10-13.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface antoine : NSObject <functionValue>

@property (nonatomic) double *A;
@property (nonatomic) double ref;

@end
