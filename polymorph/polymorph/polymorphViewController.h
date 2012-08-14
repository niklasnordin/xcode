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
@property (strong, nonatomic) IBOutlet UIButton *speciesButton;

@property (strong, nonatomic) IBOutlet UILabel *propertyDisplay;
@property (strong, nonatomic) IBOutlet UITextField *temperatureMin;
@property (strong, nonatomic) IBOutlet UITextField *temperatureMax;
@property (strong, nonatomic) IBOutlet UITextField *pressureField;
@property (strong, nonatomic) id function;
@property (strong, nonatomic) NSMutableArray *functionNames;

@property (strong, nonatomic) database *db;
@property (strong, nonatomic) IBOutlet UIButton *viewButton;
- (IBAction)enterPressureText:(UITextField *)sender;

- (IBAction)clickedSelect:(id)sender;
- (IBAction)clickedSpecieButton:(id)sender;
-(void)update;

@end
