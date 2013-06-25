//
//  checkupSchedulerViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-21.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "checkupSchedulerViewController.h"
#import "EventKit/EventKit.h"

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
    
    NSLog(@"View did load");
    
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
            NSLog(@"jessdf 2");
            
            [alert show];
            NSLog(@"jessdf 234");
            [self.store reset];
        }
    }

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"kaller";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"identifier = %@",segue.identifier);
}

@end




