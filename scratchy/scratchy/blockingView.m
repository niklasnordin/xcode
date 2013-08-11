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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
