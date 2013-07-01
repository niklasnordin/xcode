//
//  eventViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/29/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventViewController : UIViewController
<
    UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) NSMutableDictionary *eventDict;
@property (weak, nonatomic) IBOutlet UIButton *timeAfterStartButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;

@end
