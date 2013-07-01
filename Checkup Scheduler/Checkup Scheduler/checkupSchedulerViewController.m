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
#import "EventKit/EventKit.h"

#define SCHEMENAMES @"schemeNames"
#define SCHEMESDICTIONARY @"schemesDictionary"

@interface checkupSchedulerViewController ()

@property (strong, nonatomic) EKEventStore *store;
@property (nonatomic) BOOL accessGranted;

@end

@implementation checkupSchedulerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _store = [[EKEventStore alloc] init];
    [[self store] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
        _accessGranted = granted;
    }
    ];
    
    _schemePicker.delegate = self;
    _schemePicker.dataSource = self;
    
    checkupSchedulerAppDelegate *appDelegate = (checkupSchedulerAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.appView = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

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
        NSLog(@"Pushed createEvent button");
        
        int selected = [self.schemePicker selectedRowInComponent:0];
        NSString *scheme = [self.schemeNames objectAtIndex:selected];
        NSMutableDictionary *schemeDict = [self.schemesDictionary objectForKey:scheme];
        NSMutableArray *dictionaries = [schemeDict objectForKey:@"eventDictionaries"];

        int nEvents = [dictionaries count];
        
        BOOL allEventsCreated = YES;
        
        for (int i=0; i<nEvents; i++)
        {
            NSMutableDictionary *dict = [dictionaries objectAtIndex:i];
        
            EKEvent *myEvent  = [EKEvent eventWithEventStore:self.store];

            myEvent.title = [NSString stringWithFormat:@"Nicke %@",[dict objectForKey:@"title"]];
            NSDate *initialDate = [NSDate date];
            int minutes = [[dict objectForKey:@"minutes"] intValue];
            int hours = [[dict objectForKey:@"hours"] intValue];
            int days = [[dict objectForKey:@"days"] intValue];
            
            int seconds = 60*minutes + 3600*hours + 86400*days;
        
            NSDate *startDate = [NSDate dateWithTimeInterval:seconds sinceDate:initialDate];
            myEvent.startDate = startDate;
            myEvent.endDate   = startDate;
            myEvent.allDay = YES;
            //EKAlarm *alarm
            //myEvent.alarms
            //NSString *calendarName = [dict objectForKey:@"calendarName"];
            //EKCalendar *cal = [self.store calendarWithIdentifier:@"nickes cal"];
            EKCalendar *cal = [self.store defaultCalendarForNewEvents];
        
            [myEvent setCalendar:cal];

            NSError *err;

            [self.store saveEvent:myEvent span:EKSpanThisEvent error:&err];
            
            allEventsCreated = allEventsCreated && ([err code] == noErr);
            
            NSLog(@"err code = %@", err);
            if ([err code] == noErr)
            {
                [self.store reset];
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
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.schemeNames forKey:SCHEMENAMES];
    [defaults setObject:self.schemesDictionary forKey:SCHEMESDICTIONARY];
    
    [defaults synchronize];
}

@end




