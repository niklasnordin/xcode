//
//  durationPickerView.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 7/3/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "durationPickerView.h"

@implementation durationPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        CGFloat dayOffsety = 46.0; // higher number will place it lower
        //CGFloat dayOffsetx = -25.0;
        
        CGFloat hoursOffsetx = -70.0;
        CGRect hoursRect = CGRectMake(frame.origin.x + hoursOffsetx, frame.origin.y + dayOffsety, frame.size.width/2.0, 20.0);
        
        UILabel *hoursLabel = [[UILabel alloc] initWithFrame:hoursRect];
        hoursLabel.text = @"hours";
        hoursLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:hoursLabel];
        
        CGFloat minutesOffsetx = frame.size.width/2.0 - 60.0;
        CGRect minutesRect = CGRectMake(frame.origin.x + minutesOffsetx, frame.origin.y + dayOffsety, frame.size.width/2.0, 20.0);
        
        UILabel *minutesLabel = [[UILabel alloc] initWithFrame:minutesRect];
        minutesLabel.text = @"minutes";
        minutesLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:minutesLabel];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int rows = -1;
    switch (component) {
        case 0:
            rows = 24;
            break;
            case 1:
            rows = 4;
            break;
        default:
            rows = 0;
            break;
    }

    return rows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (component == 0)
    {
        return [NSString stringWithFormat:@"%d",row];
    }
    else
    {
        return [NSString stringWithFormat:@"%d",15*row];
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    
    if (component == 0)
    {
        label.text = [NSString stringWithFormat:@"%5d",row];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"%5d",15*row];
    }
    
    label.textAlignment = NSTextAlignmentLeft;

    return label;
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
