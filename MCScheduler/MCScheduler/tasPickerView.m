//
//  tasPickerView.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-09-16.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "tasPickerView.h"

@implementation tasPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _minutes = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInt:0],
                    [NSNumber numberWithInt:15],
                    [NSNumber numberWithInt:30],
                    [NSNumber numberWithInt:45],
                    nil];

        CGFloat dayOffsety = 46.0; // higher number will place it lower
        CGFloat dayOffsetx = -25.0;
        
        CGRect dayRect = CGRectMake(frame.origin.x + dayOffsetx, frame.origin.y + dayOffsety, frame.size.width/3.0, 20.0);
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayRect];
        dayLabel.text = @"days";
        dayLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:dayLabel];
        
        CGFloat hoursOffsetx = frame.size.width/3.0 - 25.0;
        CGRect hoursRect = CGRectMake(frame.origin.x + hoursOffsetx, frame.origin.y + dayOffsety, frame.size.width/3.0, 20.0);
        
        UILabel *hoursLabel = [[UILabel alloc] initWithFrame:hoursRect];
        hoursLabel.text = @"hours";
        hoursLabel.textAlignment = NSTextAlignmentRight;

        [self addSubview:hoursLabel];
        
        CGFloat minutesOffsetx = 2.0*frame.size.width/3.0 - 10.0;
        CGRect minutesRect = CGRectMake(frame.origin.x + minutesOffsetx, frame.origin.y + dayOffsety, frame.size.width/3.0, 20.0);
        
        UILabel *minutesLabel = [[UILabel alloc] initWithFrame:minutesRect];
        minutesLabel.text = @"minutes";
        minutesLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:minutesLabel];
    }
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int selected = -1;
    switch (component) {
        case 0:
            selected = 365;
            break;
        case 1:
            selected = 24;
            break;
        case 2:
            selected = 4;
            break;
        default:
            break;
    }
    
    return selected;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 2)
    {
        return [NSString stringWithFormat:@"%5d",[[self.minutes objectAtIndex:row] intValue]];
    }
    else
    {
        return [NSString stringWithFormat:@"%5d",row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    
    if (component == 2)
    {
        label.text = [NSString stringWithFormat:@"%5d",[[self.minutes objectAtIndex:row] intValue]];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"%5d",row];
    }

    label.textAlignment = NSTextAlignmentLeft;
    /*
    int selected = [pickerView selectedRowInComponent:component];
    if (row == selected)
    {
        switch (component)
        {
            case 0:
                label.text = [NSString stringWithFormat:@"%@ day",label.text];
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"%@ hour",label.text];
            case 2:
                label.text = [NSString stringWithFormat:@"%@ min",label.text];
            default:
                break;
        }
    }
     */
    
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
