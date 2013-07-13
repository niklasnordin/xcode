//
//  colorSettingsViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "colorSettingsViewController.h"

@interface colorSettingsViewController ()

@end

@implementation colorSettingsViewController


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    float red = [self.redTextField.text floatValue];
    float blue = [self.blueTextField.text floatValue];
    float green = [self.greenTextField.text floatValue];
    [self.redSlider setValue:red];
    [self.greenSlider setValue:green];
    [self.blueSlider setValue:blue];
    
    [textField resignFirstResponder];
    return YES;
}

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
    
    _redTextField.text = [NSString stringWithFormat:@"%.0f", _redSlider.value];
    _greenTextField.text = [NSString stringWithFormat:@"%.0f", _greenSlider.value];
    _blueTextField.text = [NSString stringWithFormat:@"%.0f", _blueSlider.value];
    
    _redTextField.delegate = self;
    _greenTextField.delegate = self;
    _blueTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    NSLog(@"col = %@",backgroundColor);
}

- (IBAction)redSliderChanged:(UISlider *)sender
{
    self.redTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.backgroundColor = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
}

- (IBAction)greenSliderChanged:(UISlider *)sender
{
    self.greenTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.backgroundColor = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
}

- (IBAction)blueSliderChanged:(UISlider *)sender
{
    self.blueTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.backgroundColor = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
}
@end
