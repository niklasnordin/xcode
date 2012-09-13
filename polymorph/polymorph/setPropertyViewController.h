//
//  setPropertyViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-09.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "database.h"
#import "polymorphViewController.h"
#import "RollerUIButton.h"

@interface setPropertyViewController : UIViewController <UIPickerViewDelegate,
UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) polymorphViewController* parent;

@property (weak, nonatomic) database *db;
@property (weak, nonatomic) NSString *specie;
@property (weak, nonatomic) NSString *property;
@property (weak, nonatomic) NSMutableArray *functionNames;
@property (nonatomic) int currentRow;
@property (strong, nonatomic) UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIButton *functionButton;
@property (weak, nonatomic) IBOutlet UITextField *minTemperatureField;
@property (weak, nonatomic) IBOutlet UITextField *maxTemperatureField;
@property (weak, nonatomic) IBOutlet UITextField *minPressureField;
@property (weak, nonatomic) IBOutlet UITextField *maxPressureField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;

- (IBAction)clickedFunctionButton:(id)sender;
- (IBAction)minTempEnter:(UITextField *)sender;
- (IBAction)maxTempEnter:(UITextField *)sender;
- (IBAction)minPressureEnter:(UITextField *)sender;
- (IBAction)maxPressureEnter:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *clickedCoefficientsButton;
- (IBAction)unitEnter:(UITextField *)sender;

-(void)setNewFunction:(NSString *)functionName;

@end
