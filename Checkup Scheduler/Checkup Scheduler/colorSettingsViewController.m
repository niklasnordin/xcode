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
@property (strong, nonatomic) CAGradientLayer *redGradientLayer;
@property (strong, nonatomic) CAGradientLayer *greenGradientLayer;
@property (strong, nonatomic) CAGradientLayer *blueGradientLayer;

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
    
    _redGradientLayer = [CAGradientLayer layer];
    _greenGradientLayer = [CAGradientLayer layer];
    _blueGradientLayer = [CAGradientLayer layer];

    CGFloat red, green, blue, alpha;
    bool couldConvert = [_color getRed:&red green:&green blue:&blue alpha:&alpha];
    if (!couldConvert)
    {
        NSLog(@"could not convert color space");
    }
    self.redSlider.value = red*255.0;
    self.greenSlider.value = green*255.0;
    self.blueSlider.value = blue*255.0;
    self.redTextField.text = [NSString stringWithFormat:@"%.0f", self.redSlider.value];
    self.greenTextField.text = [NSString stringWithFormat:@"%.0f", self.greenSlider.value];
    self.blueTextField.text = [NSString stringWithFormat:@"%.0f", self.blueSlider.value];

}

- (void)viewDidAppear:(BOOL)animated
{
    CGPoint x0 = CGPointMake(0.0, 0.0);
    CGPoint x1 = CGPointMake(1.0, 0.0);
    CGFloat red = self.redSlider.value/255.0;
    CGFloat green = self.greenSlider.value/255.0;
    CGFloat blue = self.blueSlider.value/255.0;
    
    CGRect redBounds = self.redGradientView.bounds;
    self.redGradientLayer.frame = redBounds;
    CGRect greenBounds = self.greenGradientView.bounds;
    self.greenGradientLayer.frame = greenBounds;
    CGRect blueBounds = self.blueGradientView.bounds;
    self.blueGradientLayer.frame = blueBounds;

    UIColor *redLeft = [UIColor colorWithRed:0.0 green:green blue:blue alpha:1.0];
    UIColor *redRight = [UIColor colorWithRed:1.0 green:green blue:blue alpha:1.0];
    NSArray *redColors = @[ (id)redLeft.CGColor, (id)redRight.CGColor ];
    
    UIColor *greenLeft = [UIColor colorWithRed:red green:0.0 blue:blue alpha:1.0];
    UIColor *greenRight = [UIColor colorWithRed:red green:1.0 blue:blue alpha:1.0];
    NSArray *greenColors = @[ (id)greenLeft.CGColor, (id)greenRight.CGColor ];

    UIColor *blueLeft = [UIColor colorWithRed:red green:green blue:0.0 alpha:1.0];
    UIColor *blueRight = [UIColor colorWithRed:red green:green blue:1.0 alpha:1.0];
    NSArray *blueColors = @[ (id)blueLeft.CGColor, (id)blueRight.CGColor ];

    self.redGradientLayer.colors = redColors;
    self.greenGradientLayer.colors = greenColors;
    self.blueGradientLayer.colors = blueColors;
    
    // points are normalized and then mapped to the rect so range is 0,0 -> 1,1
    self.redGradientLayer.startPoint = x0;
    self.redGradientLayer.endPoint = x1;
    [self.redGradientView.layer insertSublayer:self.redGradientLayer atIndex:0];

    self.greenGradientLayer.startPoint = x0;
    self.greenGradientLayer.endPoint = x1;
    [self.greenGradientView.layer insertSublayer:self.greenGradientLayer atIndex:0];

    self.blueGradientLayer.startPoint = x0;
    self.blueGradientLayer.endPoint = x1;
    [self.blueGradientView.layer insertSublayer:self.blueGradientLayer atIndex:0];

    self.colorView.backgroundColor = self.color;

}

-(void)updateGradientLayers
{

    CGFloat red = self.redSlider.value/255.0;
    CGFloat green = self.greenSlider.value/255.0;
    CGFloat blue = self.blueSlider.value/255.0;
    
    UIColor *redLeft = [UIColor colorWithRed:0.0 green:green blue:blue alpha:1.0];
    UIColor *redRight = [UIColor colorWithRed:1.0 green:green blue:blue alpha:1.0];
    NSArray *redColors = @[ (id)redLeft.CGColor, (id)redRight.CGColor ];

    UIColor *greenLeft = [UIColor colorWithRed:red green:0.0 blue:blue alpha:1.0];
    UIColor *greenRight = [UIColor colorWithRed:red green:1.0 blue:blue alpha:1.0];
    NSArray *greenColors = @[ (id)greenLeft.CGColor, (id)greenRight.CGColor ];
    
    UIColor *blueLeft = [UIColor colorWithRed:red green:green blue:0.0 alpha:1.0];
    UIColor *blueRight = [UIColor colorWithRed:red green:green blue:1.0 alpha:1.0];
    NSArray *blueColors = @[ (id)blueLeft.CGColor, (id)blueRight.CGColor ];

    self.redGradientLayer.colors = redColors;
    self.greenGradientLayer.colors = greenColors;
    self.blueGradientLayer.colors = blueColors;
    
    //[self.redGradientView setNeedsDisplay];
   
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
    self.redTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    [self updateGradientLayers];
}

- (IBAction)greenSliderChanged:(UISlider *)sender
{
    self.greenTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    [self updateGradientLayers];

}

- (IBAction)blueSliderChanged:(UISlider *)sender
{
    self.blueTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
    self.color = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0];
    [self updateGradientLayers];

}
@end
