//
//  xyPlotView.h
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xyPlotDataSource.h"

@interface xyPlotView : UIView

@property id <xyPlotDataSource> dataSource;

@end
