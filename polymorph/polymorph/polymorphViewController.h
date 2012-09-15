//
//  polymorphViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "database.h"
#import "functions.h"

@interface polymorphViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,
    UIActionSheetDelegate>


@property (strong, nonatomic) NSString *currentSpeciesName;
@property (strong, nonatomic) NSString *currentPropertyName;

@property (weak, nonatomic) IBOutlet UIButton *speciesButton;

@property (weak, nonatomic) IBOutlet UILabel *constantTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyDisplay;
@property (weak, nonatomic) IBOutlet UITextField *temperatureMin;
@property (weak, nonatomic) IBOutlet UITextField *temperatureMax;
@property (weak, nonatomic) IBOutlet UITextField *minPressureField;
@property (weak, nonatomic) IBOutlet UITextField *pressureField;
@property (strong, nonatomic) id function;
@property (strong, nonatomic) NSMutableArray *functionNames;
@property (strong, nonatomic) NSString *link;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ptSegmentControl;

@property (strong, nonatomic) database *db;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
- (IBAction)enterPressureText:(UITextField *)sender;
- (IBAction)changedPTSwitch:(UISegmentedControl *)sender;

- (IBAction)clickedSpecieButton:(id)sender;
-(void)update;

@end
