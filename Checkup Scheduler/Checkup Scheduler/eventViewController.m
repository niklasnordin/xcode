//
//  eventViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/29/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "eventViewController.h"
#import "timeSetupViewController.h"

@interface eventViewController ()

@end

@implementation eventViewController

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
    _titleTextField.delegate = self;
    _titleTextField.text = [_eventDict objectForKey:@"title"];
    
    _days = [_eventDict objectForKey:@"days"];
    _hours = [_eventDict objectForKey:@"hours"];
    _minutes = [_eventDict objectForKey:@"minutes"];
    _duration = [_eventDict objectForKey:@"duration"];
    
    NSString *buttonText = [NSString stringWithFormat:@"%dd:%dh:%dm",[_days intValue],[_hours intValue], [_minutes intValue]];
    [_timeAfterStartButton setTitle:buttonText forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.days = [self.eventDict objectForKey:@"days"];
    self.hours = [self.eventDict objectForKey:@"hours"];
    self.minutes = [self.eventDict objectForKey:@"minutes"];
    self.duration = [self.eventDict objectForKey:@"duration"];
    
    NSString *buttonText = [NSString stringWithFormat:@"%dd:%dh:%dm",[self.days intValue],[self.hours intValue], [self.minutes intValue]];
    [self.timeAfterStartButton setTitle:buttonText forState:UIControlStateNormal];
    
    [self.durationButton setEnabled:![self.allDayEventSwitch isOn]];
    if ([self.allDayEventSwitch isOn])
    {
        [self.durationButton setTitle:@"all day" forState:UIControlStateNormal];
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"%d",[self.duration intValue]];
        [self.durationButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSString *text = [self.titleTextField text];
    [self.eventDict setObject:text forKey:@"title"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeSegue"])
    {
        // hej
        timeSetupViewController *tsvc = segue.destinationViewController;
        [tsvc setEventDict:self.eventDict];
    }
}

// reminder picker
// never, 5m, 15m, 30m, 1h, 2h, 1d, 2d

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = [textField text];
    [self.eventDict setObject:text forKey:@"title"];

    [textField resignFirstResponder];
    return YES;
}

- (IBAction)allDayEventClicked:(UISwitch *)sender
{
    [self.durationButton setEnabled:![sender isOn]];
    if ([self.allDayEventSwitch isOn])
    {
        [self.durationButton setTitle:@"all day" forState:UIControlStateNormal];
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"%d",[self.duration intValue]];
        [self.durationButton setTitle:title forState:UIControlStateNormal];
    }
}

@end
