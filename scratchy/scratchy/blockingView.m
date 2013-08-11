//
//  blockingView.m
//  scratchy
//
//  Created by Niklas Nordin on 2013-08-11.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "blockingView.h"

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

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"blockingView::init");
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"blockingView::touchesBegan");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"blockingView::touchesMoved");
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint tapPoint = [touch locationInView:self];
    NSString *text = [[NSString alloc] initWithFormat:@"%g, %g",tapPoint.x, tapPoint.y];
    NSLog(@"%@",text);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"blockingView::touchesEnded");
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"drawRect for blockingView");
}


@end
