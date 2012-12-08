//
//  polymorphViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-19.
//  Copyright (c) 2012 nequam. All rights reserved.
//
#import "polymorphAppDelegate.h"
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
    [_functionNames addObject:[soaveRedlichKwong name]];
    [_functionNames addObject:[pengRobinson name]];
    [_functionNames addObject:[pengRobinsonLiquid name]];
    [_functionNames addObject:[pengRobinsonVapour name]];
    
    [_functionNames addObject:[ancillary_1 name]];
    [_functionNames addObject:[ancillary_2 name]];
    [_functionNames addObject:[ancillary_3 name]];
    [_functionNames addObject:[ancillary_4 name]];
    
    [_functionNames addObject:[FJ_Rho name]];
    [_functionNames addObject:[FJ_Cv name]];
    [_functionNames addObject:[FJ_Cp name]];
    [_functionNames addObject:[FJ_SoundSpeed name]];

    [_functionNames addObject:[boilingTemperature name]];
    [_functionNames addObject:[sutherland name]];
    [_functionNames addObject:[antoine name]];
    
    [_functionNames addObject:[iapws97_1 name]];
    [_functionNames addObject:[iapws97_2 name]];
    [_functionNames addObject:[iapws97_2b name]];
    [_functionNames addObject:[iapws97_3 name]];
    [_functionNames addObject:[iapws97_4 name]];
    [_functionNames addObject:[iapws97_5 name]];
    [_functionNames addObject:[iapws97_rho name]];
    [_functionNames addObject:[iapws97_u name]];
    [_functionNames addObject:[iapws97_h name]];
    [_functionNames addObject:[iapws97_s name]];
    [_functionNames addObject:[iapws97_cp name]];
    [_functionNames addObject:[iapws97_cv name]];
    [_functionNames addObject:[iapws97_w name]];

}

-(void)checkPressureInput:(UITextField *)sender
{
    
    NSDictionary *propertiesDict = [_db.json objectForKey:_currentSpeciesName];
    NSDictionary *propDict = [propertiesDict objectForKey:_currentPropertyName];
    if ([propDict count] == 0)
    {
        // no property available
        return;
    }
    NSString *functionName = [propDict objectForKey:@"function"];
    Class functionClass = (NSClassFromString(functionName));
    
    id<functionValue> f;
    if (functionClass != nil)
    {
        f = [[functionClass alloc] initWithZero];
    }
    else
    {
        NSLog(@"checkPressureInput: %@ is an illegal function. Abort!",functionName);
        //abort();
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
        if (_selectedConstantProperty == 1)
        {
            double Pmin = [[_minPressureField text] doubleValue];
            double Pmax = [[_pressureField text] doubleValue];
            // add 0.01 bar to Tmax if difference is too small
            if (fabs(Pmin-Pmax) < 1.0e-6)
            {
                [_pressureField setText:[NSString stringWithFormat:@"%g", Pmin+0.01]];
            }

            // switch temperature if PMin > Pmax
            if (Pmin > Pmax)
            {
                [_minPressureField setText:[NSString stringWithFormat:@"%g", Pmax]];
                [_pressureField setText:[NSString stringWithFormat:@"%g", Pmin]];
            }
        }
    }
}

- (IBAction)enterPressureText:(UITextField *)sender
{
    [self checkPressureInput:sender];
}

- (IBAction)enterTemperatureText:(UITextField *)sender
{
    [self checkTemperatureInput:sender];
}

-(void)checkTemperatureInput:(UITextField *)sender
{
    
    NSDictionary *propertiesDict = [_db.json objectForKey:_currentSpeciesName];
    NSDictionary *propDict = [propertiesDict objectForKey:_currentPropertyName];
    if ([propDict count] == 0)
    {
        // no property available
        return;
    }
    NSString *functionName = [propDict objectForKey:@"function"];
    Class functionClass = (NSClassFromString(functionName));
    
    id<functionValue> f;
    if (functionClass != nil)
    {
        f = [[functionClass alloc] initWithZero];
    }
    else
    {
        NSLog(@"checkTemperatureInput: %@ is an illegal function. Abort!",functionName);
        //abort();
    }
    
    if ([f temperatureDependent])
    {
        NSDictionary *trd = [propDict objectForKey:@"temperatureRange"];
        
        double tInput = [[sender text] doubleValue];

        double tMin = [[trd valueForKey:@"min"] doubleValue];
        double tMax = [[trd valueForKey:@"max"] doubleValue];
        
        if (tInput <= tMin)
        {
            [sender setText:[NSString stringWithFormat:@"%g", tMin]];
        }
        if (tInput >= tMax)
        {
            [sender setText:[NSString stringWithFormat:@"%g", tMax]];
        }
        
        if (_selectedConstantProperty == 0)
        {
            double Tmin = [[_temperatureMin text] doubleValue];
            double Tmax = [[_temperatureMax text] doubleValue];
            // add 0.01 K to Tmax if difference is too small
            if (fabs(Tmin-Tmax) < 1.0e-6)
            {
                [_temperatureMax setText:[NSString stringWithFormat:@"%g", Tmin+0.01]];
            }
            // switch temperature if TMin > Tmax
            if (Tmin > Tmax)
            {
                [_temperatureMax setText:[NSString stringWithFormat:@"%g", Tmin]];
                [_temperatureMin setText:[NSString stringWithFormat:@"%g", Tmax]];
            }
        }
    }
}

- (IBAction)changedPTSwitch:(UISegmentedControl *)sender
{

    if (_pressureDependent)
    {
        int s = [sender selectedSegmentIndex];
        if (s != _selectedConstantProperty)
        {
            _selectedConstantProperty = s;
            if (s == 0)
            {
                //pressure is selected
                [_minPressureField setHidden:YES];
                [_temperatureMin setHidden:NO];

                [self checkTemperatureInput:_temperatureMin];
                [self checkTemperatureInput:_temperatureMax];
            }
            else
            {
                // temperature is selected
                [_minPressureField setHidden:NO];
                [_temperatureMin setHidden:YES];

                [self checkPressureInput:_minPressureField];
                [self checkPressureInput:_pressureField];
            }
        }
    }
    else
    {
        [self checkTemperatureInput:_temperatureMin];
        [self checkTemperatureInput:_temperatureMax];
    }
}

- (IBAction)clickedSpecieButton:(id)sender {
    
    _selectedComponent0 = [_picker selectedRowInComponent:0];
    _selectedComponent1 = [_picker selectedRowInComponent:1];
    
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

    if ([species count])
    {
        _currentSpeciesName = [species objectAtIndex:i0];

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
    // reset the picker
    [_picker reloadComponent:0];
    [_picker selectRow:_selectedComponent0 inComponent:0 animated:NO];
    [_picker reloadComponent:1];
    [_picker selectRow:_selectedComponent1 inComponent:1 animated:NO];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];

    //[self update];

}

-(void) update
{
    NSArray *species = self.db.orderedSpecies;
    NSString *speciesText = [[NSString alloc] init];
    NSString *propertiesText = @"No database loaded";
    NSString *unitText = @"";
    
    [_pressureField setPlaceholder:@"max"];
    [_temperatureMax setPlaceholder:@"max"];
    _pressureDependent = NO;
    
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
            
            id<functionValue> f;
            if (functionClass != nil) {
                f = [[functionClass alloc] initWithZero];
            }
            else
            {
                NSLog(@"%@ is an illegal function. Abort!",functionName);
                //abort();
                
            }
                        
            if ([f pressureDependent])
            {
                _pressureDependent = YES;

                if ([f temperatureDependent])
                {
                    _selectedConstantProperty = [_ptSegmentControl selectedSegmentIndex];
                    //[_ptSegmentControl setSelectedSegmentIndex:_selectedConstantProperty];
                    [self checkPressureInput:_pressureField];
                    [self checkPressureInput:_minPressureField];

                    [_constantTextLabel setHidden:NO];
                    [_ptSegmentControl setHidden:NO];
                    
                    [_pressureField setHidden:NO];
                    [_temperatureMax setHidden:NO];
                    [_pressureField setEnabled:YES];
                    [_temperatureMax setEnabled:YES];
                    // pressure is constant
                    if (_selectedConstantProperty == 0)
                    {
                        [_minPressureField setHidden:YES];
                        [_temperatureMin setHidden:NO];
                    }
                    else
                    {
                        [_minPressureField setHidden:NO];
                        [_temperatureMin setHidden:YES];
                    }

                }
                else
                {
                    _selectedConstantProperty = 1;
                    [_constantTextLabel setHidden:YES];
                    [_ptSegmentControl setHidden:YES];
                    [_minPressureField setHidden:NO];
                    [_pressureField setHidden:NO];
                    [_pressureField setEnabled:YES];
                    [_temperatureMin setHidden:YES];
                    [_temperatureMax setHidden:NO];
                    
                    [_temperatureMax setText:@""];
                    [_temperatureMax setPlaceholder:@"not used"];
                    [_temperatureMax setEnabled:NO];
                }
            }
            else
            {
                _selectedConstantProperty = 0;
                [_constantTextLabel setHidden:YES];
                [_ptSegmentControl setHidden:YES];
                [_minPressureField setHidden:YES];
                [_pressureField setHidden:NO];
                [_temperatureMin setHidden:NO];
                [_temperatureMax setHidden:NO];
                [_temperatureMax setEnabled:YES];

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

    [self checkTemperatureInput:_temperatureMax];
    [self checkTemperatureInput:_temperatureMin];
    [self checkPressureInput:_minPressureField];
    [self checkPressureInput:_pressureField];
    
    [_picker reloadComponent:0];
    [_picker selectRow:index0 inComponent:0 animated:NO];
    [_picker reloadComponent:1];
    [_picker selectRow:index1 inComponent:1 animated:NO];
    
    // check if selected function fulfills requirements
    NSDictionary *propertiesDict = [self.db.json objectForKey:_currentSpeciesName];
    NSDictionary *propDict = [propertiesDict objectForKey:_currentPropertyName];
    
    NSString *funcName = [propDict objectForKey:@"function"];
    NSArray *coeffDictArray = [propDict objectForKey:@"coefficients"];
    
    _function = [_selector select:funcName withArray:coeffDictArray];
    if (_function != nil)
    {
        [self checkFunctionDependency:_function forDict:propertiesDict];

        BOOL fulfilled = [_function requirementsFulfilled];
        [_viewButton setEnabled:fulfilled];
    }
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    UIImage *bgImage = [UIImage imageNamed:@"backGroundGradient.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
    
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
    
    _temperatureMin.text = [defaults objectForKey:@"minTemp"];
    _temperatureMax.text = [defaults objectForKey:@"maxTemp"];
    _minPressureField.text = [defaults objectForKey:@"minPressure"];
    _pressureField.text = [defaults objectForKey:@"maxPressure"];
    NSNumber *scp = [defaults objectForKey:@"constProperty"];
    _selectedConstantProperty = [scp intValue];
    
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

    polymorphAppDelegate *appDelegate = (polymorphAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.pvc = self;
    
    [self update];
    //[self convertDatabaseToNewFormat:_db.json];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)saveUI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_link forKey:@"link"];
    [defaults setObject:_currentSpeciesName forKey:@"currentSpeciesName"];
    [defaults setObject:_currentPropertyName forKey:@"currentPropertyName"];
    
    [defaults setObject:_temperatureMin.text forKey:@"minTemp"];
    [defaults setObject:_temperatureMax.text forKey:@"maxTemp"];
    [defaults setObject:_minPressureField.text forKey:@"minPressure"];
    [defaults setObject:_pressureField.text forKey:@"maxPressure"];
    NSNumber *scp = [[NSNumber alloc] initWithInt:_selectedConstantProperty];
    [defaults setObject:scp forKey:@"constProperty"];
    
    [defaults synchronize];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    /*
    [defaults setObject:_link forKey:@"link"];
    [defaults setObject:_currentSpeciesName forKey:@"currentSpeciesName"];
    [defaults setObject:_currentPropertyName forKey:@"currentPropertyName"];
     */
    
    [self saveUI];
    [defaults setObject:_db.json forKey:@"database"];
    
    [defaults synchronize];
}

- (void)viewDidUnload
{
    
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
/*
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
*/

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

-(void)checkFunctionDependency:(id<functionValue>)f forDict:(NSDictionary *)dict
{
    NSArray *funcDepNames = [f dependsOnFunctions];
    
    if (funcDepNames != nil)
    {
        NSArray *availableProperties = [dict allKeys];
        int n = [funcDepNames count];
        for (int i=0; i<n; i++)
        {
            NSString *name = [funcDepNames objectAtIndex:i];
            if (![availableProperties containsObject:name])
            {
                NSLog(@"You need to implement %@ first",name);
            }
            else
            {
                NSDictionary *pDict = [dict objectForKey:name];
                NSString *fdName = [pDict objectForKey:@"function"];
                NSArray *cArray = [pDict objectForKey:@"coefficients"];
                
                id<functionValue> fd = [_selector select:fdName withArray:cArray];
                [f setFunction:fd forKey:name];
                [self checkFunctionDependency:fd forDict:dict];
            }
        }
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
        [self checkFunctionDependency:_function forDict:propertiesDict];
        
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

// only to be used once, when converting to the new coefficient standard
-(void)convertDatabaseToNewFormat:(NSMutableDictionary *)dict
{
    //NSLog(@"%@",dict);
    functions *mySel = [[functions alloc] init];

    NSArray *species = [dict allKeys];
    for (int i=0; i<[species count]; i++)
    {
        NSMutableDictionary *speciesDict = [dict objectForKey:[species objectAtIndex:i]];
        NSArray *propertyNames = [speciesDict allKeys];
        for (int j=0; j<[propertyNames count]; j++)
        {
            NSMutableDictionary *propDict = [speciesDict objectForKey:[propertyNames objectAtIndex:j]];
            
            NSString *functionName = [propDict objectForKey:@"function"];
            id function = [mySel select:functionName];
            NSArray *coefficients = [propDict objectForKey:@"coefficients"];
            int nCoeffs = [coefficients count];
            NSArray *newCoefficientNames = [function coefficientNames];
            for (int k=0; k<nCoeffs; k++)
            {
                NSString *oldName = [[NSString alloc] initWithFormat:@"A%d",k];
                NSString *newName = [newCoefficientNames objectAtIndex:k];
                NSMutableDictionary *cDict = [coefficients objectAtIndex:k];
                NSArray *cDictEntries = [cDict allKeys];
                if ([cDictEntries containsObject:oldName])
                {
                    NSNumber *num = [cDict objectForKey:oldName];
                    NSDictionary *newDict = @{newName : num};

                    [cDict removeObjectForKey:oldName];
                    [cDict addEntriesFromDictionary:newDict];
                }
            }
            
        }
    }
    //NSLog(@"%@",dict);
}

@end
