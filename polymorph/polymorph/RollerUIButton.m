//
//  RollerUIButton.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-16.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "RollerUIButton.h"

@implementation RollerUIButton

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"init with frame");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) init
{
    NSLog(@"init");
    self = [super init];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [super drawRect:rect];
    NSLog(@"drawing RollerUIButton");
}
*/

@end
