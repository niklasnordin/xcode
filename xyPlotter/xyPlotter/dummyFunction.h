//
//  dummyFunction.h
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-02.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xyPlotDataSource.h"
#import "xyPlotDelegate.h"

@interface dummyFunction : NSObject
<
    xyPlotDelegate,
    xyPlotDataSource
>

@end
