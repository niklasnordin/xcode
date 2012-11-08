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
    NSLog(@"init screetchView");
    self = [super init];
    [self initMatrix];
    return self;
}

-(void)initMatrix
{
    NSLog(@"initMatrix");
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
    NSLog(@"init with frame");
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
    NSLog(@"awake from NIB");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"init with coder");

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
    NSLog(@"dealloc: free pixelMatrix");
    free(_pixelMatrix);
}

-(void)update
{
    [_delegate setScoreWithInt:[self score]];
    [self setNeedsDisplay];  
}

-(bool)clearPixelMatrixAtX:(int)nx andY:(int)ny
{
    bool updateNeeded = false;
    int rad = 4;
    for (int i=nx-rad; i<nx+rad+1; i++)
    {
        for (int j=ny-rad; j<ny+rad+1; j++)
        {
            int dist2 = (i-nx)*(i-nx) + (j-ny)*(j-ny);
            if (dist2 < rad*rad)
            {
                if ( (i >= 0) && (i < widthDivisions) )
                {
                    if ( (j >= 0) && (j < heightDivisions))
                    {
                        int n = i + j*heightDivisions;
                        if (!_pixelMatrix[n])
                        {
                            _pixelMatrix[n] = true;
                            updateNeeded = true;
                        }
                    }
                }
            }
        }
    }
    return updateNeeded;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint tap = [touch locationInView:self];
    NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",tap.x, tap.y];
    [_delegate setDisplayWithText:text];
    int nx = widthDivisions*tap.x/self.frame.size.width;
    int ny = heightDivisions*tap.y/self.frame.size.height;
    if ([self clearPixelMatrixAtX:nx andY:ny])
    {
        [self update];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint tap = [touch locationInView:self];
    NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",tap.x, tap.y];
    [_delegate setDisplayWithText:text];
    int nx = widthDivisions*tap.x/self.frame.size.width;
    int ny = heightDivisions*tap.y/self.frame.size.height;
    if ([self clearPixelMatrixAtX:nx andY:ny])
    {
        [self update];
    }
}

/*
-(void)tap:(UIPanGestureRecognizer *)gesture
{

    if  (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint tap = [gesture locationInView:self];
        NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",tap.x, tap.y];
        [_delegate setDisplayWithText:text];
        int nx = widthDivisions*tap.x/self.frame.size.width;
        int ny = heightDivisions*tap.y/self.frame.size.height;
        if ([self clearPixelMatrixAtX:nx andY:ny])
        {
            [self update];
        }

    }

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
        if ([self clearPixelMatrixAtX:nx andY:ny])
        {
            [self update];
        }
        
        [gesture setTranslation:zero inView:self];
        
    }
}
*/
- (int)score
{
    int sum = heightDivisions*widthDivisions/2;
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

- (int)pixelsLeft
{
    int sum = 0;
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            int n = i + j*heightDivisions;
            if (!_pixelMatrix[n])
            {
                sum++;
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

    CGContextSetFillColorWithColor(_myDrawingContext, [UIColor blackColor].CGColor);
    CGContextBeginPath(_myDrawingContext);
    CGContextAddRect(_myDrawingContext, rect);
    CGContextDrawPath(_myDrawingContext, kCGPathFill);

    CGContextSetFillColorWithColor(_myDrawingContext, [UIColor whiteColor].CGColor);
    CGContextBeginPath(_myDrawingContext);

    CGPoint p;
    float sizeX = width/widthDivisions;
    float sizeY = height/heightDivisions;
    
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            int n = i + j*heightDivisions;
            if (_pixelMatrix[n])
            {
                //p.x = (widthDivisions - 1 - i)*width/widthDivisions;
                p.x = i*width/widthDivisions;
                p.y = (heightDivisions - 1 - j)*height/heightDivisions;
                CGRect r1 = CGRectMake(p.x, p.y, sizeX, sizeY);
                CGContextAddRect(_myDrawingContext, r1);
                CGContextDrawPath(_myDrawingContext, kCGPathFill);
            }
        }
    }

    CGImageRef mask = CGBitmapContextCreateImage(_myDrawingContext);
    CGImageRef maskedImage = CGImageCreateWithMask(_bgImageRef, mask);
    
    UIImage *image = [UIImage imageWithCGImage:maskedImage scale:1.0 orientation:UIImageOrientationUp];
    [self setBgImage:image];
    //CGContextDrawImage(context, rect, maskedImage);
    [image drawInRect:rect];

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
        [self update];

        CGColorSpaceRelease(space);

    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawMyBitmap:context];
}

- (void)clearPicture
{
    int pixelsLeft = [self pixelsLeft];
    while (pixelsLeft > 0)
    {
        int remove = random()%pixelsLeft;
        int counter = 0;
        for (int i=0; i<widthDivisions; i++)
        {
            for (int j=0; j<heightDivisions; j++)
            {
                int n = i + j*heightDivisions;
                if (!_pixelMatrix[n])
                {
                    if (counter == remove)
                    {
                        _pixelMatrix[n] = true;

                        [self setNeedsDisplay];

                        usleep(1);
                        i=widthDivisions;
                        j=heightDivisions;
                    }
                    counter++;
                }
            }
        }

        pixelsLeft = [self pixelsLeft];
        //NSLog(@"rem=%d, total=%d",remove,pixelsLeft);
    }
}
@end
