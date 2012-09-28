//
//  fundamentalJacobsenCp.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-23.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"
#import "fundamentalJacobsen.h"

@interface fundamentalJacobsenCp : fundamentalJacobsen <functionValue>

@property (strong, nonatomic) id<functionValue> rho;
@property (strong, nonatomic) id<functionValue> cv;

@end
