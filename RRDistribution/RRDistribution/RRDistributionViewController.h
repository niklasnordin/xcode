//
//  RRDistributionViewController.h
//  RRDistribution
//
//  Created by Niklas Nordin on 2013-09-28.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pdf.h"
#import "RosinRammlerPDF.h"

@interface RRDistributionViewController : UIViewController
<
    UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *iterationLabel;
@property (weak, nonatomic) IBOutlet UITextField *smdTargetTextField;
@property (weak, nonatomic) IBOutlet UITextField *dv90TargetTextField;
@property (weak, nonatomic) IBOutlet UILabel *smdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dv90Label;
@property (weak, nonatomic) IBOutlet UILabel *lambdaLabel;
@property (weak, nonatomic) IBOutlet UILabel *kLabel;

@property (strong, nonatomic) RosinRammlerPDF<pdf> *function;
@property (nonatomic) float lambda;
@property (nonatomic) float k;
- (IBAction)calculateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;

@end
