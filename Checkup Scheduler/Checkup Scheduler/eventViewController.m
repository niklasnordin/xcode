//
//  eventViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/29/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "eventViewController.h"
#import "timeSetupViewController.h"
#import "durationPickerView.h"
#import "reminderPickerView.h"

@interface eventViewController ()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong,nonatomic) durationPickerView *durationPicker;
@property (strong, nonatomic) reminderPickerView *reminderPicker;
@property (nonatomic) int previousReminderIndex;
@property (nonatomic) int previousDayTimer;
@property (nonatomic) int previousHoursTimer;
@property (nonatomic) int previousMinutesTimer;

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
    _durationHours = [_eventDict objectForKey:@"durationHours"];
    _durationMinutes = [_eventDict objectForKey:@"durationMinutes"];
    
    NSString *buttonText = [NSString stringWithFormat:@"%dd:%dh:%dm",[_days intValue],[_hours intValue], [_minutes intValue]];
    [_timeAfterStartButton setTitle:buttonText forState:UIControlStateNormal];
    
    // setup the picker
    CGRect pickerFrame = CGRectMake(8, 52, 304, 0);

    _durationPicker = [[durationPickerView alloc] initWithFrame:pickerFrame];
    _durationPicker.showsSelectionIndicator = YES;
    _durationPicker.delegate = _durationPicker;
    _durationPicker.dataSource = _durationPicker;
    
    _reminderPicker = [[reminderPickerView alloc] initWithFrame:pickerFrame];
    _reminderPicker.showsSelectionIndicator = YES;
    _reminderPicker.delegate = _reminderPicker;
    _reminderPicker.dataSource = _reminderPicker;
    
    _previousReminderIndex = 0;
    NSNumber *remTimer = [_eventDict objectForKey:@"reminderTimer"];
    for (int i=0; i < [_reminderPicker.values count]; i++)
    {
        if ([[_reminderPicker.values objectAtIndex:i] intValue] == [remTimer intValue])
        {
            _previousReminderIndex = i;
        }
    }
    NSString *title = [self.reminderPicker.names objectAtIndex:_previousReminderIndex];
    [self.reminderButton setTitle:title forState:UIControlStateNormal];
    [_reminderPicker selectRow:_previousReminderIndex inComponent:0 animated:NO];
    
    _allDayEventSwitch.on = [[_eventDict objectForKey:@"allDayEvent"] boolValue];
    _busySwitch.on = [[_eventDict objectForKey:@"busy"] boolValue];
    
    //[_busySwitch setOnImage:<#(UIImage *)#>
    [_busySwitch setOffImage:[UIImage imageNamed:@"UISwitch-No"]];
    
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [mySwitch setOnImage: [UIImage imageNamed:@"UISwitch-Yes"]];
        [mySwitch setOffImage:[UIImage imageNamed:@"UISwitch-No"]];
    }
     */
}

-(void)viewWillAppear:(BOOL)animated
{
    self.days = [self.eventDict objectForKey:@"days"];
    self.hours = [self.eventDict objectForKey:@"hours"];
    self.minutes = [self.eventDict objectForKey:@"minutes"];
    self.durationHours = [self.eventDict objectForKey:@"durationHours"];
    self.durationMinutes = [self.eventDict objectForKey:@"durationMinutes"];
    
    NSString *buttonText = [NSString stringWithFormat:@"%dd:%dh:%dm",[self.days intValue],[self.hours intValue], [self.minutes intValue]];
    [self.timeAfterStartButton setTitle:buttonText forState:UIControlStateNormal];
    
    [self.durationButton setEnabled:![self.allDayEventSwitch isOn]];
    if ([self.allDayEventSwitch isOn])
    {
        [self.durationButton setTitle:@"all day" forState:UIControlStateNormal];
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"%dh:%dm",[self.durationHours intValue],[self.durationMinutes intValue]];
        [self.durationButton setTitle:title forState:UIControlStateNormal];
    }
    int hours = [self.durationHours intValue];
    int minutes = [self.durationMinutes intValue];
    [self.durationPicker selectRow:hours inComponent:0 animated:NO];
    [self.durationPicker selectRow:minutes/15 inComponent:1 animated:NO];
    
    // setup colors
    [self.view setBackgroundColor:self.preferences.backgroundColor];
    [self.titleTextField setTextColor:self.preferences.textColor];
    [self.titleTextField setBackgroundColor:self.preferences.backgroundColor];
    
    [self.preferences setupButton:self.timeAfterStartButton withColor:self.preferences.backgroundColor];
    [self.preferences setupButton:self.durationButton withColor:self.preferences.backgroundColor];
    [self.preferences setupButton:self.reminderButton withColor:self.preferences.backgroundColor];
    
    [self.allDayEventSwitch setTintColor:self.preferences.backgroundColor];
    [self.busySwitch setTintColor:self.preferences.backgroundColor];
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
        timeSetupViewController *tsvc = segue.destinationViewController;
        self.previousDayTimer = [[self.eventDict objectForKey:@"days"] intValue];
        self.previousHoursTimer = [[self.eventDict objectForKey:@"hours"] intValue];
        self.previousMinutesTimer = [[self.eventDict objectForKey:@"minutes"] intValue];
        [tsvc setEventDict:self.eventDict];
        [tsvc setPreferences:self.preferences];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = [textField text];
    [self.eventDict setObject:text forKey:@"title"];

    [textField resignFirstResponder];
    return YES;
}

- (IBAction)durationClicked:(UIButton *)sender
{
    [self.preferences setupButton:sender withColor:self.preferences.backgroundColor];

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"duration (hours, mins)"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    //[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    //[self.actionSheet setOpaque:YES];
    [self.actionSheet addSubview:self.durationPicker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Select"]];
    
    closeButton.frame = CGRectMake(258.0f, 7.0f, 50.0f, 30.0f);
    //closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self
                    action:@selector(dismissActionSheet:)
          forControlEvents:UIControlEventValueChanged];
    
    [self.actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[@"Cancel"]];
    cancelButton.frame = CGRectMake(12.0f, 7.0f, 50.0f, 30.0f);
    UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    cancelButton.tintColor = darkRed;
    [cancelButton addTarget:self
                     action:@selector(cancelActionSheet:)
           forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:cancelButton];
    
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0.0f, 0.0f, 320.0f, 485.0f)];

}

- (IBAction)allDayEventClicked:(UISwitch *)sender
{

    [self.eventDict setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"allDayEvent"];
    [self.durationButton setEnabled:![sender isOn]];
    if ([self.allDayEventSwitch isOn])
    {
        [self.durationButton setTitle:@"all day" forState:UIControlStateNormal];
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"%dh:%dm",[self.durationHours intValue],[self.durationMinutes intValue]];
        [self.durationButton setTitle:title forState:UIControlStateNormal];
    }
}


- (void)dismissActionSheet:(id)sender
{
    int hours = [self.durationPicker selectedRowInComponent:0];
    int minutes = 15*[self.durationPicker selectedRowInComponent:1];

    self.durationHours = [NSNumber numberWithInt:hours];
    self.durationMinutes = [NSNumber numberWithInt:minutes];
    
    [self.eventDict setObject:self.durationHours forKey:@"durationHours"];
    [self.eventDict setObject:self.durationMinutes forKey:@"durationMinutes"];

    NSString *title = [NSString stringWithFormat:@"%dh:%dm",hours, minutes];
    [self.durationButton setTitle:title forState:UIControlStateNormal];
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}


- (void)cancelActionSheet:(id)sender
{
    int hours = [self.durationHours intValue];
    int minutes = [self.durationMinutes intValue];
    
    [self.durationPicker selectRow:hours inComponent:0 animated:YES];
    [self.durationPicker selectRow:minutes/15 inComponent:1 animated:YES];

    // reset the selection of the picker
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

- (IBAction)reminderButtonClicker:(id)sender
{
    [self.preferences setupButton:sender withColor:self.preferences.backgroundColor];

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Reminder"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    //[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    //[self.actionSheet setOpaque:YES];
    [self.actionSheet addSubview:self.reminderPicker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Select"]];
    
    closeButton.frame = CGRectMake(258.0f, 7.0f, 50.0f, 30.0f);
    //closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self
                    action:@selector(dismissReminder:)
          forControlEvents:UIControlEventValueChanged];
    
    [self.actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[@"Cancel"]];
    cancelButton.frame = CGRectMake(12.0f, 7.0f, 50.0f, 30.0f);
    UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    cancelButton.tintColor = darkRed;
    [cancelButton addTarget:self
                     action:@selector(cancelReminder:)
           forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:cancelButton];
    
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0.0f, 0.0f, 320.0f, 485.0f)];
    

}

- (void)dismissReminder:(id)sender
{
    self.previousReminderIndex = [self.reminderPicker selectedRowInComponent:0];
    NSString *title = [self.reminderPicker.names objectAtIndex:self.previousReminderIndex];
    [self.reminderButton setTitle:title forState:UIControlStateNormal];

    [self.eventDict setObject:[self.reminderPicker.values objectAtIndex:self.previousReminderIndex] forKey:@"reminderTimer"];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

- (void)cancelReminder:(id)sender
{
    // reset the selection of the picker
    [self.reminderPicker selectRow:_previousReminderIndex inComponent:0 animated:YES];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

- (IBAction)busySwitchClicked:(UISwitch *)sender
{
    [self.eventDict setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"busy"];
}


- (IBAction)setTimer:(UIStoryboardSegue *)segue
{
    timeSetupViewController *tvc = segue.sourceViewController;
    //[self.eventDict setObject:num forKey:@"days"];
    int days = [tvc.timePicker selectedRowInComponent:0];
    int hours = [tvc.timePicker selectedRowInComponent:1];
    int minutesIndex = [tvc.timePicker selectedRowInComponent:2];
    int minutes = [[tvc.minutes objectAtIndex:minutesIndex] intValue];
    [self.eventDict setObject:[NSNumber numberWithInt:days] forKey:@"days"];
    [self.eventDict setObject:[NSNumber numberWithInt:hours] forKey:@"hours"];
    [self.eventDict setObject:[NSNumber numberWithInt:minutes] forKey:@"minutes"];

    NSString *buttonText = [NSString stringWithFormat:@"%dd:%dh:%dm", days, hours, minutes];
    [self.timeAfterStartButton setTitle:buttonText forState:UIControlStateNormal];
     
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelTimer:(UIStoryboardSegue *)segue
{

    timeSetupViewController *tvc = segue.sourceViewController;
    [self.eventDict setObject:[NSNumber numberWithInt:self.previousDayTimer] forKey:@"days"];
    [self.eventDict setObject:[NSNumber numberWithInt:self.previousHoursTimer] forKey:@"hours"];
    [self.eventDict setObject:[NSNumber numberWithInt:self.previousMinutesTimer] forKey:@"minutes"];

    int minutesIndex = self.previousMinutesTimer / 15;
    [tvc.timePicker selectRow:minutesIndex inComponent:2 animated:YES];
    [tvc.timePicker selectRow:self.previousHoursTimer inComponent:1 animated:YES];
    [tvc.timePicker selectRow:self.previousDayTimer inComponent:0 animated:YES];

    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)clickedButton:(UIButton *)sender
{
    [self.preferences setupButton:sender withColor:self.preferences.selectedButtonColor];
}

- (IBAction)draggedOutside:(UIButton *)sender
{
    [self.preferences setupButton:sender withColor:self.preferences.backgroundColor];
}

- (IBAction)touchUpInside:(id)sender
{
    [self.preferences setupButton:sender withColor:self.preferences.backgroundColor];
}
@end
