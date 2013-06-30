//
//  timeSetupViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-30.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "timeSetupViewController.h"

@interface timeSetupViewController ()

@property (strong,nonatomic) NSMutableArray *selected;
@property (strong, nonatomic) NSArray *minutes;
@end

@implementation timeSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _selected = [[NSMutableArray alloc] initWithObjects:
                 [NSNumber numberWithInt:0],
                 [NSNumber numberWithInt:0],
                 [NSNumber numberWithInt:0],
                 nil];
    
    _minutes = [[NSArray alloc] initWithObjects:@"0", @"15", @"30", @"45", nil];

    _timePicker.dataSource = self;
    _timePicker.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 2)
    {
        return 4;
    }
    else if (component == 1)
    {
        return 24;
    }
    else
    {
        return 365;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 2)
    {
        return [self.minutes objectAtIndex:row];
    }
    else
    {
        return [NSString stringWithFormat:@"%d",row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d, %d",row,component);
    NSNumber *num = [NSNumber numberWithInt:row];
    [self.selected setObject:num atIndexedSubscript:component];
}
@end
