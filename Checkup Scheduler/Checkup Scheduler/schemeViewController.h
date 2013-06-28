//
//  schemeViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/26/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface schemeViewController : UIViewController
<
    UITextFieldDelegate
>

@property (weak, nonatomic) NSMutableDictionary *schemeDictionary;
@property (weak, nonatomic) IBOutlet UILabel *numEventsLabel;
@property (weak, nonatomic) IBOutlet UIStepper *numEventsStepperValue;
@property (weak, nonatomic) IBOutlet UITextField *calendarNameTextField;
- (IBAction)numEventsStepperPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
