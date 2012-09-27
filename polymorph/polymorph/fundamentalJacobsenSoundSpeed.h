//
//  fundamentalJacobsenSoundSpeed.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-27.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"
#import "fundamentalJacobsen.h"

@interface fundamentalJacobsenSoundSpeed : fundamentalJacobsen <functionValue>

@property (strong, nonatomic) id<functionValue> rho;
@property (strong, nonatomic) id<functionValue> cp;
@property (strong, nonatomic) id<functionValue> cv;

@end
