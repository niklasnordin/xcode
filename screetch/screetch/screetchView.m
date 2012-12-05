//
//  screetchView.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-31.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchView.h"
#import "screetchViewController.h"

static float windowWidth = 300.0;
static float windowHeight = 300.0;
static int widthDivisions = 60;
static int heightDivisions = 60;

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
        //_bgImage = [UIImage imageNamed:@"pig_300.jpg"];
        //_bgImageRef = _bgImage.CGImage;
    }
    return self;
}

-(void)dealloc
{
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
    int rad = 3;
    for (int i=nx-rad; i<nx+rad+1; i++)
    {
        for (int j=ny-rad; j<ny+rad+1; j++)
        {
            int dist2 = (i-nx)*(i-nx) + (j-ny)*(j-ny);
            if (dist2 < (rad-0.5)*(rad-0.5))
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

-(UIImage *)calculateImage:(CGRect)rect
{

    CGContextSetFillColorWithColor(_myDrawingContext, [[UIColor blackColor] CGColor]);
    CGContextBeginPath(_myDrawingContext);
    CGContextAddRect(_myDrawingContext, rect);
    CGContextDrawPath(_myDrawingContext, kCGPathFill);
    
    CGContextSetFillColorWithColor(_myDrawingContext, [[UIColor whiteColor] CGColor]);
    CGContextBeginPath(_myDrawingContext);
    
    CGPoint p;
    float sizeX = rect.size.width/widthDivisions;
    float sizeY = rect.size.height/heightDivisions;
    
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            int n = i + j*heightDivisions;
            if (_pixelMatrix[n])
            {
                //p.x = (widthDivisions - 1 - i)*width/widthDivisions;
                p.x = i*rect.size.width/widthDivisions;
                p.y = (heightDivisions - 1 - j)*rect.size.height/heightDivisions;
                CGRect r1 = CGRectMake(p.x, p.y, sizeX, sizeY);
                CGContextAddRect(_myDrawingContext, r1);
                CGContextDrawPath(_myDrawingContext, kCGPathFill);
            }
        }
    }
    
    CGImageRef mask = CGBitmapContextCreateImage(_myDrawingContext);
    CGImageRef maskedImage = CGImageCreateWithMask(_bgImageRef, mask);

    UIImage *image = [UIImage imageWithCGImage:maskedImage scale:1.0 orientation:UIImageOrientationUp];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImage);

    return image;
}

// call this from drawRect with the drawRect's current context
- (void)drawMyBitmap:(CGContextRef)context
{
    CGRect rect = self.bounds;
    UIImage *image = [self calculateImage:rect];
    [image drawInRect:rect];
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

- (void)clearAndAnimatePicture
{
    int frames = 6;
    CGRect frame = self.bounds;
    int pixelsLeft = [self pixelsLeft];
    int countPerFrame = pixelsLeft/frames;
    NSMutableArray *animationImages = [[NSMutableArray alloc] init];
    int cpt = 0;
    while (pixelsLeft > 0)
    {
        int remove = random()%pixelsLeft;
        int counter = 0;
        cpt++;
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

                        i=widthDivisions;
                        j=heightDivisions;
                    }
                    counter++;
                }
            }
        }
        if (cpt > countPerFrame)
        {
            [animationImages addObject:[self calculateImage:frame]];
            cpt = 0;
        }
        pixelsLeft = [self pixelsLeft];

    }
    
    _bgView = [[UIImageView alloc] initWithFrame:frame];
    _bgView.animationImages = animationImages;
    _bgView.animationRepeatCount = 1;
    _bgView.animationDuration = 0.5;
    [_bgView setImage:_bgImage];
    [self addSubview:_bgView];
    //[self sendSubviewToBack:_bgView];
    [_bgView startAnimating];

}

@end
