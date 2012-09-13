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

@property (nonatomic) double xMin, xMax, yMin, yMax, xMid, yMid;
@property (nonatomic) double lowerRange, upperRange;
@property (nonatomic) double cpv;
@property (weak, nonatomic) id <functionValue> function;
@property (strong, nonatomic) NSArray *coeffs;
@property (weak, nonatomic) NSDictionary *dict;
@property (nonatomic) BOOL xIsT;

-(void)checkRange;
-(void)fitToView:(diagramView *)view;
-(void)setup:(double)xmin max:(double)xmax;
@property (strong, nonatomic) IBOutlet UILabel *yMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *yMinLabel;
@property (strong, nonatomic) IBOutlet UILabel *xMinLabel;
@property (strong, nonatomic) IBOutlet UILabel *xMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *yMidLabel;

-(void)drawCoordinateSystem:(CGContextRef)context;

-(void)pan:(UIPanGestureRecognizer *)gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)tap:(UITapGestureRecognizer *)gesture;

+(CGPoint) mapPoint:(diagramView *)view X:(double)x Y:(double)y;


@end
