//
//  TestViewController.h
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pdf.h"
#import "RRDistributionViewController.h"
#import "RosinRammlerPDF.h"

@interface TestViewController : UIViewController
<
    UITextFieldDelegate
>

@property (weak, nonatomic) RRDistributionViewController *delegate;

@property (weak, nonatomic) RosinRammlerPDF<pdf> *function;
@property (weak, nonatomic) IBOutlet UITextField *nSamplesTextField;
@property (weak, nonatomic) IBOutlet UITextField *lambdaTextField;
@property (weak, nonatomic) IBOutlet UITextField *kTextField;
- (IBAction)pasteButtonPressed:(id)sender;
- (IBAction)clearButtonPressend:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *iterationLabel;
@property (weak, nonatomic) IBOutlet UILabel *smdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dv90Label;
- (IBAction)TestButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)findRangeButtonClicked:(id)sender;

@end
