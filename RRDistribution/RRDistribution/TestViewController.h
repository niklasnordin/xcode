//
//  TestViewController.h
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pdf.h"

@interface TestViewController : UIViewController
<
    UITextFieldDelegate
>

@property id <pdf> function;
@property (weak, nonatomic) IBOutlet UITextField *nSamplesTextField;
@property (weak, nonatomic) IBOutlet UITextField *lambdaTextField;
@property (weak, nonatomic) IBOutlet UITextField *kTextField;
- (IBAction)pasteButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *iterationLabel;
@property (weak, nonatomic) IBOutlet UILabel *SMDLabel;
@property (weak, nonatomic) IBOutlet UILabel *DV90Label;
- (IBAction)TestButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@end
