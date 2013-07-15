//
//  colorSettingsViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "colorSettingsViewController.h"
#import "QuartzCore/QuartzCore.h"

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


- (id)init
{
    NSLog(@"colorSettingsViewController init");
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"colorSettingsViewController initWithNibName");
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

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.colorView.backgroundColor = color;
}

- (IBAction)redSliderChanged:(UISlider *)sender
{
    self.color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];

    CAGradientLayer *layer = [CAGradientLayer layer];
    CGRect bounds = self.redGradientView.bounds;
    //CGFloat width = bounds.size.width;
    CGPoint x0 = CGPointMake(0.0, 0.0);
    CGPoint x1 = CGPointMake(1.0, 0.0);
    layer.frame = bounds;
    CGFloat green = self.greenSlider.value/255.0;
    CGFloat blue = self.blueSlider.value/255.0;
    
    UIColor *left = [UIColor colorWithRed:0.0 green:green blue:blue alpha:1.0];
    UIColor *right = [UIColor colorWithRed:1.0 green:green blue:blue alpha:1.0];
    
    NSArray *colors = @[ (id)left.CGColor, (id)right.CGColor ];
    layer.colors = colors;
    // points are normalized and then mapped to the rect so range is 0,0 -> 1,1
    layer.startPoint = x0;
    layer.endPoint = x1; 
    
    self.redTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    int nLayers = [self.redGradientView.subviews count];
    NSLog(@"nLayers = %d",nLayers);

    [self.redGradientView.layer insertSublayer:layer atIndex:0];

}

- (IBAction)greenSliderChanged:(UISlider *)sender
{
    self.greenTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
}

- (IBAction)blueSliderChanged:(UISlider *)sender
{
    self.blueTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
}
@end
