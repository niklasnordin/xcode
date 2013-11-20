//
//  pdf.h
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol pdf <NSObject>

- (float)sample:(float)x;
- (float)value:(float)x;

@end
