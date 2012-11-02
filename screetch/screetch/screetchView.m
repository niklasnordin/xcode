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
@property CGRect          myBitmapRect;

@end

@implementation screetchView

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
        //pan = [gesture translationInView:self];
        pan = [gesture locationInView:self];
        NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",pan.x, pan.y];
        //UILabel *display = ((screetchViewController *)_delegate).display;
        //[display setText:text];
        [_delegate setDisplayWithText:text];
        [self drawRedDotAtPoint:pan inContext:_myDrawingContext];
        [self setNeedsDisplay];
        [gesture setTranslation:zero inView:self];

    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self makeMyBitMapContextWithRect:frame];
    }
    return self;
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


- (void)drawRedDotAtPoint:(CGPoint)pt inContext:(CGContextRef)context
{
    float x = pt.x;
    float y = pt.y;
    float dotSize = 5.0;
    
    CGRect r1 = CGRectMake(x,y, dotSize,dotSize);
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
    // draw a red dot in this context
    CGContextFillRect(context, r1);
}

// call this from drawRect with the drawRect's current context
- (void)drawMyBitmap:(CGContextRef)context
{
    //CGImageRef myImage = CGBitmapContextCreateImage(_myDrawingContext);
    CGImageRef myImage = CGBitmapContextCreateImage(context);
    CGContextDrawImage(context, _myBitmapRect, myImage  );
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
    p.x = 10.0;
    p.y = 10.0;
    [self drawRedDotAtPoint:p inContext:_myDrawingContext];
    [self drawMyBitmap:_myDrawingContext];
}

@end
