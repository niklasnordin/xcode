//
//  blockingView.m
//  scratchy
//
//  Created by Niklas Nordin on 2013-08-11.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "blockingView.h"

static int widthDivisions = 20;
static int heightDivisions = 20;

@implementation blockingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    }
    
    return self;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"blockingView::touchesBegan");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint tapPoint = [touch locationInView:self];
    int nx = [self Nx:tapPoint];
    int ny = [self Ny:tapPoint];
    self.visible[[self matrixIndexfromI:nx andJ:ny]] = NO;
    //NSLog(@"nx=%d, ny=%d", nx, ny);
    [self setNeedsDisplay];

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
    self.visible[[self matrixIndexfromI:nx andJ:ny]] = NO;
    //NSLog(@"nx=%d, ny=%d", nx, ny);
    [self setNeedsDisplay];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"blockingView::touchesEnded");
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.8);
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 0.8);
    // Drawing code
    //NSLog(@"drawRect for blockingView");
    CGFloat dx = self.bounds.size.width/widthDivisions;
    CGFloat dy = self.bounds.size.height/heightDivisions;
    
    for (int i=0; i<widthDivisions; i++)
    {
        for (int j=0; j<heightDivisions; j++)
        {
            if (!self.visible[[self matrixIndexfromI:i andJ:j]])
            {
                //NSLog(@"drawRect i=%d, j=%d",i,j);
                CGFloat x0 = (i*self.bounds.size.width)/widthDivisions;
                CGFloat y0 = (j*self.bounds.size.height)/heightDivisions;
                CGRect myrect = CGRectMake(x0, y0, dx, dy);
                CGContextFillRect(context, myrect);
                //CGContextMoveToPoint(context, x0, x0);
                //CGContextAddLineToPoint(context, x0+dx, y0+dy);
                //NSLog(@"x0=%f, y0=%f",x0,y0);
            }
        }
    }
    CGContextStrokePath(context);

}


@end
