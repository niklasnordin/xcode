//
//  xyPlotView.h
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xyPlotDataSource.h"
#import "xyPlotDelegate.h"

@interface xyPlotView : UIView

@property id <xyPlotDataSource> dataSource;
@property id <xyPlotDelegate> delegate;

-(int)Nx;

-(CGPoint) mapPointToView:(CGPoint)point;
-(CGPoint) mapViewToPoint:(CGPoint)point;

-(void)setup;
-(void)pan:(UIPanGestureRecognizer *)gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)tap:(UITapGestureRecognizer *)gesture;

@end
