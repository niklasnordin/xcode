//
//  blockingView.m
//  scratchy
//
//  Created by Niklas Nordin on 2013-08-11.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "blockingView.h"

static int widthDivisions = 100;
static int heightDivisions = 100;


@interface blockingView ()
@property (nonatomic) BOOL firstDraw;
@property (nonatomic) CGFloat dx, dy;

@end

@implementation blockingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        NSLog(@"blockingView::initWithFrame");
    }
    return self;
}

- (int)matrixIndexfromI:(int)i andJ:(int)j
{
    return i + j*heightDivisions;
}


- (void)resetVisibleMatrix
{
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            self.visible[[self matrixIndexfromI:i andJ:j]] = YES;
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSLog(@"init with coder");
        _visible = malloc(widthDivisions*heightDivisions*sizeof(bool));
        [self resetVisibleMatrix];
        _firstDraw = YES;

    }
    
    return self;
}

// must be called from superview when view has appeared
- (void)setup
{
    self.dx = (self.bounds.size.width)/widthDivisions + 0.6;
    self.dy = (self.bounds.size.height)/heightDivisions + 0.6;
}

- (void)dealloc
{
    free(_visible);
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"blockingView::init");
    }
    return self;
}

- (int)Nx:(CGPoint)p
{
    int nx = (int)(widthDivisions*p.x/self.bounds.size.width);
    if (nx >= widthDivisions)
    {
        nx = widthDivisions-1;
    }
    return nx;
}

- (int)Ny:(CGPoint)p
{
    int ny = (int)(heightDivisions*p.y/self.bounds.size.height);
    if (ny >= heightDivisions)
    {
        ny = heightDivisions-1;
    }
    return ny;
}

- (CGRect)getRectFromI:(int)i andJ:(int)j
{
    CGFloat x0 = (i*self.bounds.size.width)/widthDivisions;
    CGFloat y0 = (j*self.bounds.size.height)/heightDivisions;
    CGRect myrect = CGRectMake(x0, y0, self.dx, self.dy);
    
    return myrect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"blockingView::touchesBegan");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint tapPoint = [touch locationInView:self];
    int nx = [self Nx:tapPoint];
    int ny = [self Ny:tapPoint];
    if (self.visible[[self matrixIndexfromI:nx andJ:ny]])
    {
        self.visible[[self matrixIndexfromI:nx andJ:ny]] = NO;

        [self setNeedsDisplayInRect:[self getRectFromI:nx andJ:ny]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"blockingView::touchesMoved");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint tapPoint = [touch locationInView:self];
    //NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",tapPoint.x, tapPoint.y];
    //NSLog(@"%@",text);
    int nx = [self Nx:tapPoint];
    int ny = [self Ny:tapPoint];
    if (self.visible[[self matrixIndexfromI:nx andJ:ny]])
    {
        self.visible[[self matrixIndexfromI:nx andJ:ny]] = NO;
        //[self setNeedsDisplay];
        [self setNeedsDisplayInRect:[self getRectFromI:nx andJ:ny]];

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"%w=%f, h=%f",rect.size.width,rect.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);

    if (self.firstDraw)
    {
        self.firstDraw = NO;
        //CGContextBeginPath(context);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextFillRect(context, rect);
    }
    else
    {
/*
        CGFloat dx = (self.bounds.size.width)/widthDivisions + 0.6;
        CGFloat dy = (self.bounds.size.height)/heightDivisions + 0.6;
    
        for (int i=0; i<widthDivisions; i++)
        {
            for (int j=0; j<heightDivisions; j++)
            {
                CGFloat x0 = (i*self.bounds.size.width)/widthDivisions;
                CGFloat y0 = (j*self.bounds.size.height)/heightDivisions;
                CGRect myrect = CGRectMake(x0, y0, dx, dy);
                CGFloat alpha = 1.0;
                if (!self.visible[[self matrixIndexfromI:i andJ:j]])
                {
                    alpha = 0.0;
                }
                CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, alpha);
                CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, alpha);
                CGContextFillRect(context, myrect);
            }
        }
 */
        CGFloat alpha = 0.0;

        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, alpha);
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, alpha);
        CGContextFillRect(context, rect);
    }
    CGContextStrokePath(context);

}


@end
