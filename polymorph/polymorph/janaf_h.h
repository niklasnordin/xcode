//
//  janaf_h.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-16.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "functionValue.h"

@interface janaf_h : NSObject <functionValue>

@property (nonatomic) double *A;
@property (nonatomic) double R;

@end
