//
//  setPropertyViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-08-09.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "setPropertyViewController.h"
#import "coefficientTableViewController.h"
#import "equationViewController.h"

#import "commentVC.h"
#import "functions.h"
#import "functionValue.h"

@interface setPropertyViewController ()
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) int currentRow;
@property (strong, nonatomic) NSArray *originalCoefficients;
@end

@implementation setPropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.minTemperatureField.delegate = self;
    self.maxTemperatureField.delegate = self;
    self.minPressureField.delegate = self;
    self.maxPressureField.delegate = self;
    self.unitField.delegate = self;
    
    NSDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSDictionary *propertyDict = [speciesDict objectForKey:_property];
    
    NSString *functionName = [propertyDict objectForKey:@"function"];
    _originalCoefficients = [NSArray arrayWithArray:[propertyDict objectForKey:@"coefficients"]];
    
    [_functionButton setTitle:functionName forState:UIControlStateNormal];
    NSDictionary *temperatureRange = [propertyDict objectForKey:@"temperatureRange"];
    NSNumber *minTemp = [temperatureRange objectForKey:@"min"];
    NSNumber *maxTemp = [temperatureRange objectForKey:@"max"];
    [self.minTemperatureField setText:[NSString stringWithFormat:@"%g",[minTemp doubleValue]]];
    [self.maxTemperatureField setText:[NSString stringWithFormat:@"%g",[maxTemp doubleValue]]];
    
    NSDictionary *pressureRange = [propertyDict objectForKey:@"pressureRange"];
    NSNumber *minPressure = [pressureRange objectForKey:@"min"];
    NSNumber *maxPressure = [pressureRange objectForKey:@"max"];

    double maxPressureMpa = 1.0e-6*[maxPressure doubleValue];
    
    [self.minPressureField setText:[NSString stringWithFormat:@"%g",1.0e-6*[minPressure doubleValue]]];
    [self.maxPressureField setText:[NSString stringWithFormat:@"%g",maxPressureMpa]];
    
    [_unitField setText:[propertyDict objectForKey:@"unit"]];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    self.picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.picker.showsSelectionIndicator = YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;

    int selectedFunction = 0;
    for (int i=0; i<[_functionNames count]; i++) {
        if ([[_functionNames objectAtIndex:i] isEqualToString:functionName]) {
            selectedFunction = i;
        }
    }
    [self.picker selectRow:selectedFunction inComponent:0 animated:YES];
    self.currentRow = selectedFunction;
    
}

- (void)viewDidUnload
{
    [self setFunctionButton:nil];
    [self setMinTemperatureField:nil];
    [self setMaxTemperatureField:nil];
    [self setMinPressureField:nil];
    [self setMaxPressureField:nil];
    
    [self setClickedCoefficientsButton:nil];
    [self setUnitField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickedFunctionButton:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Properties"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet setOpaque:YES];
    [self.actionSheet addSubview:self.picker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Done"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    
    [self.actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[@"Cancel"]];
    cancelButton.momentary = YES;
    cancelButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.0];
    cancelButton.tintColor = darkRed;
    
    //[cancelButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchCancel];
    [cancelButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];

    
    [self.actionSheet addSubview:cancelButton];
    
    //[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];

}

- (IBAction)minTempEnter:(UITextField *)sender {
    NSNumber *val = [NSNumber numberWithDouble:[[sender text] doubleValue]];
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    NSMutableDictionary *temperatureRange = [propertyDict objectForKey:@"temperatureRange"];
    [temperatureRange setObject:val forKey:@"min"];
}

- (IBAction)maxTempEnter:(UITextField *)sender {
    NSNumber *val = [NSNumber numberWithDouble:[[sender text] doubleValue]];
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    NSMutableDictionary *temperatureRange = [propertyDict objectForKey:@"temperatureRange"];
    [temperatureRange setValue:val forKey:@"max"];
}

- (IBAction)minPressureEnter:(UITextField *)sender {
    double inp = [[sender text] doubleValue];
    double inpMpa = 1.0e6*inp;
    NSNumber *val = [NSNumber numberWithDouble:inpMpa];
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    
    NSMutableDictionary *pressureRange = [propertyDict objectForKey:@"pressureRange"];
    [pressureRange setValue:val forKey:@"min"];
}

- (IBAction)maxPressureEnter:(UITextField *)sender {
    double inp = [[sender text] doubleValue];
    double inpMpa = 1.0e6*inp;
    NSNumber *val = [NSNumber numberWithDouble:inpMpa];
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    
    NSMutableDictionary *pressureRange = [propertyDict objectForKey:@"pressureRange"];
    [pressureRange setValue:val forKey:@"max"];
}

- (void)cancelActionSheet:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSDictionary *propertyDict = [speciesDict objectForKey:_property];
    NSString *functionName = [propertyDict objectForKey:@"function"];
    
    int selectedFunction = 0;
    for (int i=0; i<[_functionNames count]; i++) {
        if ([[_functionNames objectAtIndex:i] isEqualToString:functionName]) {
            selectedFunction = i;
        }
    }
    [self.picker selectRow:selectedFunction inComponent:0 animated:YES];
}

- (void)dismissActionSheet:(id)sender
{
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *functionName = [_functionNames objectAtIndex:self.currentRow];
    [_functionButton setTitle:functionName forState:UIControlStateNormal];
    
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    NSString *propFuncName = [propertyDict objectForKey:@"function"];
    
    if (![functionName isEqualToString:propFuncName])
    {
        // function has changed
        functions *mySel = [[functions alloc] init];

        id newFunction = [mySel select:functionName];

        int newNCoeff = [newFunction nCoefficients];
        int oldNCoeff = [_originalCoefficients count];
        
        [propertyDict removeObjectForKey:@"function"];
        [propertyDict setObject:functionName forKey:@"function"];


        NSArray *newCoeffs = [_db createCoefficients:newNCoeff];
            
        // copy the old values to the new array
        for (int i=0; i<newNCoeff; i++)
        {
            NSString *coeffName = [NSString stringWithFormat:@"A%d",i];
            if (i < oldNCoeff)
            {
                NSMutableDictionary *old = [_originalCoefficients objectAtIndex:i];
                NSMutableDictionary *new = [newCoeffs objectAtIndex:i];
                [new setObject:[old objectForKey:coeffName] forKey:coeffName];
            }
        }
        // remove old coefficients and add new ones
        [propertyDict removeObjectForKey:@"coefficients"];
        NSDictionary *coeffDict = @{ @"coefficients" : newCoeffs };
        NSMutableDictionary *mcd = [[NSMutableDictionary alloc] initWithDictionary:coeffDict];
        [propertyDict addEntriesFromDictionary:mcd];
    }
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_functionNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_functionNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentRow = [pickerView selectedRowInComponent:0];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    
    if ([segue.identifier isEqualToString:@"coefficientsSegue"])
    {

        NSMutableArray *coeffs = [propertyDict objectForKey:@"coefficients"];
        
        [segue.destinationViewController setCoefficients:coeffs];
        [segue.destinationViewController setTitle:@"Coefficients"];
    }
    
    if ([segue.identifier isEqualToString:@"commentSegue"])
    {
 
        NSString *comment = [propertyDict objectForKey:@"comment"];
        
        [segue.destinationViewController setComment:comment];
        [segue.destinationViewController setDict:propertyDict];
    }
    
    if ([segue.identifier isEqualToString:@"equationSegue"])
    {
        NSString *name = [propertyDict objectForKey:@"function"];
        [segue.destinationViewController setFunctionName:name];
        
        /*
        Class functionClass = (NSClassFromString(name));
        id<functionValue> f = [[functionClass alloc] init];
        NSString *eqText = f.equationText;
        [segue.destinationViewController setEquation:eqText];
        */
        [segue.destinationViewController setTitle:name];
    }
}

- (IBAction)unitEnter:(UITextField *)sender
{
    NSString *unit = sender.text;
    NSMutableDictionary *speciesDict = [_db.json objectForKey:_specie];
    NSMutableDictionary *propertyDict = [speciesDict objectForKey:_property];
    
    [propertyDict setValue:unit forKey:@"unit"];
    [_parent update];

}

@end
