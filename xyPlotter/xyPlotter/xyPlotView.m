//
//  xyPlotView.m
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "xyPlotView.h"

#define NX 320 // 640
#define TICKWIDTH 5.0

@interface xyPlotView ()
-(void)drawCoordinateSystem:(CGContextRef)context;
@end

@implementation xyPlotView

- (void)setup
{
    // Do the setup
    self.contentMode = UIViewContentModeRedraw;

    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];

}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)gesture;
{
    //NSLog(@"pan");
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    //NSLog(@"pinch");
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"tap");
}


-(void)drawCoordinateSystem:(CGContextRef)context
{
    
    CGPoint p;
    
    CGPoint yAxisStart, yAxisEnd, xAxisStart, xAxisEnd;
    yAxisStart.x = self.bounds.origin.x + self.bounds.size.width/2.0;
    yAxisStart.y = self.bounds.origin.y + self.bounds.size.height;
    
    yAxisEnd.x = yAxisStart.x;
    yAxisEnd.y = self.bounds.origin.y;
    
    xAxisStart.x = self.bounds.origin.x;
    xAxisStart.y = self.bounds.origin.y + self.bounds.size.height / 2.0;
    
    xAxisEnd.x = self.bounds.origin.x + self.bounds.size.width;
    xAxisEnd.y = xAxisStart.y;
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    // draw y-axis
    CGContextMoveToPoint(context, yAxisStart.x, yAxisStart.y);
    CGContextAddLineToPoint(context, yAxisEnd.x, yAxisEnd.y);
    
    // draw x-axis;
    CGContextMoveToPoint(context, xAxisStart.x, xAxisStart.y);
    CGContextAddLineToPoint(context, xAxisEnd.x, xAxisEnd.y);
    
 
    CGFloat xMin = [[self delegate] xMin];
    CGFloat xMax = [[self delegate] xMax];
    CGFloat yMin = [[self delegate] yMin];
    CGFloat yMax = [[self delegate] yMax];
    // draw x-axis ticks
    CGFloat dx = xMax - xMin;
    CGFloat logDx = log10(dx);
    int ilog = logDx - 1;
    double xTickSpace = pow(10.0, ilog);
    int iStart = xMin/xTickSpace;
    int iEnd = xMax/xTickSpace + 1;

    p.y = 0.0;
    for(int i=iStart; i<iEnd; i++)
    {
        p.x = i*xTickSpace;
        
        CGPoint p0 = [self mapPointToView:p];
        
        CGContextMoveToPoint(context, p0.x, xAxisStart.y + TICKWIDTH);
        CGContextAddLineToPoint(context, p0.x, xAxisStart.y - TICKWIDTH);
    }
    
    // draw y-axis ticks
    double dy = yMax - yMin;
    int jlog = log10(dy) - 1;
    double yTickSpace = pow(10.0, jlog);
    int jStart = yMin/yTickSpace;
    int jEnd = yMax/yTickSpace + 1;
    p.x = 0.0;
    for (int j=jStart; j<jEnd; j++)
    {
        p.y = j*yTickSpace;
        
        CGPoint p0 = [self mapPointToView:p];
        CGContextMoveToPoint(context, yAxisStart.x - TICKWIDTH, p0.y);
        CGContextAddLineToPoint(context, yAxisStart.x + TICKWIDTH, p0.y);
        
    }
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
    /*
    // set red text color if it is out of range
    self.yMinLabel.text = [NSString stringWithFormat:@"%g", self.yMin];
    self.yMaxLabel.text = [NSString stringWithFormat:@"%g", self.yMax];
    
    double xv = self.xMin;
    if (!_xIsT)
    {
        xv *= 1.0e-6;
    }
    self.xMinLabel.text = [NSString stringWithFormat:@"%g", xv];
    
    if (_xMin < _lowerRange)
    {
        self.xMinLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.xMinLabel.textColor = [UIColor whiteColor];
    }
    
    xv = self.xMax;
    if (!_xIsT)
    {
        xv *= 1.0e-6;
    }
    self.xMaxLabel.text = [NSString stringWithFormat:@"%g", xv];
    if (_xMax > _upperRange)
    {
        self.xMaxLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.xMaxLabel.textColor = [UIColor whiteColor];
    }
    
    xv = self.xMid;
    if (!_xIsT)
    {
        xv *= 1.0e-6;
    }
    
    self.yMidLabel.text = [NSString stringWithFormat:@"%g, %.10e", xv, self.yMid];
    
    CGPoint pos = [diagramView mapPoint:self X:self.xMid Y:self.yMid];
    
    // make sure the text dont go out of view
    int pixelOffset = 25;
    if (pos.y < pixelOffset)
    {
        pos.y = pixelOffset;
    }
    
    if (pos.y > yAxisStart.y - pixelOffset)
    {
        pos.y = yAxisStart.y - pixelOffset;
    }
    if(isnan(pos.y))
    {
        pos.y = xAxisStart.y;
    }
    self.yMidLabel.center = pos;
     */
}

-(CGPoint)mapPointToView:(CGPoint)point
{
    CGPoint p;
    
    CGFloat xMin = [[self delegate] xMin];
    CGFloat xMax = [[self delegate] xMax];
    CGFloat yMin = [[self delegate] yMin];
    CGFloat yMax = [[self delegate] yMax];
    
    CGFloat dx = xMax - xMin;
    CGFloat dy = yMax - yMin;
    
    if (dx > 0)
    {
        p.x = (point.x - xMin)*self.bounds.size.width/dx;
    }
    else
    {
        p.x = 0.0;
    }
    
    if (dy > 0)
    {
        p.y = self.bounds.size.height - (point.y - yMin)*self.bounds.size.height/dy;
    }
    else
    {
        p.y = 0.0;
    }
    return p;
}

-(CGPoint)mapViewToPoint:(CGPoint)point
{
    CGPoint p;
    
    return p;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateSystem:context];
    CGFloat xMin = [self.delegate xMin];
    CGFloat y = [self.dataSource yForX:xMin];
    NSLog(@"x=%g, y=%g",xMin,y);
}

@end
