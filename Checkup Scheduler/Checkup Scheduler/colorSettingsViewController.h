//
//  colorSettingsViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colorSettingsViewController : UIViewController
<
    UITextFieldDelegate
>

@property (strong,nonatomic) UIColor *backgroundColor;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
- (IBAction)redSliderChanged:(UISlider *)sender;
- (IBAction)greenSliderChanged:(UISlider *)sender;
- (IBAction)blueSliderChanged:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;

@end
