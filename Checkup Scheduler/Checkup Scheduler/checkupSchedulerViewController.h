//
//  checkupSchedulerViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-21.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface checkupSchedulerViewController : UIViewController
<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (strong, nonatomic) NSMutableArray *schemeNames;
@property (strong, nonatomic) NSMutableDictionary *schemesDictionary;
- (IBAction)createEvent:(id)sender;
-(void)save;
@property (weak, nonatomic) IBOutlet UIButton *schemeButton;
- (IBAction)clickedSchemeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createEventButton;

@end
