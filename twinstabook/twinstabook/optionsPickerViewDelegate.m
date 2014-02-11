//
//  optionsPickerViewDelegate.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-11.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "groupViewController.h"
#import "optionsPickerViewDelegate.h"

@implementation optionsPickerViewDelegate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark -
#pragma mark Standard UIPickerView data source and delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"tap tap";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected");
}

#pragma mark -
#pragma mark JMPickerView delegate methods

- (void)pickerViewWasHidden:(JMPickerView *)pickerView
{
    //NSLog(@"picker hidden");
}

- (void)pickerViewWasShown:(JMPickerView *)pickerView
{
    //NSLog(@"picker is shown");
}

- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView
{
    //NSLog(@"picker indicator tapped");
    
    groupViewController *vc = (groupViewController *)self.delegate;
    [vc.optionsPicker hide:0.3f];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
