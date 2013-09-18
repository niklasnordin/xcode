//
//  testControllerViewController.m
//  testController
//
//  Created by Niklas Nordin on 2013-09-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "testControllerViewController.h"

@interface testControllerViewController ()
@property (strong,nonatomic) UIPickerView *picker;

@end

@implementation testControllerViewController

- (void)setup
{
    CGRect pickerFrame = CGRectMake(8, 52, 304, 0);
    _picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    _picker.backgroundColor = [UIColor greenColor];
    //_picker.opaque = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"view did load");
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UIPickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 30;
}

// UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected row %d, in component %d",row,component);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"titleFoRow %d",row];
}

- (IBAction)buttonPressed:(id)sender
{
    NSLog(@"button pressed");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"hello darling"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    
    //[sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    //[sheet setOpaque:YES];
    //[sheet setBackgroundColor:[UIColor redColor]];

    [sheet addSubview:self.picker];
    [sheet showInView:self.view];
    [sheet setBounds:CGRectMake(0.0f, 0.0f, 320.0f, 485.0f)];

    
}
@end
