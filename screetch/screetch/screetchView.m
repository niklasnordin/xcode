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
@property CGContextRef    myDrawingContext;
@end

@implementation screetchView

-(id)init
{
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
}

- (id)initWithCoder:(NSCoder *)aDecoder
{

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

// call this from drawRect with the drawRect's current context
- (void)drawMyBitmap:(CGContextRef)context
{
    int height = self.frame.size.height;
    int width = self.frame.size.width;
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
	//CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();

    CGContextSetFillColorWithColor(_myDrawingContext, [UIColor blackColor].CGColor);
    CGContextBeginPath(_myDrawingContext);
    CGContextAddRect(_myDrawingContext, rect);
    CGContextDrawPath(_myDrawingContext, kCGPathFill);

    CGContextSetFillColorWithColor(_myDrawingContext, [UIColor whiteColor].CGColor);
    CGContextBeginPath(_myDrawingContext);

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
                CGRect r1 = CGRectMake(p.x, p.y, sizeX, sizeY);
                CGContextAddRect(_myDrawingContext, r1);
                CGContextDrawPath(_myDrawingContext, kCGPathFill);
            }
        }
    }

    CGImageRef mask = CGBitmapContextCreateImage(_myDrawingContext);
    CGImageRef maskedImage = CGImageCreateWithMask(_bgImage.CGImage, mask);

    //CGContextTranslateCTM(context, 0, height);
    //CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, maskedImage);
    CGImageRelease(mask);
    CGImageRelease(maskedImage);

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!_myDrawingContext)
    {

        CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
        int height = self.frame.size.height;
        int width = self.frame.size.width;

        _myDrawingContext = CGBitmapContextCreate(NULL, width,
                                                  height,
                                                  8, 0, space,
                                                  kCGImageAlphaNone);

        CGColorSpaceRelease(space);

    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawMyBitmap:context];
}

@end
