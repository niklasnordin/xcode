//
//  diagramView.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-21.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "diagramView.h"
#import "functions.h"

static NSUInteger nx = 320;//640;

@interface diagramView ()
@property (nonatomic) int nBackgroundCalculation;
@end

@implementation diagramView

-(void)setXMin:(double)xMin
{
    _xMin = xMin;
    if (_xMin > _xMax)
    {
        double temp = _xMax;
        _xMax = _xMin;
        _xMin = temp;
    }
    [self setNeedsDisplay];
}

-(void)setXMax:(double)xMax
{
    _xMax = xMax;
    if (_xMin > _xMax)
    {
        double temp = _xMax;
        _xMax = _xMin;
        _xMin = temp;
    }
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
    
    _yMin = 1.0e+50;
    _yMax = -1.0e+50;
    
    for (int i=0; i<nx; i++) 
    {
        double yi = self.yValues[i];
        
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
    _yValues = malloc(nx*sizeof(double));
    _xValues = malloc(nx*sizeof(double));
    _nBackgroundCalculation = 0;
    
    if (_xIsT)
    {
        NSDictionary *rangeDict = [self.dict objectForKey:@"temperatureRange"];
        NSNumber *lr = [rangeDict objectForKey:@"min"];
        NSNumber *ur = [rangeDict objectForKey:@"max"];
        _lowerRange = [lr doubleValue];
        _upperRange = [ur doubleValue];
    }
    else
    {
        NSDictionary *rangeDict = [self.dict objectForKey:@"pressureRange"];
        NSNumber *lr = [rangeDict objectForKey:@"min"];
        NSNumber *ur = [rangeDict objectForKey:@"max"];
        _lowerRange = [lr doubleValue];
        _upperRange = [ur doubleValue];
    }
    [self calculateValues];
    [self fitToView:self];
}

- (void)dealloc
{
    free(_yValues);
    free(_xValues);
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


-(CGFloat) mapXToView:(CGFloat)x
{
    CGFloat xMap = 0.0;
    
    CGFloat dx = self.xMax - self.xMin;
    
    if (dx > 0)
    {
        xMap = (x - self.xMin)*self.bounds.size.width/dx;
    }
    
    return xMap;
}

- (CGFloat) mapYToView:(CGFloat)y
{
    CGFloat yMap = 0.0;
    
    CGFloat dy = self.yMax - self.yMin;
    
    if (dy > 0)
    {
        yMap = self.bounds.size.height - (y - self.yMin)*self.bounds.size.height/dy;
    }
    
    return yMap;
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
        [self draw];
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
            [self draw]; 
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
}

-(void) calculateValues
{
    double xMin = self.xMin;
    double xMax = self.xMax;
    double dx = xMax - xMin;
    
    int nCalc = self.nBackgroundCalculation + 1;
    self.nBackgroundCalculation = nCalc;
    
    for (int i=0; i<nx; i++)
    {
        if (nCalc != self.nBackgroundCalculation)
        {
            break;
        }
        
        double xi = xMin + i*dx/(nx-1);
        self.xValues[i] = xi;
        
        if (self.xIsT)
        {
            self.yValues[i] = [self.function valueForT:xi andP:self.cpv];
        }
        else
        {
            self.yValues[i] = [self.function valueForT:self.cpv andP:xi];
        }
        [self setNeedsDisplay];
    }
}

- (void) draw
{
    [NSThread detachNewThreadSelector:@selector(calculateValues) toTarget:self withObject:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);

    for (int i=1; i<nx; i++)
    {
        
        CGFloat x0 = [self mapXToView:self.xValues[i-1]];
        CGFloat x1 = [self mapXToView:self.xValues[i]];
        CGFloat y0 = [self mapYToView:self.yValues[i-1]];
        CGFloat y1 = [self mapYToView:self.yValues[i]];

        CGContextMoveToPoint(context, x0, y0);
        CGContextAddLineToPoint(context, x1, y1);

    }
    
    self.xMid = 0.5*(self.xMin + self.xMax);
    if (self.xIsT)
    {
        self.yMid = [self.function valueForT:self.xMid andP:self.cpv];
    }
    else
    {
        self.yMid = [self.function valueForT:self.cpv andP:self.xMid];
    }
    
    CGContextStrokePath(context);
    
    [self drawCoordinateSystem:context];
    
}


@end
