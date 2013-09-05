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
#define MOVEXLABELS 10.0
#define LABELCOLOR [UIColor whiteColor]

@interface xyPlotView ()

@property (nonatomic) float *xArray;
@property (nonatomic) float *yArray;
@property (nonatomic) int backgroundCalculation;

-(void)calculateValues;
-(void)drawCoordinateSystem:(CGContextRef)context;
-(void)checkRange;
-(void)fitToView;

-(CGFloat) mapXToView:(CGFloat)x;
-(CGFloat) mapYToView:(CGFloat)y;

-(CGPoint) mapPointToView:(CGPoint)point;

-(void)draw;

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

    _xArray = malloc(NX*sizeof(float));
    _yArray = malloc(NX*sizeof(float));

    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
     */

    //[NSThread detachNewThreadSelector:@selector(calculateValues) toTarget:self withObject:nil];
    [self calculateValues];
    
    _yMin = _yArray[0];
    _yMax = _yArray[0];
    
    for (int i=1; i<NX; i++)
    {
        float y = _yArray[i];
        if (y < [self yMin])
        {
            self.yMin = y;
        }
        if (y > [self yMax])
        {
            self.yMax = y;
        }
    }
    _backgroundCalculation = 0;
    
    //NSLog(@"setup::yMin=%f, yMax=%f",self.yMin, self.yMax);
}

-(void)setXMin:(float)xMin
{
    _xMin = xMin;
    [self setNeedsDisplay];
}

-(void)setXMax:(float)xMax
{
    _xMax = xMax;
    [self setNeedsDisplay];
}

-(void)setYMin:(float)yMin
{
    _yMin = yMin;
    [self setNeedsDisplay];
}

-(void)setYMax:(float)yMax
{
    _yMax = yMax;
    [self setNeedsDisplay];
}

-(void)fitToView
{
    float yMin = 1.0e+10;
    float yMax = -1.0e+10;
    
    for (int i=0; i<NX; i++)
    {
        float yi = self.yArray[i];
        
        if (yi < yMin) yMin = yi;
        if (yi > yMax) yMax = yi;
    }
    self.yMin = yMin;
    self.yMax = yMax;
    
    double diff = fabs(self.yMax - self.yMin);
    
    if (diff < 1.0e-15)
    {
        self.yMin -= 1.0e+1;
        self.yMax += 1.0+1;
    }   
    
}


// setup must be performed from the controller view after the function delegate
// have been added

-(void)awakeFromNib
{
    //[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setup];
    }
    return self;
}

-(int)Nx
{
    //return self.bounds.size.width;
    return NX;
}

-(void)draw
{
    [NSThread detachNewThreadSelector:@selector(calculateValues) toTarget:self withObject:nil];

    //[self calculateValues];
    //[self setNeedsDisplay];
}

-(void)checkRange
{
    /*
    double xLow = 0.0;
    if ([self.delegate validXMin] < self.xMin) xLow = [self.delegate validXMin];
    
    if (self.xMin <= xLow)
    {
        self.xMin = xLow;
    }
    
    double xm = 0.5*(self.xMin + self.xMax);
    
    if (xm <= ([self.delegate validXMin] + 1.0e-5))
    {
        double delta = [self.delegate validXMin] - xm;
        self.xMin += delta;
        self.xMax += delta;
    }
    
    if (xm >= ([self.delegate validXMax] - 1.0e-5))
    {
        double delta = xm - [self.delegate validXMax];
        self.xMin -= delta;
        self.xMax -= delta;
    }
*/
}

-(void)pan:(UIPanGestureRecognizer *)gesture;
{
    //NSLog(@"pan");
    CGPoint pan;
    CGPoint zero;
    zero.x = 0.0;
    zero.y = 0.0;
    
    if
    (
        (gesture.state == UIGestureRecognizerStateChanged)
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
        
        //[self checkRange];
        [gesture setTranslation:zero inView:self];
    }
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        //NSLog(@"panGesture changed");
        [self draw];

    }
    //[self draw];

}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    //NSLog(@"pinch");
    if
    (
        (gesture.state == UIGestureRecognizerStateChanged)
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
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        //NSLog(@"pinch gesture changed");
        [self draw];
    }
    //[self draw];

}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    //NSLog(@"tap");
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self fitToView];
        [self setNeedsDisplay];
    }
}

-(void)calculateValues
{
    //NSLog(@"calculate values:: bounds.width=%f",self.bounds.size.width);
    //NSLog(@"xMin=%f, xMax=%f",self.xMin,self.xMax);
    //NSLog(@"yMin=%f, yMax=%f",self.yMin,self.yMax);

    int nCalc = self.backgroundCalculation+1;
    self.backgroundCalculation = nCalc;
    
    CGFloat dx = self.xMax - self.xMin;

    for (int i=0; i<NX; i++)
    {
        if (self.backgroundCalculation != nCalc)
        {
            //NSLog(@"break");
            break;
        }
        CGFloat xv = self.xMin + i*dx/(NX-1);
        CGFloat yFloat = [self.dataSource yForX:xv];
        
        self.xArray[i] = xv;
        self.yArray[i] = yFloat;
    }

    [self setNeedsDisplay];
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
    
    // draw x-axis ticks
    CGFloat dx = self.xMax - self.xMin;
    CGFloat logDx = log10(dx);
    int ilog = logDx - 1;
    double xTickSpace = pow(10.0, ilog);
    int iStart = self.xMin/xTickSpace;
    int iEnd = self.xMax/xTickSpace + 1;

    p.y = 0.0;
    for(int i=iStart; i<iEnd; i++)
    {
        CGFloat x = i*xTickSpace;
        CGFloat px = [self mapXToView:x];
        
        CGContextMoveToPoint(context, px, xAxisStart.y + TICKWIDTH);
        CGContextAddLineToPoint(context, px, xAxisStart.y - TICKWIDTH);
    }
    
    // draw y-axis ticks
    double dy = self.yMax - self.yMin;
    int jlog = log10(dy) - 1;
    double yTickSpace = pow(10.0, jlog);
    int jStart = self.yMin/yTickSpace;
    int jEnd = self.yMax/yTickSpace + 1;

    for (int j=jStart; j<jEnd; j++)
    {
        CGFloat y = j*yTickSpace;
        CGFloat py = [self mapYToView:y];
        CGContextMoveToPoint(context, yAxisStart.x - TICKWIDTH, py);
        CGContextAddLineToPoint(context, yAxisStart.x + TICKWIDTH, py);
        
    }
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
    // set red text color if it is out of range
    self.yMinLabel.text = [NSString stringWithFormat:@"%g", self.yMin];
    self.yMinLabel.textColor = LABELCOLOR;

    self.yMaxLabel.text = [NSString stringWithFormat:@"%g", self.yMax];
    self.yMaxLabel.textColor = LABELCOLOR;

    self.xMinLabel.text = [NSString stringWithFormat:@"%g", self.xMin];
    
    if (self.xMin < [self.delegate validXMin])
    {
        self.xMinLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.xMinLabel.textColor = LABELCOLOR;
    }
    
    self.xMaxLabel.text = [NSString stringWithFormat:@"%g", self.xMax];
    
    if (self.xMax > [self.delegate validXMax])
    {
        self.xMaxLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.xMaxLabel.textColor = LABELCOLOR;
    }
    
    CGPoint posXMin =  self.xMinLabel.center;
    CGPoint posXMax =  self.xMaxLabel.center;
    
    posXMin.y = 0.5*self.bounds.size.height + MOVEXLABELS;
    posXMax.y = 0.5*self.bounds.size.height + MOVEXLABELS;
    
    self.xMinLabel.center = posXMin;
    self.xMaxLabel.center = posXMax;

    float xMid = 0.5*(self.xMin + self.xMax);
    float yMid = [self.dataSource yForX:xMid];
    
    self.midLabel.text = [NSString stringWithFormat:@"%g, %.10e", xMid, yMid];
    
    float pos_x = [self mapXToView:xMid];
    float pos_y = [self mapYToView:yMid];

    // make sure the text dont go out of view
    int pixelOffset = 25;
    if (pos_y < pixelOffset)
    {
        pos_y = pixelOffset;
    }
    
    if (pos_y > yAxisStart.y - pixelOffset)
    {
        pos_y = yAxisStart.y - pixelOffset;
    }
    if(isnan(pos_y))
    {
        pos_y = xAxisStart.y;
    }
    CGPoint pos;
    pos.x = pos_x;
    pos.y = pos_y;
    
    self.midLabel.center = pos;
    self.midLabel.textColor = [UIColor yellowColor];

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

-(CGPoint) mapPointToView:(CGPoint)point
{
    CGPoint p;
    
    p.x = [self mapXToView:point.x];
    p.y = [self mapYToView:point.y];
    
    return p;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect: xArray count = %d",[self.xArray count]);
    //NSLog(@"drawRect: yArray count = %d",[self.yArray count]);
    //NSLog(@"drawRect::width=%f", rect.size.width);
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateSystem:context];
    
    for (int i=1; i<NX; i++)
    {
        CGFloat x0 = [self mapXToView:self.xArray[i-1]];
        CGFloat x1 = [self mapXToView:self.xArray[i]];
        CGFloat y0 = [self mapYToView:self.yArray[i-1]];
        CGFloat y1 = [self mapYToView:self.yArray[i]];
        //NSLog(@"i=%d, x=%f, y=%f", i, x1, y1);
        CGContextMoveToPoint(context, x0, y0);
        CGContextAddLineToPoint(context, x1, y1);
    }
    
    CGContextStrokePath(context);

}


- (void) didRotate:(NSNotification *)notification
{
    //NSLog(@"didRotate");
    //NSLog(@"width = %d",[self Nx]);
    /*
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft)
    {
        NSLog(@"Landscape Left!");
    }*/
    NSLog(@"didRotate notification");
    //[self clearArrays];

}

//-(void)viewDidLoad

@end
