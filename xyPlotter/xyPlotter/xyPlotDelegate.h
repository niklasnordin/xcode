//
//  xyPlotDelegate.h
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-02.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol xyPlotDelegate <NSObject>

-(CGFloat) xMin;
-(CGFloat) xMax;
-(CGFloat) yMin;
-(CGFloat) yMax;

-(CGFloat) validXMin;
-(CGFloat) validXMax;

@end
