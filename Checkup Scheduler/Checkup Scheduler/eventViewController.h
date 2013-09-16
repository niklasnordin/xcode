//
//  eventViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/29/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "settingsDB.h"

@interface eventViewController : UIViewController
<
    UITextFieldDelegate
>

@property (strong, nonatomic) NSNumber *days;
@property (strong, nonatomic) NSNumber *hours;
@property (strong, nonatomic) NSNumber *minutes;
@property (strong, nonatomic) NSNumber *durationHours;
@property (strong, nonatomic) NSNumber *durationMinutes;

@property (strong,nonatomic) settingsDB *preferences;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) NSMutableDictionary *eventDict;
@property (weak, nonatomic) IBOutlet UIButton *timeAfterStartButton;
- (IBAction)timeAfterStartButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *durationButton;
- (IBAction)durationClicked:(UIButton *)sender;
- (IBAction)allDayEventClicked:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *allDayEventSwitch;

@property (weak, nonatomic) IBOutlet UIButton *reminderButton;
- (IBAction)reminderButtonClicker:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *busySwitch;
- (IBAction)busySwitchClicked:(id)sender;

//- (IBAction)setTimer:(UIStoryboardSegue *)segue;
//- (IBAction)cancelTimer:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UILabel *timeAfterStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *allDayEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UILabel *busyLabel;
- (IBAction)clickedButton:(UIButton *)sender;
- (IBAction)draggedOutside:(UIButton *)sender;
- (IBAction)touchUpInside:(id)sender;

@end
