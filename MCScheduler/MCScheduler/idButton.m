//
//  idButton.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-29.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "idButton.h"

@implementation idButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _id = [[NSNumber alloc] init];
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
