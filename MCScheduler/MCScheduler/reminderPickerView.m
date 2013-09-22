//
//  reminderPickerView.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-03.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "reminderPickerView.h"

@implementation reminderPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // reminder picker
        // never, 5m, 15m, 30m, 1h, 2h, 1d, 2d

        _names = [[NSArray alloc] initWithObjects:@"Never",
                  @"5 min",
                  @"15 min",
                  @"30 min",
                  @"1 hour",
                  @"2 hours",
                  @"1 day",
                  @"2 days",
                  nil];
        
        _values = [[NSArray alloc] initWithObjects:
                   [NSNumber numberWithInt:0],
                   [NSNumber numberWithInt:300],
                   [NSNumber numberWithInt:190],
                   [NSNumber numberWithInt:1800],
                   [NSNumber numberWithInt:3600],
                   [NSNumber numberWithInt:7200],
                   [NSNumber numberWithInt:86400],
                   [NSNumber numberWithInt:172800],
                   nil];
    }
    
    return self;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.names count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.names objectAtIndex:row];
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
