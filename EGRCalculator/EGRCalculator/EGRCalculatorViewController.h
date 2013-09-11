//
//  EGRCalculatorViewController.h
//  EGRCalculator
//
//  Created by Niklas Nordin on 2011-12-03.
//  Copyright (c) 2011 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRCalculator.h"

@interface EGRCalculatorViewController : UIViewController

@property (nonatomic, strong) EGRCalculator *egrCalc;

@property (weak, nonatomic) IBOutlet UITextField *cnText;
@property (weak, nonatomic) IBOutlet UITextField *cmText;
@property (weak, nonatomic) IBOutlet UITextField *crText;
@property (weak, nonatomic) IBOutlet UITextField *lambaText;
@property (weak, nonatomic) IBOutlet UITextField *egrText;
@property (weak, nonatomic) IBOutlet UITextField *o2Text;
@property (weak, nonatomic) IBOutlet UITextField *n2Text;
- (IBAction)calculateButton:(id)sender;

@end
