//
//  polymorphViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "polymorphViewController.h"
#import "diagramViewController.h"
#import "diagramView.h"
#import "dbTableViewController.h"
#import "loadDatabaseViewController.h"
#import "functions.h"

@interface polymorphViewController ()
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) int selectedConstantProperty;
@property (nonatomic) BOOL pressureDependent;
@property (strong,nonatomic) functions *selector;

@property (nonatomic) int selectedComponent0;
@property (nonatomic) int selectedComponent1;

@end

@implementation polymorphViewController

-(void)loadFunctions
{
    _functionNames = [[NSMutableArray alloc] init];
    
    //[_functionNames addObject:[function_0001 name]];
    //[_functionNames addObject:[function_0002 name]];
    
    [_functionNames addObject:[nsrds_0 name]];
    [_functionNames addObject:[nsrds_1 name]];
    [_functionNames addObject:[nsrds_2 name]];
    [_functionNames addObject:[nsrds_3 name]];
    [_functionNames addObject:[nsrds_4 name]];
    [_functionNames addObject:[nsrds_5 name]];
    [_functionNames addObject:[nsrds_6 name]];
    
    [_functionNames addObject:[janaf_cp name]];
    [_functionNames addObject:[janaf_h name]];
    [_functionNames addObject:[janaf_s name]];
    
    [_functionNames addObject:[idealGasLaw name]];
    [_functionNames addObject:[pengRobinson name]];
    //[_functionNames addObject:[pengRobinsonLiquid name]];
    
    [_functionNames addObject:[ancillary_1 name]];
    [_functionNames addObject:[ancillary_2 name]];
    [_functionNames addObject:[ancillary_3 name]];
    
    //[_functionNames addObject:[fundamentalJacobsen name]];

}

-(void)checkPressureInput:(UITextField *)sender
{
    
    NSDictionary *propertiesDict = [_db.json objectForKey:_currentSpeciesName];
    NSDictionary *propDict = [propertiesDict objectForKey:_currentPropertyName];
    
    NSString *functionName = [propDict objectForKey:@"function"];
    Class functionClass = (NSClassFromString(functionName));
    
    id f;
    if (functionClass != nil)
    {
        f = [[functionClass alloc] init];
    }
    else
    {
        NSLog(@"%@ is an illegal function. Abort!",functionName);
        abort();
    }
        
    if ([f pressureDependent])
    {
        NSDictionary *prd = [propDict objectForKey:@"pressureRange"];
        
        double pInput = [[sender text] doubleValue];
        pInput *= 1.0e+6;
        double pMin = [[prd valueForKey:@"min"] doubleValue];
        double pMax = [[prd valueForKey:@"max"] doubleValue];

        if (pInput <= pMin)
        {
            double pMinMpa = 1.0e-6*pMin;
            [sender setText:[NSString stringWithFormat:@"%g", pMinMpa]];
        }
        if (pInput >= pMax)
        {
            double pMaxMPa = 1.0e-6*pMax;
            [sender setText:[NSString stringWithFormat:@"%g", pMaxMPa]];
        }
    }
}

- (IBAction)enterPressureText:(UITextField *)sender
{
    [self checkPressureInput:sender];
}

- (IBAction)changedPTSwitch:(UISegmentedControl *)sender
{

    if (_pressureDependent)
    {
        int s = [sender selectedSegmentIndex];
        if (s != _selectedConstantProperty)
        {
            _selectedConstantProperty = s;
            if (s == 0) {
                //pressure is selected
                [_minPressureField setHidden:YES];
                [_temperatureMin setHidden:NO];
            }
            else
            {
                // temperature is selected
                [_minPressureField setHidden:NO];
                [_temperatureMin setHidden:YES];
            }
        }
    }
}

- (IBAction)clickedSpecieButton:(id)sender {
    
    _selectedComponent0 = [_picker selectedRowInComponent:0];
    _selectedComponent1 = [_picker selectedRowInComponent:1];
    //NSLog(@"1. c0 = %d, c1 = %d",_selectedComponent0, _selectedComponent1);
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Properties"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet setOpaque:YES];
    [self.actionSheet addSubview:self.picker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Select"]];
    //closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self
                    action:@selector(dismissActionSheet:)
          forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:@[@"Cancel"]];
    //cancelButton.momentary = YES;
    cancelButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    UIColor *darkRed = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.0];
    cancelButton.tintColor = darkRed;
    [cancelButton addTarget:self
                     action:@selector(cancelActionSheet:)
           forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:cancelButton];
    
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}


- (void)dismissActionSheet:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    //_actionSheet = nil;
    
    NSArray *species = self.db.orderedSpecies;
    int i0 = [_picker selectedRowInComponent:0];
    int i1 = [_picker selectedRowInComponent:1];

    _currentSpeciesName = [species objectAtIndex:i0];
    if ([species count])
    {
        NSDictionary *propertiesDict = [self.db.json objectForKey:_currentSpeciesName];
        if ([propertiesDict count])
        {
            NSArray *properties = [self.db orderedPropertiesForSpecie:_currentSpeciesName];
            _currentPropertyName = [properties objectAtIndex:i1];
            [self.propertyDisplay setText:_currentPropertyName];
            _viewButton.enabled = YES;
        }
        else
        {
            [self.propertyDisplay setText:@""];
            _viewButton.enabled = NO;
        }
    }

    [self update];
}


- (void)cancelActionSheet:(id)sender
{
    //NSLog(@"cancelActionSheet");
    // reset the picker
    [_picker reloadComponent:0];
    [_picker selectRow:_selectedComponent0 inComponent:0 animated:NO];
    [_picker reloadComponent:1];
    [_picker selectRow:_selectedComponent1 inComponent:1 animated:NO];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    //NSLog(@"2. c0 = %d, c1 = %d",_selectedComponent0, _selectedComponent1);

    //[self update];

}

-(void) update
{
    NSArray *species = self.db.orderedSpecies;
    NSString *speciesText = [[NSString alloc] init];
    NSString *propertiesText = @"No database loaded";
    NSString *unitText = @"";
    
    [_pressureField setPlaceholder:@"max"];
    _pressureDependent = NO;
    [_ptSegmentControl setHidden:YES];
    [_constantTextLabel setHidden:YES];
    
    int index0 = 0;
    int index1 = 0;
    
    if ([species count])
    {
        if ([species containsObject:_currentSpeciesName])
        {
            index0 = [species indexOfObject:_currentSpeciesName];
        }
        else
        {
            _currentSpeciesName = [species objectAtIndex:index0];
        }

        NSDictionary *propertiesDict = [self.db.json objectForKey:_currentSpeciesName];
        speciesText = _currentSpeciesName;
        
        if ([propertiesDict count])
        {
            
            [_viewButton setEnabled:YES];
            NSArray *propertyNames = [_db orderedPropertiesForSpecie:_currentSpeciesName];
            if ([propertyNames containsObject:_currentPropertyName])
            {
                index1 = [propertyNames indexOfObject:_currentPropertyName];
            }
            else
            {
                _currentPropertyName = [propertyNames objectAtIndex:index1];
            }
            propertiesText = _currentPropertyName;
            NSDictionary *propertyDict = [propertiesDict objectForKey:_currentPropertyName];
            unitText = [propertyDict objectForKey:@"unit"];

            NSString *functionName = [propertyDict objectForKey:@"function"];
            Class functionClass = (NSClassFromString(functionName));
            
            id f;
            if (functionClass != nil) {
                f = [[functionClass alloc] init];
            }
            else
            {
                NSLog(@"%@ is an illegal function. Abort!",functionName);
                abort();
            }
                        
            if ([f pressureDependent])
            {
                [_pressureField setEnabled:YES];
                [self checkPressureInput:_pressureField];
                [self checkPressureInput:_minPressureField];
                _pressureDependent = YES;
                [_ptSegmentControl setHidden:NO];
                [_constantTextLabel setHidden:NO];
            }
            else
            {
                [_pressureField setText:@""];
                [_pressureField setPlaceholder:@"not used"];
                [_pressureField setEnabled:NO];
            }
        }
        else
        {
            propertiesText = @"No properties available";
            [_viewButton setEnabled:NO];
        }
    }
    else
    {
        [_viewButton setEnabled:NO];
        [_pressureField setText:@""];
        [_pressureField setPlaceholder:@"not used"];
        [_pressureField setEnabled:NO];
    }
    
    [self.speciesButton setTitle:speciesText forState:UIControlStateNormal];
    [_propertyDisplay setText:[NSString stringWithFormat:@"%@ [%@]", propertiesText, unitText]];

    if (!_pressureDependent)
    {
        [_temperatureMin setHidden:NO];
        [_minPressureField setHidden:YES];
    }


    [_picker reloadComponent:0];
    [_picker selectRow:index0 inComponent:0 animated:NO];
    [_picker reloadComponent:1];
    [_picker selectRow:index1 inComponent:1 animated:NO];


}

- (void)viewDidLoad
{

    [super viewDidLoad];
    _temperatureMin.delegate = self;
    _temperatureMax.delegate = self;
    _pressureField.delegate = self;
    _minPressureField.delegate = self;
    
    // load the database and initiate it
    _selector = [[functions alloc] init];
    _db = [[database alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _db.json = [defaults objectForKey:@"database"];
    if (!_db.json)
    {
        _db.json = [[NSMutableDictionary alloc] init];
    }
    
    _link = [defaults objectForKey:@"link"];
    _currentSpeciesName = [defaults objectForKey:@"currentSpeciesName"];
    _currentPropertyName = [defaults objectForKey:@"currentPropertyName"];
    
    //NSLog(@"currentSpeciesName = %@",_currentSpeciesName);
    //NSLog(@"currentPropertyName = %@",_currentPropertyName);
    
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadFunctions];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    _picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    _picker.showsSelectionIndicator = YES;
    _picker.dataSource = self;
    _picker.delegate = self;
    
    // uisegmentcontrol config
    _selectedConstantProperty = 0;
    [_ptSegmentControl setSelectedSegmentIndex:_selectedConstantProperty];
    [_minPressureField setHidden:YES];
    [self update];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_link forKey:@"link"];
    [defaults setObject:_currentSpeciesName forKey:@"currentSpeciesName"];
    [defaults setObject:_currentPropertyName forKey:@"currentPropertyName"];
    [defaults setObject:_db.json forKey:@"database"];
    
    [defaults synchronize];
}

- (void)viewDidUnload
{

    [self save];
    
    [self setPicker:nil];
    [self setTemperatureMin:nil];
    [self setTemperatureMax:nil];
    [self setPropertyDisplay:nil];
    [self setPressureField:nil];
    [self setSpeciesButton:nil];
    [self setViewButton:nil];
    [self setMinPressureField:nil];

    [self setPtSegmentControl:nil];
    [self setConstantTextLabel:nil];
    [super viewDidUnload];
            
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    NSArray *species = self.db.orderedSpecies;
    if (component == 0)
    {
        num = [species count];
    }
    else
    {
        if ([species count])
        {
            int i = [pickerView selectedRowInComponent:0];
            NSDictionary *propertiesDict = [self.db.json objectForKey:[species objectAtIndex:i]];
            //NSDictionary *propertiesDict = [self.db.json objectForKey:_currentSpeciesName];

            if ([propertiesDict count])
            {
                NSArray *properties = [propertiesDict allKeys];
                num = [properties count];
            }
        }
    }
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name = @"";
    NSArray *species = self.db.orderedSpecies;
    
    if ([species count])
    {
        if (component == 0)
        {
            name = [species objectAtIndex:row];
        }
        else
        {
            int i = [pickerView selectedRowInComponent:0];
            NSString *specie = [species objectAtIndex:i];
            NSDictionary *propertiesDict = [self.db.json objectForKey:specie];
            if ([propertiesDict count])
            {
                NSArray *properties = [self.db orderedPropertiesForSpecie:specie];
                name = [properties objectAtIndex:row];
            }
        }
    }
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [pickerView reloadComponent:1];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // This is the place to setup the view before displaying it
    if ([segue.identifier isEqualToString:@"drawViewSegue"])
    {
        double tMin = [self.temperatureMin.text doubleValue];
        double tMax = [self.temperatureMax.text doubleValue];
        double pMin = 1.0e+6*[self.minPressureField.text doubleValue];
        double pMax = 1.0e+6*[self.pressureField.text doubleValue];

        NSDictionary *propertiesDict = [self.db.json objectForKey:_currentSpeciesName];
        NSDictionary *propDict = [propertiesDict objectForKey:_currentPropertyName];

        NSString *funcName = [propDict objectForKey:@"function"];
        NSArray *coeffDictArray = [propDict objectForKey:@"coefficients"];

        _function = [_selector select:funcName withArray:coeffDictArray];
        
        [segue.destinationViewController setSpecie:_currentSpeciesName];
        [segue.destinationViewController setProperty:_currentPropertyName];
        
        // pressure is the constant property
        if (_selectedConstantProperty == 0)
        {
            [segue.destinationViewController setup:_function
                                              dict:propDict
                                               min:tMin
                                               max:tMax
                                               cpv:pMax];
            [segue.destinationViewController setXIsT:YES];
        }
        
        if (_selectedConstantProperty == 1)
        {
            [segue.destinationViewController setup:_function
                                              dict:propDict
                                               min:pMin
                                               max:pMax
                                               cpv:tMax];
            [segue.destinationViewController setXIsT:NO];
        }
        NSString *title = [NSString stringWithFormat:@"%@, %@", _currentSpeciesName, _currentPropertyName];
        [segue.destinationViewController setTitle:title];
    }

    if ([segue.identifier isEqualToString:@"loadSegue"])
    {
        [segue.destinationViewController setDb:_db];
        [segue.destinationViewController setParent:self];
        [segue.destinationViewController setFunctionNames:_functionNames];
        [segue.destinationViewController setLink:_link];
    }
}

@end
