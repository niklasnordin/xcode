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
@property CGRect          myBitmapRect;

@property CGRect          plotRect;

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
        [self initMatrix];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"awakeFromNib w=%f",self.frame.size.width);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder = %@",[aDecoder decodeObjectForKey:@"NSFrame"]);
    if (self = [super initWithCoder:aDecoder])
    {
        [self initMatrix];
        _bgImage = [UIImage imageNamed:@"pig_300.jpg"];
        _bgImageRef = _bgImage.CGImage;
    }
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
                    //[self setNeedsDisplay];
                    CGPoint p;
                    p.x = nx*self.frame.size.width/widthDivisions;
                    p.y = ny*self.frame.size.height/heightDivisions;
                    float sizeX = self.frame.size.width/widthDivisions;
                    float sizeY = self.frame.size.height/heightDivisions;
                    _plotRect = CGRectMake(p.x, p.y, sizeX, sizeY);
                    //NSLog(@"x=%g, y=%g",p.x,p.y);
                    //[self drawRedDotAtPoint:p inContext:_myDrawingContext withX:sizeX andY:sizeY];
                    [self setNeedsDisplayInRect:_plotRect];
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

- (void)drawRedDotAtPoint:(CGPoint)pt inContext:(CGContextRef)context withX:(float)sizeX andY:(float)sizeY
{
    float x = pt.x;
    float y = pt.y;
    
    CGRect r1 = CGRectMake(x,y, sizeX, sizeY);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    // draw a red dot in this context
    CGContextFillRect(context, r1);
}

// call this from drawRect with the drawRect's current context
- (void)drawMyBitmap:(CGContextRef)context
{

    CGImageRef maskImage = CGImageMaskCreate(
                                             CGImageGetWidth(_bgImageRef),
                                             CGImageGetHeight(_bgImageRef),
                                             CGImageGetBitsPerComponent(_bgImageRef),
                                             CGImageGetBitsPerPixel(_bgImageRef),
                                             CGImageGetBytesPerRow(_bgImageRef),
                                             CGImageGetDataProvider(_bgImageRef),
                                             nil,
                                             NO
                                             );
    
    CGRect rect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);

    /*
    CGImageRef myImage = CGBitmapContextCreateImage(context);
    CGContextTranslateCTM(context, 0, _bgImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, _bgImageRef);
    CGImageRelease(myImage);
     */

    CGImageRef masked = CGImageCreateWithMask(_bgImageRef, maskImage);
    CGContextTranslateCTM(context, 0, _bgImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, masked);
    CGImageRelease(masked);

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!_myDrawingContext)
    {
        //NSLog(@"frame: w=%g, h=%g",self.frame.size.width,self.frame.size.height);
        //NSLog(@"frame:  x=%g, y=%g",self.frame.origin.x, self.frame.origin.y);
        CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
        _myDrawingContext = CGBitmapContextCreate(NULL, _bgView.frame.size.width, _bgView.frame.size.height, 8, 0, space, kCGImageAlphaNone);
        
        CGImageRef bgRef = _bgImage.CGImage;
        _maskedMapImage = CGImageMaskCreate(
                                                 CGImageGetWidth(bgRef),
                                                 CGImageGetHeight(bgRef),
                                                 CGImageGetBitsPerComponent(bgRef),
                                                 CGImageGetBitsPerPixel(bgRef),
                                                 CGImageGetBytesPerRow(bgRef),
                                                 CGImageGetDataProvider(bgRef),
                                                 nil,
                                                 NO
                                            );
        CGColorSpaceRelease(space);
    }

    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
    /*
    CGPoint p;
    p.x = _plotRect.origin.x;
    p.y = _plotRect.origin.y;
    float sizeX = _plotRect.size.width;
    float sizeY = _plotRect.size.height;
    
    [self drawRedDotAtPoint:p inContext:_myDrawingContext withX:sizeX andY:sizeY];
*/
    [self drawMyBitmap:context];
}

@end
