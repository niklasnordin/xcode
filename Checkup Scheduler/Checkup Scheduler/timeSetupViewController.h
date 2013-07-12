//
//  timeSetupViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-30.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeSetupViewController : UIViewController
<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (strong, nonatomic) NSArray *minutes;
@property (weak, nonatomic) NSMutableDictionary *eventDict;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@end
