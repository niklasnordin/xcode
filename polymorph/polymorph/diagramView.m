//
//  diagramView.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-21.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "diagramView.h"
#import "functions.h"

static NSUInteger nx = 640;//640;

@implementation diagramView


-(void)setXMin:(double)xMin
{
    _xMin = xMin;
    [self setNeedsDisplay];
}

-(void)setXMax:(double)xMax
{
    _xMax = xMax;
    [self setNeedsDisplay];
}


-(void)setYMin:(double)y
{
    _yMin = y;
    [self setNeedsDisplay];
}


-(void)setYMax:(double)y
{
    _yMax = y;
    [self setNeedsDisplay];
}

-(void)setXMid:(double)x
{
    _xMid = x;
    [self setNeedsDisplay];
}

-(void)setYMid:(double)y
{
    _yMid = y;
    [self setNeedsDisplay];
}

-(void)fitToView:(diagramView *)view
{
    if (![self function])
    {
        NSLog(@"fitToView function == nil");
        return;
    }
    
    _yMin = 1.0e+15;
    _yMax = -1.0e+15;
    
    double p = 1.0e+6*self.pressure;
    
    for (int i=0; i<nx; i++) 
    {
        double xi = _xMin + i*(_xMax - _xMin)/(nx-1);
        //double yi = 2.0*xi -xi*xi;
        
        double yi = [[self function] value:self.coeffs T:xi p:p];
        //NSLog(@"x = %f, yi = %f", xi,yi);
        if (yi < _yMin) _yMin = yi;
        if (yi > _yMax) _yMax = yi;
    }

    double diff = fabs(_yMax - _yMin);

    if (diff < 1.0e-15)
    {
        _yMin -= 1.0e+1;
        _yMax += 1.0+1;
    }   

}

-(void)setup:(double)xmin max:(double)xmax
{
    self.contentMode = UIViewContentModeRedraw;
    _xMin = xmin;
    _xMax = xmax;
    int n = [_function nCoefficients];
    NSArray *coeffDictArray = [self.dict objectForKey:@"coefficients"];
    NSMutableArray *cs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [coeffDictArray objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d",i];
        NSNumber *a = [Adict objectForKey:name];
        [cs addObject:a];
    }

    _coeffs = cs;

    NSDictionary *rangeDict = [self.dict objectForKey:@"temperatureRange"];
    NSNumber *lr = [rangeDict objectForKey:@"min"];
    NSNumber *ur = [rangeDict objectForKey:@"max"];
    _lowerRange = [lr doubleValue];
    _upperRange = [ur doubleValue];
    
    [self fitToView:self];
}

-(void)awakeFromNib
{
    //[self setup];
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setup];
        self.contentMode = UIViewContentModeRedraw;
        // Initialization code
    }
    return self;
}

-(void)checkRange
{
    double xLow = 0.0;
    if (_lowerRange < xLow) xLow = _lowerRange;
    
    if (self.xMin <= xLow)
    {
        self.xMin = xLow;
    }
    
    double xm = 0.5*(self.xMin + self.xMax);
    
    if (xm <= (_lowerRange + 1.0e-5))
    {
        double delta = _lowerRange - xm;
        self.xMin += delta;
        self.xMax += delta;
    }
    
    if (xm >= (_upperRange - 1.0e-5))
    {
        double delta = xm - _upperRange;
        self.xMin -= delta;
        self.xMax -= delta;
    }

}

+(CGPoint) mapPoint:(diagramView *)view X:(double)x Y:(double)y
{
    CGPoint p;
    p.x = view.bounds.origin.x
        + (x - view.xMin)*(view.bounds.size.width - view.bounds.origin.x)/(view.xMax - view.xMin);
    p.y = view.bounds.size.height
        - (y - view.yMin)*(view.bounds.size.height - view.bounds.origin.y)/(view.yMax - view.yMin);
    
    return p;
}

-(void)pan:(UIPanGestureRecognizer *)gesture;
{
    CGPoint pan;
    CGPoint zero;
    zero.x = 0.0;
    zero.y = 0.0;
    
    if
    (   (gesture.state == UIGestureRecognizerStateChanged)
      ||
        (gesture.state == UIGestureRecognizerStateEnded)
    )
    {
        pan = [gesture translationInView:self];
        float xScale = self.bounds.size.width/(self.xMax - self.xMin);
        float yScale = self.bounds.size.height/(self.yMax - self.yMin);
    
        self.xMin -= pan.x/xScale;
        self.xMax -= pan.x/xScale;
    
        self.yMin += pan.y/yScale;
        self.yMax += pan.y/yScale;
        
        [self checkRange];
        [gesture setTranslation:zero inView:self];
    }
}
-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if
    (   (gesture.state == UIGestureRecognizerStateChanged)
      ||
        (gesture.state == UIGestureRecognizerStateEnded)
    )
    {
        CGFloat scale = gesture.scale;
        if (scale != 1.0)
        {
            float xScale = self.xMax - self.xMin;
            float yScale = self.yMax - self.yMin;
            float newXmax = self.xMin + xScale/scale;
            self.xMin = self.xMax - xScale/scale;
            self.xMax = newXmax;
         
            float newYmax = self.yMin + yScale/scale;
            self.yMin = self.yMax - yScale/scale;
            self.yMax = newYmax;
        
            [self checkRange];

            [gesture setScale:1.0];
        }
    }
    
}

-(void)tap:(UITapGestureRecognizer *)gesture;
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self fitToView:self];
        [self setNeedsDisplay];
    }
}

-(void)drawCoordinateSystem:(CGContextRef)context
{
    
    double xi,yi;
    CGPoint tickWidth;
    tickWidth.x = 5.0;
    tickWidth.y = 5.0;
    
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
    
    
    // draw x-axis ticks
    double dx = _xMax - _xMin;
    double logDx = log10(dx);
    int ilog = logDx - 1;
    double xTickSpace = pow(10.0, ilog);
    int iStart = _xMin/xTickSpace;
    int iEnd = _xMax/xTickSpace + 1;
    yi = 0.0;
    for(int i=iStart; i<iEnd; i++)
    {
        xi = i*xTickSpace;
        CGPoint p0 = [diagramView mapPoint:self X:xi Y:yi];
        CGContextMoveToPoint(context, p0.x, xAxisStart.y + tickWidth.y);
        CGContextAddLineToPoint(context, p0.x, xAxisStart.y - tickWidth.y);
    }
    
    // draw y-axis ticks
    double dy = _yMax - _yMin;
    int jlog = log10(dy) - 1;
    double yTickSpace = pow(10.0, jlog);
    int jStart = _yMin/yTickSpace;
    int jEnd = _yMax/yTickSpace + 1;
    xi = 0.0;
    for (int j=jStart; j<jEnd; j++) {
        yi = j*yTickSpace;
        CGPoint p0 = [diagramView mapPoint:self X:xi Y:yi];
        CGContextMoveToPoint(context, yAxisStart.x - tickWidth.x, p0.y);
        CGContextAddLineToPoint(context, yAxisStart.x + tickWidth.x, p0.y);
    }
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
    // set red text color if it is out of range
    self.yMinLabel.text = [NSString stringWithFormat:@"%g", self.yMin];
    self.yMaxLabel.text = [NSString stringWithFormat:@"%g", self.yMax];
    
    self.xMinLabel.text = [NSString stringWithFormat:@"%g", self.xMin];
    if (_xMin < _lowerRange)
    {
        self.xMinLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.xMinLabel.textColor = [UIColor whiteColor];
    }
    
    self.xMaxLabel.text = [NSString stringWithFormat:@"%g", self.xMax];
    if (_xMax > _upperRange)
    {
        self.xMaxLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.xMaxLabel.textColor = [UIColor whiteColor];
    }
    
    self.yMidLabel.text = [NSString stringWithFormat:@"%g, %g", self.xMid,self.yMid];
    CGPoint pos = [diagramView mapPoint:self X:self.xMid Y:self.yMid];

    self.yMidLabel.center = pos;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
            
    NSArray *cf = self.coeffs;
    double p = 1.0e+6*self.pressure;
    
    NSMutableArray *pp = [[NSMutableArray alloc] init];
    
    for (int i=0; i<nx; i++)
    {        
        double xi = _xMin + i*(_xMax - _xMin)/(nx-1);
        double yi = [_function value:cf T:xi p:p];
        CGPoint p0 = [diagramView mapPoint:self X:xi Y:yi];
        [pp addObject:[NSValue valueWithCGPoint:p0]];
    }
    
    for (int i=1; i<nx; i++)
    {
        CGPoint p0 = [[pp objectAtIndex:i-1] CGPointValue];
        CGPoint p1 = [[pp objectAtIndex:i] CGPointValue];
        
        CGContextMoveToPoint(context, p0.x, p0.y);
        CGContextAddLineToPoint(context, p1.x, p1.y);
    }
    
    // commented out cause it was too slow, instead preload all
    // values into an array and plot that
    /*
    for (int i=0; i<nx-1; i++)
    {
        CGPoint p0, p1;
        
        double xi = _xMin + i*(_xMax - _xMin)/(nx-1);
        double yi = [_function value:cf T:xi p:p];
        p0 = [diagramView mapPoint:self X:xi Y:yi];

        double x1 = _xMin + (i+1)*(_xMax - _xMin)/(nx-1);
        double y1 = [_function value:cf T:x1 p:p];
        
        p1 = [diagramView mapPoint:self X:x1 Y:y1];

        CGContextMoveToPoint(context, p0.x, p0.y);
        CGContextAddLineToPoint(context, p1.x, p1.y);
    }
     */
    
    _xMid = 0.5*(_xMin + _xMax);
    _yMid = [[self function] value:self.coeffs T:_xMid p:p];
    
    CGContextStrokePath(context);
    
    [self drawCoordinateSystem:context];
    
}


@end
