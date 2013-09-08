//
//  diagramView.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-21.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "functionValue.h"

@interface diagramView : UIView

@property (nonatomic) float xMin, xMax, yMin, yMax, xMid, yMid;
@property (nonatomic) float lowerRange, upperRange;
@property (nonatomic) float cpv;
@property (weak, nonatomic) id <functionValue> function;
@property (weak, nonatomic) NSDictionary *dict;
@property (nonatomic) BOOL xIsT;

@property (nonatomic) float *xValues;
@property (nonatomic) float *yValues;

-(void)checkRange;
-(void)fitToView:(diagramView *)view;
-(void)setup:(float)xmin max:(float)xmax;

@property (weak, nonatomic) IBOutlet UILabel *yMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *yMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *xMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *xMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *yMidLabel;

-(void)drawCoordinateSystem:(CGContextRef)context;

-(void)pan:(UIPanGestureRecognizer *)gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)tap:(UITapGestureRecognizer *)gesture;

-(CGPoint) mapPoint:(CGPoint)point;

@end
