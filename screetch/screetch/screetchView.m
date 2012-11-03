//
//  screetchView.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-31.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchView.h"
#import "screetchViewController.h"

@interface screetchView ()

@property unsigned char   *myBitmap;
@property CGContextRef    myDrawingContext;
@property CGImageRef      maskedMapImage;
@property CGImageRef      bgImageRef;
@property CGRect          myBitmapRect;

@end

@implementation screetchView

-(id)init
{
    NSLog(@"init:");
    self = [super init];
    [self initMatrix];
    return self;
}

-(void)initMatrix
{
    int matrixSize = heightDivisions*widthDivisions;
    _pixelMatrix = malloc(matrixSize*sizeof(bool));
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            int index = i + j*heightDivisions;
            _pixelMatrix[index] = false;
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"hello");

    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self makeMyBitMapContextWithRect:frame];
        [self initMatrix];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    [self initMatrix];
    //_bgImage = [UIImage imageNamed:@"250px-Cornflakes_in_bowl.jpg"];
    _bgImage = [UIImage imageNamed:@"pig_300.jpg"];

    //_bgView = [[UIImageView alloc] initWithImage:_bgImage];
    _bgView = [[UIImageView alloc] initWithFrame:self.frame];
    [_bgView setImage:_bgImage];
    _bgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_bgView];
    [self sendSubviewToBack:_bgView];

    _bgImageRef = _bgImage.CGImage;
    return self;
}

-(void)dealloc
{
    free(_pixelMatrix);
}


-(void)pan:(UIPanGestureRecognizer *)gesture
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
        pan = [gesture locationInView:self];
        NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",pan.x, pan.y];
        [_delegate setDisplayWithText:text];
        int nx = widthDivisions*pan.x/self.frame.size.width;
        int ny = heightDivisions*pan.y/self.frame.size.height;
        if ( (nx >= 0) && (nx < widthDivisions))
        {
            if ( (ny >= 0) && (ny < heightDivisions))
            {
                int n = nx + ny*heightDivisions;
                if (!_pixelMatrix[n])
                {
                    _pixelMatrix[n] = true;
                    [self setNeedsDisplay];
                }
            }
        }
        
        [gesture setTranslation:zero inView:self];
        
    }
}

-(int)score
{
    int sum = heightDivisions*widthDivisions;
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            int n = i + j*heightDivisions;
            if (_pixelMatrix[n])
            {
                sum--;
            }
        }
    }
    return sum;
}

- (void)makeMyBitMapContextWithRect:(CGRect)r
{
    
    int     h = r.size.height;
    int     w = r.size.width;
    int     bitsPerPixel = 8;
    int     rowBytes = 4 * w;       // for 32-bit ARGB format
    int     myBitmapSize = rowBytes * h;     // memory needed
    
    _myBitmap  = (unsigned char *)malloc(myBitmapSize);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    if (_myBitmap != NULL)
    {
        // clear bitmap to white
        memset(_myBitmap, 0xff, myBitmapSize);
        /*
        _myDrawingContext = CGBitmapContextCreate(_myBitmap,
                                                 w, h, bitsPerPixel, rowBytes,
                                                 colorspace,
                                                 kCGImageAlphaPremultipliedFirst );
         */
        _myBitmapRect = r;
    }
    CGColorSpaceRelease(colorspace);
}


- (void)drawRedDotAtPoint:(CGPoint)pt inContext:(CGContextRef)context withX:(float)sizeX andY:(float)sizeY
{
    float x = pt.x;
    float y = pt.y;
    
    CGRect r1 = CGRectMake(x,y, sizeX, sizeY);
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
    // draw a red dot in this context
    CGContextFillRect(context, r1);
}

// call this from drawRect with the drawRect's current context
- (void)drawMyBitmap:(CGContextRef)context
{
    int     h = self.frame.size.height;
    int     w = self.frame.size.width;
    int     bitsPerPixel = 2;
    int bitsPerComponent = 2;
    int     rowBytes = 4 * w;       // for 32-bit ARGB format

    //CGImageRef maskImage = CGImageMaskCreate(w, h, bitsPerComponent, bitsPerPixel, rowBytes, nil, nil, NO);
    
    CGImageRef myImage = CGBitmapContextCreateImage(context);
    CGContextDrawImage(context, _myBitmapRect, myImage);
    CGImageRelease(myImage);
}
/*
- (void)useMyBitmapContextAsViewLayer
{
    CGImageRef myImage = CGBitmapContextCreateImage(_myDrawingContext);
    
    // use the following only inside a UIView's implementation
    UIView *myView = self;
    CALayer *myLayer = [myView layer];
    //[ myLayer setContents : (id)myImage ];
    //[ myLayer setContents : myImage ];
    
    CGImageRelease(myImage);
    //  notify OS that a drawing layer has changed
    //  [ CATransaction flush ];
}
*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _myDrawingContext = UIGraphicsGetCurrentContext();
    CGPoint p;
    float sizeX = self.frame.size.width/widthDivisions;
    float sizeY = self.frame.size.height/heightDivisions;
    
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            int n = i + j*heightDivisions;
            if (_pixelMatrix[n])
            {
                p.x = i*self.frame.size.width/widthDivisions;
                p.y = j*self.frame.size.height/heightDivisions;
                //NSLog(@"x=%g, y=%g",p.x,p.y);
                [self drawRedDotAtPoint:p inContext:_myDrawingContext withX:sizeX andY:sizeY];
            }
        }
    }
    [self drawMyBitmap:_myDrawingContext];
}

@end
