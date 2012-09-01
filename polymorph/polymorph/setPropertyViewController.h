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
@property (nonatomic,strong) NSString *specie;
@property (nonatomic, strong) NSString *property;
@property (weak, nonatomic) NSMutableArray *functionNames;
@property (nonatomic) int currentRow;
@property (strong, nonatomic) UIPickerView *picker;

@property (strong, nonatomic) IBOutlet UIButton *functionButton;
@property (strong, nonatomic) IBOutlet UITextField *minTemperatureField;
@property (strong, nonatomic) IBOutlet UITextField *maxTemperatureField;
@property (strong, nonatomic) IBOutlet UITextField *minPressureField;
@property (strong, nonatomic) IBOutlet UITextField *maxPressureField;
@property (strong, nonatomic) IBOutlet UITextField *unitField;

- (IBAction)clickedFunctionButton:(id)sender;
- (IBAction)minTempEnter:(UITextField *)sender;
- (IBAction)maxTempEnter:(UITextField *)sender;
- (IBAction)minPressureEnter:(UITextField *)sender;
- (IBAction)maxPressureEnter:(UITextField *)sender;
@property (strong, nonatomic) IBOutlet UIButton *clickedCoefficientsButton;
- (IBAction)unitEnter:(UITextField *)sender;

-(void)setNewFunction:(NSString *)functionName;

@end
