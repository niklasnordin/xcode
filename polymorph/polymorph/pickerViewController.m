//
//  pickerViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2015-07-15.
//  Copyright (c) 2015 nequam. All rights reserved.
//

#import "pickerViewController.h"

@interface pickerViewController ()

@end

@implementation pickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selected = [[NSMutableArray alloc] initWithCapacity:self.numberOfComponents];
    //NSLog(@"pickerViewController viewDidLoad");
    //NSLog(@"number of components = %ld",(long)self.numberOfComponents);
    NSLog(@"pickerList = %@",self.pickerList);
    NSLog(@"pickerSubLists = %@",self.pickerSubLists);
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.picker reloadAllComponents];
    self.picker.showsSelectionIndicator = true;
}

/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //NSLog(@"number of components = %ld",(long)self.numberOfComponents);
    return self.numberOfComponents;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"pickerView: numberOfRowsInComponent: %ld",component);
    //NSLog(@"pickerList = %@",self.pickerList);
    NSInteger num = 0;

    if (component == 0)
    {
        // no need to change the number of rows
        num = self.pickerList.count;
        //NSLog(@"pickerList count = %ld",num);
    }
    else
    {
        NSInteger idx = [self.picker selectedRowInComponent:0];

        NSArray *list = [self.pickerSubLists objectAtIndex:idx];
        if (list)
            num = list.count;
    }

    //NSLog(@"pickerView: numberOfRowsInComponent: %ld, num:%ld",component,num);

    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name = @"";
    //NSLog(@"pickerView titleForRow: %ld",row);
    //NSLog(@"pickerView titleForComponent: %ld",component);
    
    if ([self.pickerList count])
    {
        if (component == 0)
        {
            if (row < self.pickerList.count)
                name = [self.pickerList objectAtIndex:row];
        }
        else
        {
            //NSLog(@"not here: component = %ld",component);
            NSInteger previousSelectedIndex = component-1;

            NSInteger idx = (int)[self.picker selectedRowInComponent:previousSelectedIndex];
            NSArray *list = [self.pickerSubLists objectAtIndex:idx];
            name = [list objectAtIndex:row];
        }
    }

    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [self.picker reloadAllComponents];
/*
        if (self.pickerSubLists.count)
        {
            [pickerView reloadComponent:1];
        }
 */
    }
}

- (IBAction)buttonOKPressed:(id)sender
{
    NSLog(@"OK Pressed");
}

- (IBAction)buttonCancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
