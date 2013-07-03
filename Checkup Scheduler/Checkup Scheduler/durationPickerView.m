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
    if (self) {
        // Initialization code
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
