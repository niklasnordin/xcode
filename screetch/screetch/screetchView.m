//
//  screetchView.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-31.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchView.h"

@interface screetchView ()

@property unsigned char   *myBitmap;
@property CGContextRef    myDrawingContext;
@property CGRect          myBitmapRect;

@end

@implementation screetchView

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
        
        _myDrawingContext = CGBitmapContextCreate(_myBitmap,
                                                 w, h, bitsPerPixel, rowBytes,
                                                 colorspace,
                                                 kCGImageAlphaPremultipliedFirst );
        _myBitmapRect = r;
    }
    CGColorSpaceRelease(colorspace);
}


- (void)drawRedDotInMyContextAtPoint:(CGPoint)pt
{
    float x = pt.x;
    float y = pt.y;
    float dotSize = 1.0;
    
    CGRect r1 = CGRectMake(x,y, dotSize,dotSize);
    CGContextSetRGBFillColor(_myDrawingContext, 1.0, 0, 0, 1.0);
    // draw a red dot in this context
    CGContextFillRect(_myDrawingContext, r1);
}

// call this from drawRect with the drawRect's current context
- (void)drawMyBitmap:(CGContextRef)context
{
    CGImageRef myImage = CGBitmapContextCreateImage(_myDrawingContext);
    CGContextDrawImage(context, _myBitmapRect, myImage  );
    CGImageRelease(myImage);
}

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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [self drawMyBitmap:currentContext];
}

@end
