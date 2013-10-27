//
//  PlotView.m
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-29.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "PlotView.h"

@implementation PlotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (IBAction)testButtonPressed:(id)sender
{
    [self performSelectorInBackground:@selector(calculateValues) withObject:nil];
}

- (void)calculateValues
{
    //NSString *labelText = [NSString stringWithFormat:@"%d",i];
    //self.iterationLabel.text = labelText;
    //self.iterationLabel.textColor = [UIColor blackColor];
    for(int i=1; i<5; i++)
    {
        float v = tgammaf(i);
        NSLog(@"i=%i, gamma=%f",i,v);
    }
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
