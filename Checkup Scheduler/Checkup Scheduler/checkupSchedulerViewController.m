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

@end

@implementation checkupSchedulerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEvent:(id)sender
{
    NSLog(@"Pushed createEvent button");
    EKEventStore *eventDB = [[EKEventStore alloc] init];
        
    [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
        
        EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
        
        myEvent.title     = @"Nikolaus den Yngre";
        myEvent.startDate = [NSDate date];
        myEvent.endDate   = [NSDate date];
        myEvent.allDay = YES;
        
        [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];

        // handle access here
        NSError *err;
        NSLog(@"granted = %d", granted);
        if (granted)
        {
            [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
            
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

            }
        }
    }
    ];
    

}
@end
