//
//  xyPlotView.m
//  xyPlotter
//
//  Created by Niklas Nordin on 2013-03-01.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "xyPlotView.h"

//#define NX 320 // 640
#define TICKWIDTH 5.0

@interface xyPlotView ()
-(void)startCalculation;
-(void)calculateValues;
-(void)drawCoordinateSystem:(CGContextRef)context;

-(CGFloat) mapXToView:(CGFloat)x;
-(CGFloat) mapYToView:(CGFloat)y;

-(CGPoint) mapPointToView:(CGPoint)point;
-(CGPoint) mapViewToPoint:(CGPoint)point;

@property (nonatomic) int nPlottedValues;
@property (strong,nonatomic) NSMutableArray *yArray;
@property (strong,nonatomic) NSMutableArray *valueNeedsUpdate;

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

    self.nPlottedValues = 0;
    _xArray = [[NSMutableArray alloc] init];
    _yArray = [[NSMutableArray alloc] init];
    _valueNeedsUpdate = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

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

-(int)Nx
{
    return self.bounds.size.width;
}

-(void)setNPlottedValues:(int)nPlottedValues
{
    //NSLog(@"setNeedsDisplay");
    _nPlottedValues = nPlottedValues;
    [self setNeedsDisplay];
}

-(void)pan:(UIPanGestureRecognizer *)gesture;
{
    NSLog(@"pan");
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"pinch");
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tap");
}

-(void)startCalculation
{
    if (self.nPlottedValues == 0)
    {
        CGFloat xMin = [self.delegate xMin];
        CGFloat yFloat = [self.dataSource yForX:xMin];
        
        NSNumber *x = [[NSNumber alloc] initWithFloat:xMin];
        NSNumber *y = [[NSNumber alloc] initWithFloat:yFloat];
        NSNumber *c = [[NSNumber alloc] initWithBool:NO];
        
        if ([self.xArray count] > 0)
        {
            [self.xArray replaceObjectAtIndex:0 withObject:x];
            [self.yArray replaceObjectAtIndex:0 withObject:y];
            [self.valueNeedsUpdate replaceObjectAtIndex:0 withObject:c];
            
        }
        else
        {
            [self.xArray addObject:x];
            [self.yArray addObject:y];
            [self.valueNeedsUpdate addObject:c];
        }
        self.nPlottedValues++;
    }
}

-(void)calculateValues
{
    
    int nx = [self Nx];
    int np = self.nPlottedValues;
    
    //NSLog(@"np = %d, nx= %d",np, nx);
    
    if (np == 0)
    {
        [self startCalculation];
    }
    
    if (np < nx)
    {

        CGFloat dx = [self.delegate xMax] - [self.delegate xMin];
        CGFloat xv = [self.delegate xMin] + np*dx/(nx-1);
        CGFloat yFloat = [self.dataSource yForX:xv];
        
        NSNumber *x = [[NSNumber alloc] initWithFloat:xv];
        NSNumber *y = [[NSNumber alloc] initWithFloat:yFloat];
        NSNumber *c = [[NSNumber alloc] initWithBool:NO];

        //NSLog(@"1. np = %d, count=%d",np, [self.xArray count]);
        if ([self.xArray count] > np)
        {
            [self.xArray replaceObjectAtIndex:np withObject:x];
            [self.yArray replaceObjectAtIndex:np withObject:y];
            [self.valueNeedsUpdate replaceObjectAtIndex:np withObject:c];
        }
        else
        {
            [self.xArray addObject:x];
            [self.yArray addObject:y];
            [self.valueNeedsUpdate addObject:c];
        }
        //NSLog(@"2. np = %d, count=%d",np, [self.xArray count]);
        self.nPlottedValues = np+1;
    }
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
        CGFloat x = i*xTickSpace;
        CGFloat px = [self mapXToView:x];
        
        CGContextMoveToPoint(context, px, xAxisStart.y + TICKWIDTH);
        CGContextAddLineToPoint(context, px, xAxisStart.y - TICKWIDTH);
    }
    
    // draw y-axis ticks
    double dy = yMax - yMin;
    int jlog = log10(dy) - 1;
    double yTickSpace = pow(10.0, jlog);
    int jStart = yMin/yTickSpace;
    int jEnd = yMax/yTickSpace + 1;

    for (int j=jStart; j<jEnd; j++)
    {
        CGFloat y = j*yTickSpace;
        CGFloat py = [self mapYToView:y];
        CGContextMoveToPoint(context, yAxisStart.x - TICKWIDTH, py);
        CGContextAddLineToPoint(context, yAxisStart.x + TICKWIDTH, py);
        
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

-(CGFloat) mapXToView:(CGFloat)x
{
    CGFloat xMap = 0.0;
    CGFloat xMin = [[self delegate] xMin];
    CGFloat xMax = [[self delegate] xMax];
    
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
    CGFloat yMin = [[self delegate] yMin];
    CGFloat yMax = [[self delegate] yMax];
    
    CGFloat dy = yMax - yMin;
    
    if (dy > 0)
    {
        yMap = self.bounds.size.height - (y - yMin)*self.bounds.size.height/dy;
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

-(CGPoint)mapViewToPoint:(CGPoint)point
{
    CGPoint p;
    
    return p;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    [self calculateValues];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateSystem:context];
    
    for (int i=1; i<[self Nx]; i++)
    {
        if ([self.xArray count] < [self Nx])
        {
            [self calculateValues];
        }
        
        CGFloat x0 = [self mapXToView:[[self.xArray objectAtIndex:i-1] floatValue]];
        CGFloat x1 = [self mapXToView:[[self.xArray objectAtIndex:i] floatValue]];
        CGFloat y0 = [self mapYToView:[[self.yArray objectAtIndex:i-1] floatValue]];
        CGFloat y1 = [self mapYToView:[[self.yArray objectAtIndex:i] floatValue]];
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
    self.nPlottedValues = 0;
    [self.xArray removeAllObjects];
    [self.yArray removeAllObjects];
    [self.valueNeedsUpdate removeAllObjects];

}

//-(void)viewDidLoad

@end
