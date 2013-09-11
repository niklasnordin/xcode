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
#define LABELCOLOR [UIColor whiteColor]
#define WARNINGCOLOR [UIColor redColor]

@interface diagramView ()
@property (nonatomic) int nBackgroundCalculation;
@property (nonatomic) BOOL initDraw;
@end

@implementation diagramView

-(void)setXMin:(float)xMin
{
    _xMin = xMin;
    if (_xMin > _xMax)
    {
        float temp = _xMax;
        _xMax = _xMin;
        _xMin = temp;
    }
    //[self setNeedsDisplay];
}

-(void)setXMax:(float)xMax
{
    _xMax = xMax;
    if (_xMin > _xMax)
    {
        float temp = _xMax;
        _xMax = _xMin;
        _xMin = temp;
    }
    //[self setNeedsDisplay];
}


-(void)setYMin:(float)y
{
    _yMin = y;
    //[self setNeedsDisplay];
}


-(void)setYMax:(float)y
{
    _yMax = y;
    //[self setNeedsDisplay];
}

-(void)setXMid:(float)x
{
    _xMid = x;
    //[self setNeedsDisplay];
}

-(void)setYMid:(float)y
{
    _yMid = y;
    //[self setNeedsDisplay];
}

-(void)fitToView:(diagramView *)view
{
    if (![self function])
    {
        NSLog(@"fitToView function == nil");
        return;
    }
    
    self.yMin = self.yValues[0];
    self.yMax = self.yValues[0];
    
    for (int i=1; i<nx; i++)
    {
        float yi = self.yValues[i];
        
        if (yi < self.yMin) self.yMin = yi;
        if (yi > self.yMax) self.yMax = yi;
    }

    float diff = fabs(self.yMax - self.yMin);

    if (diff < 1.0e-15)
    {
        self.yMin -= 1.0e+1;
        self.yMax += 1.0+1;
    }   

}

-(void)setup:(float)xmin max:(float)xmax
{
    self.contentMode = UIViewContentModeRedraw;
    _xMin = xmin;
    _xMax = xmax;
    _yValues = malloc(nx*sizeof(float));
    _xValues = malloc(nx*sizeof(float));
    _nBackgroundCalculation = 0;
    
    if (_xIsT)
    {
        NSDictionary *rangeDict = [self.dict objectForKey:@"temperatureRange"];
        NSNumber *lr = [rangeDict objectForKey:@"min"];
        NSNumber *ur = [rangeDict objectForKey:@"max"];
        _lowerRange = [lr floatValue];
        _upperRange = [ur floatValue];
    }
    else
    {
        NSDictionary *rangeDict = [self.dict objectForKey:@"pressureRange"];
        NSNumber *lr = [rangeDict objectForKey:@"min"];
        NSNumber *ur = [rangeDict objectForKey:@"max"];
        _lowerRange = [lr floatValue];
        _upperRange = [ur floatValue];
    }
    [self calculateValues];
    //[self updateLabelTexts];
    [self fitToView:self];
    _initDraw = YES;
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
    float xLow = 0.0;
    if (self.lowerRange < xLow) xLow = self.lowerRange;
    
    if (self.xMin <= xLow)
    {
        self.xMin = xLow;
    }
    
    float xm = 0.5*(self.xMin + self.xMax);
    
    if (xm <= (self.lowerRange + 1.0e-5))
    {
        float delta = self.lowerRange - xm;
        self.xMin += delta;
        self.xMax += delta;
    }
    
    if (xm >= (self.upperRange - 1.0e-5))
    {
        float delta = xm - self.upperRange;
        self.xMin -= delta;
        self.xMax -= delta;
    }

}

-(CGFloat) mapXToView:(CGFloat)x
{
    CGFloat xMap = 0.0;
    
    float xMin = self.xMin;
    float xMax = self.xMax;
    CGFloat dx = xMax - xMin;
    
    if (dx > 0)
    {
        xMap = (x - xMin)*self.bounds.size.width/dx;
    }
    
    return xMap;
}

- (CGFloat) mapYToView:(CGFloat)y
{
    CGFloat yMap = 0.0;
    float yMin = self.yMin;
    float yMax = self.yMax;
    CGFloat dy = yMax - yMin;
    
    if (dy > 0)
    {
        yMap = self.bounds.size.height - (y - yMin)*self.bounds.size.height/dy;
    }
    
    return yMap;
}

-(CGPoint) mapPoint:(CGPoint)point
{
    CGPoint p;

    p.x = [self mapXToView:point.x];
    p.y = [self mapYToView:point.y];
    
    return p;
}

- (void)pan:(UIPanGestureRecognizer *)gesture;
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
        [self updateLabelTexts];
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
            float xMin = self.xMin;
            float xMax = self.xMax;
            float yMin = self.yMin;
            float yMax = self.yMax;
            float xScale = xMax - xMin;
            float yScale = yMax - yMin;
            float newXmax = xMin + xScale/scale;
            self.xMin = xMax - xScale/scale;
            self.xMax = newXmax;
         
            float newYmax = yMin + yScale/scale;
            self.yMin = yMax - yScale/scale;
            self.yMax = newYmax;
        
            [self checkRange];

            [gesture setScale:1.0];
            [self draw];
            [self updateLabelTexts];
        }
    }
    
}

-(void)tap:(UITapGestureRecognizer *)gesture;
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self fitToView:self];
        [self updateLabelTexts];
        [self setNeedsDisplay];
    }
}

-(void)drawCoordinateSystem:(CGContextRef)context
{
    
    float xi,yi;
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
    float xMin = self.xMin;
    float xMax = self.xMax;
    //float xMid = 0.5*(xMin + xMax);
    float yMin = self.yMin;
    float yMax = self.yMax;
    //float yMid = self.yMid;
    
    float dx = fabs(xMax - xMin);
    float logDx = log10(dx);
    int ilog = logDx - 1;
    float xTickSpace = pow(10.0, ilog);
    int iStart = xMin/xTickSpace;
    int iEnd = xMax/xTickSpace + 1;
    yi = 0.0;
    for(int i=iStart; i<iEnd; i++)
    {
        xi = i*xTickSpace;
        CGPoint p0;
        p0.x = [self mapXToView:xi];
        CGContextMoveToPoint(context, p0.x, xAxisStart.y + tickWidth.y);
        CGContextAddLineToPoint(context, p0.x, xAxisStart.y - tickWidth.y);
    }

    // draw y-axis ticks
    float dy = fabs(yMax - yMin);
    int jlog = log10(dy) - 1;
    float yTickSpace = pow(10.0, jlog);
    int jStart = yMin/yTickSpace;
    int jEnd = yMax/yTickSpace + 1;
    xi = 0.0;
    for (int j=jStart; j<jEnd; j++)
    {
        yi = j*yTickSpace;
        CGPoint p0;
        p0.y = [self mapYToView:yi];
        CGContextMoveToPoint(context, yAxisStart.x - tickWidth.x, p0.y);
        CGContextAddLineToPoint(context, yAxisStart.x + tickWidth.x, p0.y);
    }

    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
}

- (void)updateLabelTexts
{
    
    float xMin = self.xMin;
    float xMax = self.xMax;
    float xMid = 0.5*(xMin + xMax);
    float yMin = self.yMin;
    float yMax = self.yMax;
    float yMid = self.yMid;
    
    // set red text color if it is out of range
    if (xMin < self.lowerRange)
    {
        self.xMinLabel.textColor = WARNINGCOLOR;
    }
    else
    {
        self.xMinLabel.textColor = LABELCOLOR;
    }
    
    if (xMax > self.upperRange)
    {
        self.xMaxLabel.textColor = WARNINGCOLOR;
    }
    else
    {
        self.xMaxLabel.textColor = LABELCOLOR;
    }
     
    if (!self.xIsT)
    {
        xMin *= 1.0e-6;
        xMax *= 1.0e-6;
        xMid *= 1.0e-6;
    }
    
    self.yMinLabel.text = [NSString stringWithFormat:@"%g", yMin];
    //[self.yMinLabel setText:[NSString stringWithFormat:@"%g", yMin]];
    
    
     self.yMaxLabel.text = [NSString stringWithFormat:@"%g", yMax];
     
     self.xMinLabel.text = [NSString stringWithFormat:@"%g", xMin];
     self.xMaxLabel.text = [NSString stringWithFormat:@"%g", xMax];
     
     self.yMidLabel.text = [NSString stringWithFormat:@"%g, %.10e", xMid, yMid];

}

-(void) calculateValues
{
    float xMin = self.xMin;
    float xMax = self.xMax;
    float dx = xMax - xMin;
    
    int nCalc = self.nBackgroundCalculation + 1;
    self.nBackgroundCalculation = nCalc;
    
    for (int i=0; i<nx; i++)
    {
        
        if (nCalc != self.nBackgroundCalculation)
        {
            break;
        }
        
        float xi = xMin + i*dx/(nx-1);
        
        float yi;
        if (self.xIsT)
        {
            yi = [self.function valueForT:xi andP:self.cpv];
        }
        else
        {
            yi = [self.function valueForT:self.cpv andP:xi];
        }
        if (!isnan(yi))
        {
            self.xValues[i] = xi;
            self.yValues[i] = yi;
        }
        [self setNeedsDisplay];
    }
    
    if (nCalc == self.nBackgroundCalculation)
    {
        self.xMid = 0.5*(xMin + xMax);
        float yMid;
    
        if (self.xIsT)
        {
            yMid = [self.function valueForT:self.xMid andP:self.cpv];
        }
        else
        {
            yMid = [self.function valueForT:self.cpv andP:self.xMid];
        }
        self.yMid = yMid;
        [self setNeedsDisplay];
    }
}

- (void) draw
{
    //[NSThread detachNewThreadSelector:@selector(calculateValues) toTarget:self withObject:nil];
    [self performSelectorInBackground:@selector(calculateValues) withObject:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.initDraw)
    {
        self.initDraw = NO;
        [self updateLabelTexts];
    }
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextBeginPath(context);

    [self drawCoordinateSystem:context];

    for (int i=1; i<nx; i++)
    {
        
        CGFloat x0 = [self mapXToView:self.xValues[i-1]];
        CGFloat x1 = [self mapXToView:self.xValues[i]];
        CGFloat y0 = [self mapYToView:self.yValues[i-1]];
        CGFloat y1 = [self mapYToView:self.yValues[i]];

        CGContextMoveToPoint(context, x0, y0);
        CGContextAddLineToPoint(context, x1, y1);
        
    }
    
    CGContextStrokePath(context);
    
    
    CGPoint pos;
    pos.x = self.bounds.origin.x + 0.5*self.bounds.size.width;
    pos.y = [self mapYToView:self.yMid];
    // make sure the text dont go out of view
    int pixelOffset = 25;
    if (pos.y < pixelOffset)
    {
        pos.y = pixelOffset;
    }
    
    CGFloat yAxisStart_y = self.bounds.origin.y + self.bounds.size.height;
    if (pos.y > yAxisStart_y - pixelOffset)
    {
        pos.y = yAxisStart_y - pixelOffset;
    }
    if(isnan(pos.y))
    {
        pos.y = self.bounds.origin.y + 0.5*self.bounds.size.height;
        NSLog(@"pos.y isnan");
    }
    self.yMidLabel.center = pos;

}


@end
