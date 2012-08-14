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

@interface setPropertyViewController : UIViewController <UIPickerViewDelegate,
UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) polymorphViewController* parent;

@property (strong, nonatomic) database *db;
@property (nonatomic,strong) NSString *specie;
@property (nonatomic, strong) NSString *property;
@property (strong, nonatomic) NSMutableArray *functionNames;

@property (strong, nonatomic) IBOutlet UIButton *functionButton;
@property (strong, nonatomic) IBOutlet UITextField *minTemperatureField;
@property (strong, nonatomic) IBOutlet UITextField *maxTemperatureField;
@property (strong, nonatomic) IBOutlet UITextField *minPressureField;
@property (strong, nonatomic) IBOutlet UITextField *maxPressureField;
@property (strong, nonatomic) IBOutlet UISwitch *pressureSwitch;


- (IBAction)clickedFunctionButton:(id)sender;
- (IBAction)minTempEnter:(UITextField *)sender;
- (IBAction)maxTempEnter:(UITextField *)sender;
- (IBAction)minPressureEnter:(UITextField *)sender;
- (IBAction)maxPressureEnter:(UITextField *)sender;
@property (strong, nonatomic) IBOutlet UIButton *clickedCoefficientsButton;
- (IBAction)pressureDependencySwitch:(UISwitch *)sender;


@end
