//
//  schemeViewController.m
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 6/26/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import "schemeViewController.h"
#import "schemeCollectionCell.h"
#import "eventViewController.h"

@interface schemeViewController ()

@property (strong, nonatomic) NSNumber *segueToEventNr;

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

    _numEventsStepperValue.value = [numEvents intValue];
    _numEventsLabel.text = [NSString stringWithFormat:@"Number of Events:%d",(int)self.numEventsStepperValue.value];
    _eventIsSet = [_schemeDictionary objectForKey:@"eventIsSet"];
    
    if ([self.schemeDictionary objectForKey:@"calendarName"])
    {
        self.calendarNameTextField.text = [self.schemeDictionary objectForKey:@"calendarName"];
    }
    else
    {
        self.calendarNameTextField.text = @"My Work Calendar";
    }
    
    _segueToEventNr = [[NSNumber alloc] initWithInt:-1];
    
    self.calendarNameTextField.delegate = self;
    self.schemeCollectionView.delegate = self;
    self.schemeCollectionView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"and im back from %d", [self.segueToEventNr intValue] + 1);
    int index = [self.segueToEventNr intValue];
    
    if (index >= 0)
    {
        //[self.eventIsSet setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:index];
        // check if all titles are set
        NSMutableArray *events = [self.schemeDictionary objectForKey:@"eventDictionaries"];
        NSMutableDictionary *eventDict = [events objectAtIndex:index];

        NSString *title = [eventDict objectForKey:@"title"];

        bool titleIsSet = ![title isEqualToString:@""];
        [self.eventIsSet setObject:[NSNumber numberWithBool:titleIsSet] atIndexedSubscript:index];
        
    }
    [self.schemeCollectionView reloadData];
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
    if (value > [self.eventIsSet count])
    {
        [self.eventIsSet addObject:[NSNumber numberWithBool:NO]];
        NSMutableDictionary *dict = [self.stvc defaultEventDictionary];
        NSMutableArray *eventDictionaries = [self.schemeDictionary objectForKey:@"eventDictionaries"];
        [eventDictionaries addObject:dict];
    }
    else
    {
        [self.eventIsSet removeLastObject];
    }
    
    [self.schemeCollectionView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.schemeDictionary setObject:[self.calendarNameTextField text] forKey:@"calendarName"];
    [textField resignFirstResponder];

    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    schemeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"schemeCellID" forIndexPath:indexPath];
        
    NSString *id = [NSString stringWithFormat:@"%d",indexPath.item+1];
    [cell.idButton setId:[NSNumber numberWithInt:indexPath.item]];
    
    [cell.idButton setTitle:id forState:UIControlStateHighlighted];
    [cell.idButton setTitle:id forState:UIControlStateNormal];
    if ([[self.eventIsSet objectAtIndex:indexPath.item] boolValue])
    {
        [cell.idButton setBackgroundColor:[UIColor greenColor]];
    }
    else
    {
        [cell.idButton setBackgroundColor:[UIColor redColor]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)[self.numEventsStepperValue value];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([segue.identifier isEqualToString:@"eventSegue"])
    {
        eventViewController *evc = (eventViewController *)segue.destinationViewController;
        
        idButton *button = sender;
        self.segueToEventNr  = [button id];
        int index = [[button id] intValue];
        [evc setTitle:[NSString stringWithFormat:@"Event %@", button.titleLabel.text]];
        NSMutableArray *events = [self.schemeDictionary objectForKey:@"eventDictionaries"];
        NSMutableDictionary *eventDict = [events objectAtIndex:index];
        [evc setEventDict:eventDict];
    }
}

@end
