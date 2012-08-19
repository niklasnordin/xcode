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
@property (nonatomic) int currentRow;
@property (nonatomic) int currentProperty;

@property (strong,nonatomic) functions *selector;
@end

@implementation polymorphViewController

-(void)checkPressureInput:(UITextField *)sender {
    
    NSArray *species = _db.species;
    NSString *selectedSpecie = [species objectAtIndex:self.currentRow];
    NSDictionary *propertiesDict = [_db.json objectForKey:selectedSpecie];
    NSArray *properties = [propertiesDict allKeys];
    NSString *selectedProperty = [properties objectAtIndex:self.currentProperty];
    NSDictionary *propDict = [propertiesDict objectForKey:selectedProperty];
    
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

- (IBAction)clickedSelect:(id)sender {
    
}

- (IBAction)clickedSpecieButton:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Properties" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet setOpaque:YES];
    [self.actionSheet addSubview:self.picker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:closeButton];
    
    //[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}


- (void)dismissActionSheet:(id)sender
{

    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self update];
}


-(void) update
{
    
    NSArray *species = self.db.species;
    NSString *speciesText = @"";
    NSString *propertiesText = @"No database loaded";
    NSString *unitText = @"";
    
    [_pressureField setPlaceholder:@"pressure"];

    if ([species count])
    {
        if (_currentRow >= [species count])
        {
            _currentRow = 0;
        }
        speciesText = [species objectAtIndex:self.currentRow];
        NSDictionary *propertiesDict = [self.db.json objectForKey:speciesText];
        
        if ([propertiesDict count])
        {
            NSArray *properties = [propertiesDict allKeys];
            if (_currentProperty >= [properties count])
            {
                _currentProperty = 0;
            }
            propertiesText = [properties objectAtIndex:self.currentProperty];
            
            [_viewButton setEnabled:YES];
            
            NSDictionary *propertyDict = [propertiesDict objectForKey:propertiesText];
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
    _propertyDisplay.text = [NSString stringWithFormat:@"%@ [%@]", propertiesText, unitText];

    [_picker reloadAllComponents];

}

- (void)viewDidLoad
{

    [super viewDidLoad];
    _temperatureMin.delegate = self;
    _temperatureMax.delegate = self;
    _pressureField.delegate = self;
    
    // load the database and initiate it
    _selector = [[functions alloc] init];
    _db = [[database alloc] init];
    //_db.json = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _db.json = [defaults objectForKey:@"database"];
    if (!_db.json)
    {
        //NSLog(@"No database");
        _db.json = [[NSMutableDictionary alloc] init];
    }
    _link = [defaults objectForKey:@"link"];
    //NSNumber *row = [defaults objectForKey:@"currentRow"];
    //NSNumber *prop = [defaults objectForKey:@"currentProperty"];

    _currentRow = 0;
    _currentProperty = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
    
    _functionNames = [[NSMutableArray alloc] init];
    [_functionNames addObject:[function_0001 name]];
    [_functionNames addObject:[function_0002 name]];
    [_functionNames addObject:[nsrds_0 name]];
    [_functionNames addObject:[nsrds_1 name]];
    [_functionNames addObject:[nsrds_5 name]];
    
    [_functionNames addObject:[janaf_cp name]];
    [_functionNames addObject:[janaf_h name]];
    [_functionNames addObject:[janaf_s name]];
    [_functionNames addObject:[idealGasLaw name]];
    [_functionNames addObject:[pengRobinsonLow name]];
    [_functionNames addObject:[pengRobinsonHigh name]];
     
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    self.picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.picker.showsSelectionIndicator = YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    
    [self update];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_link forKey:@"link"];
    [defaults synchronize];
    
    [self setPicker:nil];
    [self setTemperatureMin:nil];
    [self setTemperatureMax:nil];
    [self setPropertyDisplay:nil];
    [self setPressureField:nil];
    [self setSpeciesButton:nil];
    [self setViewButton:nil];
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
    NSArray *species = self.db.species;
    if (component == 0)
    {
        num = [species count];
    }
    else
    {
        if ([species count])
        {
            NSInteger i = [pickerView selectedRowInComponent:0];
            NSDictionary *propertiesDict = [self.db.json objectForKey:[species objectAtIndex:i]];
            if ([propertiesDict count])
            {
                NSArray *properties = [propertiesDict allKeys];
                num = [properties count];
            }
        }
    }
    return num;
}

// returns width of column and height of row for each component. 
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name = @"";
    NSArray *species = self.db.species;

    if (component == 0)
    {
        if ([species count])
            name = [species objectAtIndex:row];
    }
    else
    {
        if ([species count])
        {
            NSInteger i = [pickerView selectedRowInComponent:0];
            NSDictionary *propertiesDict = [self.db.json objectForKey:[species objectAtIndex:i]];
            if ([propertiesDict count])
            {
                NSArray *properties = [propertiesDict allKeys];
                name = [properties objectAtIndex:row];
            }
        }
    }
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 
    if (self.currentRow != [pickerView selectedRowInComponent:0])
    {
        [pickerView reloadComponent:1];
    }
    self.currentRow = [pickerView selectedRowInComponent:0];
    self.currentProperty = [pickerView selectedRowInComponent:1];
    
    NSArray *species = self.db.species;
    if ([species count])
    {
        NSDictionary *propertiesDict = [self.db.json objectForKey:[species objectAtIndex:self.currentRow]];
        if ([propertiesDict count])
        {
            NSArray *properties = [propertiesDict allKeys];
            self.propertyDisplay.text = [properties objectAtIndex:self.currentProperty];
            _viewButton.enabled = YES;
        }
        else
        {
            self.propertyDisplay.text = @"";
            _viewButton.enabled = NO;
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
        double p = [self.pressureField.text doubleValue];
        
        NSArray *species = self.db.species;
        NSString *selectedSpecie = [species objectAtIndex:self.currentRow];
        NSDictionary *propertiesDict = [self.db.json objectForKey:selectedSpecie];
        NSArray *properties = [propertiesDict allKeys];
        NSString *selectedProperty = [properties objectAtIndex:self.currentProperty];
        NSDictionary *propDict = [propertiesDict objectForKey:selectedProperty];

        NSString *funcName = [propDict objectForKey:@"function"];

        _function = [_selector select:funcName];
    
        [segue.destinationViewController setSpecie:selectedSpecie];
        [segue.destinationViewController setProperty:selectedProperty];
        
        [segue.destinationViewController setup:_function
                                          dict:propDict
                                           min:tMin
                                           max:tMax
                                      pressure:p];
        
        NSString *title = [NSString stringWithFormat:@"%@, %@",selectedSpecie, selectedProperty];
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
