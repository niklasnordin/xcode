//
//  boilingTemperature.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-09-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "functionValue.h"

@interface boilingTemperature : NSObject <functionValue>

@property (strong, nonatomic) id<functionValue> pv;

@end
