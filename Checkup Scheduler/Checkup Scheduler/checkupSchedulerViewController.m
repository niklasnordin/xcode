//
//  checkupSchedulerViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-21.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "checkupSchedulerAppDelegate.h"
#import "checkupSchedulerViewController.h"
#import "EventKit/EventKit.h"

#define SCHEMENAMES @"schemeNames"

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
    _schemes = [[NSMutableArray alloc] init];
    
    checkupSchedulerAppDelegate *appDelegate = (checkupSchedulerAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.appView = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _schemeNames = [defaults objectForKey:SCHEMENAMES];
    
    if (!_schemeNames)
    {
        _schemeNames = [[NSMutableArray alloc] init];
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
        EKEvent *myEvent  = [EKEvent eventWithEventStore:self.store];
        
        myEvent.title     = @"Nikolaus den Yngre";
        myEvent.startDate = [NSDate date];
        myEvent.endDate   = [NSDate date];
        myEvent.allDay = YES;
        
        [myEvent setCalendar:[self.store defaultCalendarForNewEvents]];

        // handle access here
        NSError *err;

        [self.store saveEvent:myEvent span:EKSpanThisEvent error:&err];
            
        NSLog(@"err code = %@", err);
        if ([err code] == noErr)
        {
            NSLog(@"jessdf");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Events created successfully"
                                message:@"Yay!?"
                                delegate:nil
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles:nil];
            
            [alert show];
            [self.store reset];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Events could not be created"
                                  message:@"Yay!?"
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
    return [self.schemeNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.schemeNames count])
    {
        return [self.schemeNames objectAtIndex:row];
    }
    else
    {
        return @"";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"schemeSegue"])
    {
        [segue.destinationViewController setSchemeNames:[self schemeNames]];
        [segue.destinationViewController setSchemePicker:[self schemePicker]];
    }
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.schemeNames forKey:SCHEMENAMES];
    
    [defaults synchronize];
}

@end




