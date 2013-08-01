//
//  timeSetupViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-30.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "timeSetupViewController.h"

@interface timeSetupViewController ()

//@property (strong,nonatomic) NSMutableArray *selected;
@end

@implementation timeSetupViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int days    = [[_eventDict objectForKey:@"days"] intValue];
    int hours   = [[_eventDict objectForKey:@"hours"] intValue];
    int minutes = [[_eventDict objectForKey:@"minutes"] intValue];
    
    int minutesIndex = minutes / 15;
    /*
    _selected = [[NSMutableArray alloc] initWithObjects:
                 [NSNumber numberWithInt:days],
                 [NSNumber numberWithInt:hours],
                 [NSNumber numberWithInt:minutes],
                 nil];
    */
    _minutes = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:0],
                [NSNumber numberWithInt:15],
                [NSNumber numberWithInt:30],
                [NSNumber numberWithInt:45],
                nil];
    
    _timePicker.dataSource = self;
    _timePicker.delegate = self;
    
    [_timePicker selectRow:minutesIndex inComponent:2 animated:NO];
    [_timePicker selectRow:hours inComponent:1 animated:NO];
    [_timePicker selectRow:days inComponent:0 animated:NO];
    
    // color setup
    [self.view setBackgroundColor:self.preferences.backgroundColor];
    [self.preferences setupButton:self.cancelButton withColor:self.preferences.backgroundColor];
    [self.preferences setupButton:self.setButton withColor:self.preferences.backgroundColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
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
        return [NSString stringWithFormat:@"%d",[[self.minutes objectAtIndex:row] intValue]];
    }
    else
    {
        return [NSString stringWithFormat:@"%d",row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
/*
    NSNumber *num = [NSNumber numberWithInt:row];
    //[self.selected setObject:num atIndexedSubscript:component];

    if (component == 2)
    {
        NSNumber *num = [self.minutes objectAtIndex:row];
        [self.eventDict setObject:num forKey:@"minutes"];
    }
    else if (component == 1)
    {
        [self.eventDict setObject:num forKey:@"hours"];
    }
    else
    {
        [self.eventDict setObject:num forKey:@"days"];
    }
    */    
}
@end
