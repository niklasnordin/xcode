//
//  optionsPickerViewDelegate.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-11.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "AddGroupMembersViewController.h"
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
    return [self.database.facebookSearchOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.database.facebookSearchOptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.database.selectedOptionIndex = row;
    //groupViewController *vc = (groupViewController *)self.delegate;
    AddGroupMembersViewController *vc = (AddGroupMembersViewController *)self.delegate;
    [vc updateOptionsForRow:row];
    //[vc.optionsButton setTitle:[self.database.facebookSearchOptions objectAtIndex:row] forState:UIControlStateNormal];
}

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
    
    //groupViewController *vc = (groupViewController *)self.delegate;
    AddGroupMembersViewController *vc = (AddGroupMembersViewController *)self.delegate;

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
