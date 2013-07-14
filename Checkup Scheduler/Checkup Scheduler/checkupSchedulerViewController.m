//
//  checkupSchedulerViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-21.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "checkupSchedulerAppDelegate.h"
#import "checkupSchedulerViewController.h"
#import "schemeTableViewController.h"
#import "settingsViewController.h"
#import "EventKit/EventKit.h"

#define SCHEMENAMES @"schemeNames"
#define SCHEMESDICTIONARY @"schemesDictionary"
#define SCHEMEPICKER @"schemePicker"

@interface checkupSchedulerViewController ()

@property (nonatomic) int selectedNameIndex;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popOver;
@property (strong, nonatomic) UIPickerView *schemePicker;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) EKEventStore *store;
@property (nonatomic) BOOL accessGranted;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation checkupSchedulerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _preferences = [[settingsDB alloc] init];
    _store = [[EKEventStore alloc] init];
    _topBannerView.delegate = self;
    checkupSchedulerAppDelegate *appDelegate = (checkupSchedulerAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.appView = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [_preferences readFromUserDefaults:defaults];
    
    _schemeNames = [defaults objectForKey:SCHEMENAMES];
    
    if (!_schemeNames)
    {
        _schemeNames = [[NSMutableArray alloc] init];
    }
    
    _schemesDictionary = [defaults objectForKey:SCHEMESDICTIONARY];
    
    if (!_schemesDictionary)
    {
        _schemesDictionary = [[NSMutableDictionary alloc] init];
    }
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    //NSLog(@"self.view.height = %f",self.view.bounds.size.height);
    // setup the picker
    //CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    CGRect pickerFrame = CGRectMake(0, 40, 0, 500);

    _schemePicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    //_schemePicker = [[UIPickerView alloc] init];
    _schemePicker.showsSelectionIndicator = YES;
    _schemePicker.delegate = self;
    _schemePicker.dataSource = self;
   
    NSNumber *pickerItemNumber = [defaults objectForKey:SCHEMEPICKER];
    [_schemePicker selectRow:[pickerItemNumber integerValue] inComponent:0 animated:NO];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];

    _eventTextField.delegate = self;
    
    _accessGranted = YES;

    [[self store] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         _accessGranted = granted;
     }
     ];

    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    _startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [_datePicker setDate:_startDate];
    [self.view setBackgroundColor:_preferences.backgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{

    if ([self.schemeNames count] == 0)
    {
         // deactivate the scheme button
        [self.schemeButton setTitle:@"No available schemes" forState:UIControlStateNormal];
        [self.schemeButton setEnabled:NO];
        [self.calendarInfoLabel setText:@""];
    }
    else
    {
        int selected = [self.schemePicker selectedRowInComponent:0];
        NSString *scheme = [self.schemeNames objectAtIndex:selected];
        NSMutableDictionary *schemeDict = [self.schemesDictionary objectForKey:scheme];
        
        [self.schemeButton setEnabled:YES];
        [self.schemeButton setTitle:[NSString stringWithFormat:@"Scheme: %@",[self.schemeNames objectAtIndex:selected]] forState:UIControlStateNormal];
        NSString *calendarName = [schemeDict objectForKey:@"calendarName"];
        [self.calendarInfoLabel setText:[NSString stringWithFormat:@"Calendar Name:%@",calendarName]];

    }
    
    if (!self.accessGranted)
    {
        [[self store] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             self.accessGranted = granted;
         }
         ];
    }
    if (!self.accessGranted)
    {
        [self.createEventButton setTitle:@"No permission to change the calendar" forState:UIControlStateNormal];
        [self.createEventButton setEnabled:NO];
    }
    else
    {
        [self.createEventButton setTitle:@"Create Events" forState:UIControlStateNormal];
        [self.createEventButton setEnabled:YES];
    }

    [self.startDateButton setTitle:[NSString stringWithFormat:@"Start: %@", [self.dateFormatter stringFromDate:self.startDate]] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEvent:(id)sender
{
    if ([self accessGranted])
    {
        NSString *eventTitle = self.eventTextField.text;
        
        if ([eventTitle isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Failed"
                                  message:@"You must specify an event title"
                                  delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
            
            [alert show];
            return;
        }
             
        int selected = [self.schemePicker selectedRowInComponent:0];
        NSString *scheme = [self.schemeNames objectAtIndex:selected];
        NSMutableDictionary *schemeDict = [self.schemesDictionary objectForKey:scheme];
        NSMutableArray *dictionaries = [schemeDict objectForKey:@"eventDictionaries"];
        NSString *calendarName = [schemeDict objectForKey:@"calendarName"];
        NSArray *calendars = [self.store calendarsForEntityType:EKEntityTypeEvent];
        
        EKCalendar *cal = nil; //[self.store calendarWithIdentifier:calendarName];
        EKCalendar *localCalendar = [self.store defaultCalendarForNewEvents]; // keep this in case we need to create a new calendar
        for (EKCalendar *calendar in calendars)
        {
            if ([calendarName isEqualToString:calendar.title])
            {
                cal = calendar;
            }
        }
    
        NSError *err = nil;

        if (cal == nil)
        {
            NSLog(@"cal is nil");
            cal = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.store];

            if (cal == nil)
            {
                NSLog(@"could not create calendar %@",calendarName);
                return;
            }
            [cal setTitle:calendarName];
            [cal setSource:localCalendar.source];
            [self.store saveCalendar:cal commit:YES error:&err];
            if ([err code] == noErr)
            {
                NSLog(@"saved new calendar successfully");
            }
        }
    
        int nEvents = [dictionaries count];
        
        BOOL allEventsCreated = YES;
        
        NSString *prefixTitle = self.eventTextField.text;
        for (int i=0; i<nEvents; i++)
        {
            NSMutableDictionary *dict = [dictionaries objectAtIndex:i];
        
            EKEvent *myEvent  = [EKEvent eventWithEventStore:self.store];

            myEvent.title = [NSString stringWithFormat:@"%@ %@",prefixTitle, [dict objectForKey:@"title"]];
            NSDate *initialDate = self.startDate;
            int minutes = [[dict objectForKey:@"minutes"] intValue];
            int hours = [[dict objectForKey:@"hours"] intValue];
            int days = [[dict objectForKey:@"days"] intValue];
            int durationHours = [[dict objectForKey:@"durationHours"] intValue];
            int durationMinutes = [[dict objectForKey:@"durationMinutes"] intValue];
            int reminderTimer = [[dict objectForKey:@"reminderTimer"] intValue];

            BOOL allDayEvent = [[dict objectForKey:@"allDayEvent"] boolValue];
            BOOL busy = [[dict objectForKey:@"busy"] boolValue];
            
            int seconds = 60*minutes + 3600*hours + 86400*days;
            int duration = 60*durationMinutes + 3600*durationHours;
            
            NSDate *startDate = [NSDate dateWithTimeInterval:seconds sinceDate:initialDate];
            NSDate *endDate = [NSDate dateWithTimeInterval:duration sinceDate:startDate];

            myEvent.startDate = startDate;
            myEvent.endDate   = endDate;
            myEvent.allDay = allDayEvent;
            myEvent.availability = !busy;
            
            if (reminderTimer > 0)
            {
                NSTimeInterval timer = -reminderTimer;
                EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:timer];
                [myEvent addAlarm:alarm];
            }
            
            [myEvent setCalendar:cal];
            [self.store saveEvent:myEvent span:EKSpanThisEvent error:&err];
            
            allEventsCreated = allEventsCreated && ([err code] == noErr);
            
            if ([err code] == noErr)
            {
                [self.store reset];
            }
            else
            {
                NSLog(@"err code = %@", err);  
            }
        }
        
        if (allEventsCreated)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Success"
                                message:@"Events created successfully"
                                delegate:nil
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles:nil];
            
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Failed"
                                  message:@"Events could not be created."
                                  delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // prevents crash if no schemes are available
    if (![self.schemeNames count])
    {
        return 1;
    }
    return [self.schemeNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.schemeNames count] > 0)
    {
        return [self.schemeNames objectAtIndex:row];
    }
    else
    {
        return @"";
    }
}

/*
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected row = %d", row);
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"schemeSegue"])
    {
        schemeTableViewController *stvc = (schemeTableViewController *)segue.destinationViewController;
        
        [stvc setSchemeNames:[self schemeNames]];
        [stvc setSchemePicker:[self schemePicker]];
        [stvc setSchemesDictionary:[self schemesDictionary]];
    }
    else if ([segue.identifier isEqualToString:@"settingsSegue"])
    {
        settingsViewController *svc = (settingsViewController *)segue.destinationViewController;
        [svc setPreferences:self.preferences];
    }
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.schemeNames forKey:SCHEMENAMES];
    [defaults setObject:self.schemesDictionary forKey:SCHEMESDICTIONARY];
    
    NSInteger pickerItem = [self.schemePicker selectedRowInComponent:0];
    
    [defaults setObject:[NSNumber numberWithInteger:pickerItem] forKey:SCHEMEPICKER];
    [self.preferences saveToUserDefaults:defaults];
    [defaults synchronize];
}

- (IBAction)clickedSchemeButton:(id)sender
{
    NSString *deviceModel = [[UIDevice currentDevice] model];
    NSLog(@"deviceModel = %@",deviceModel);
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    //self.popOver = [[UIPopoverController alloc] init];
    /*
    NSLog(@"view rect = w = %f, h = %f",self.view.bounds.size.width,self.view.bounds.size.height);

    // remember the selected name, in case the selection is cancelled
    self.selectedNameIndex = [self.schemePicker selectedRowInComponent:0];

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Schemes"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    //[self.actionSheet showInView:self.view];
    [self.actionSheet showFromRect:CGRectMake(100.0f, 100.0f, 620.0f, 400.0f) inView:self.view animated:YES];

    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    //[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];

    [self.actionSheet setOpaque:YES];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Select"]];

    closeButton.frame = CGRectMake(260.0f, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self
                    action:@selector(dismissActionSheet:)
          forControlEvents:UIControlEventValueChanged];
    
    [self.actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[@"Cancel"]];
    cancelButton.frame = CGRectMake(10.0f, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.0];
    cancelButton.tintColor = darkRed;
    [cancelButton addTarget:self
                     action:@selector(cancelActionSheet:)
           forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:cancelButton];

    [self.actionSheet addSubview:self.schemePicker];


    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 500)];
    //[self.actionSheet setFrame:CGRectMake(0, 0, 400, 500)];
    //[self.actionSheet setBounds:CGRectMake(0, 0, width, height+60)];
    //[self.actionSheet setBounds:self.schemePicker.bounds];
    CGRect af = self.actionSheet.frame;
    NSLog(@"x=%f, y=%f, wid=%f, height=%f",af.origin.x, af.origin.y, af.size.width, af.size.height);
     */
}

- (void)dismissActionSheet:(id)sender
{
    int selected = [self.schemePicker selectedRowInComponent:0];
    [self.schemeButton setTitle:[NSString stringWithFormat:@"Scheme: %@",[self.schemeNames objectAtIndex:selected]] forState:UIControlStateNormal];
    
    NSString *scheme = [self.schemeNames objectAtIndex:selected];
    NSMutableDictionary *schemeDict = [self.schemesDictionary objectForKey:scheme];
        
    NSString *calendarName = [schemeDict objectForKey:@"calendarName"];
    [self.calendarInfoLabel setText:[NSString stringWithFormat:@"Calendar Name:%@",calendarName]];

    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

- (void)cancelActionSheet:(id)sender
{
    // reset the selection of the picker
    [self.schemePicker selectRow:self.selectedNameIndex inComponent:0 animated:YES];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)startDateButtonClicked:(id)sender
{
    // remember the selected name, in case the selection is cancelled
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set start date"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet setOpaque:YES];
    [self.actionSheet addSubview:self.datePicker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Select"]];
    
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self
                    action:@selector(dismissDateActionSheet:)
          forControlEvents:UIControlEventValueChanged];
    
    [self.actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[@"Cancel"]];
    cancelButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.0];
    cancelButton.tintColor = darkRed;
    [cancelButton addTarget:self
                     action:@selector(cancelDateActionSheet:)
           forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:cancelButton];
    
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];

}

- (void)dismissDateActionSheet:(id)sender
{
    self.startDate = [self.datePicker date];
    [self.startDateButton setTitle:[NSString stringWithFormat:@"Start: %@", [self.dateFormatter stringFromDate:self.startDate]] forState:UIControlStateNormal];
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

- (void)cancelDateActionSheet:(id)sender
{
    [self.datePicker setDate:self.startDate animated:YES];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

@end




