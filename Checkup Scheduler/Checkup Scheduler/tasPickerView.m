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
        return [NSString stringWithFormat:@"%3d",[[self.minutes objectAtIndex:row] intValue]];
    }
    else
    {
        return [NSString stringWithFormat:@"%3d",row];
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
