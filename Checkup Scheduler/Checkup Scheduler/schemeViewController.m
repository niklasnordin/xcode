//
//  schemeViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/26/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "schemeViewController.h"
#import "schemeCollectionCell.h"

@interface schemeViewController ()

@end

@implementation schemeViewController

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
    NSNumber *numEvents = [self.schemeDictionary objectForKey:@"numEvents"];

    self.numEventsStepperValue.value = [numEvents intValue];
    self.numEventsLabel.text = [NSString stringWithFormat:@"Number of Events:%d",(int)self.numEventsStepperValue.value];
    
    if ([self.schemeDictionary objectForKey:@"calendarName"])
    {
        self.calendarNameTextField.text = [self.schemeDictionary objectForKey:@"calendarName"];
    }
    else
    {
        self.calendarNameTextField.text = @"My Work Calendar";
    }
    
    self.calendarNameTextField.delegate = self;

    self.schemeCollectionView.delegate = self;
    self.schemeCollectionView.dataSource = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the text field when leaving this page 
    [self.schemeDictionary setObject:[self.calendarNameTextField text] forKey:@"calendarName"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numEventsStepperPressed:(UIStepper *)sender
{
    int value = sender.value;
    [self.schemeDictionary setObject:[NSNumber numberWithInt:value] forKey:@"numEvents"];
    
    self.numEventsLabel.text = [NSString stringWithFormat:@"Number of Events:%d",value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"hello, text = %@",[self.calendarNameTextField text]);
    
    [self.schemeDictionary setObject:[self.calendarNameTextField text] forKey:@"calendarName"];
    [textField resignFirstResponder];

    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    schemeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"schemeCellID" forIndexPath:indexPath];
    
    NSString *id = [NSString stringWithFormat:@"%d",indexPath.item+1];
    cell.idLabel.text = id;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

@end
