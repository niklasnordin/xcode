//
//  xyPlotDataSource.h
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol xyPlotDataSource <NSObject>

-(double) yForX:(double)x;

@end
