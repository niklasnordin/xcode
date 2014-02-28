//
//  AddGroupMembersViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "AddGroupMembersViewController.h"
#import "optionsPickerViewDelegate.h"
#import "searchGroupMembersViewController.h"
#import "UserObject.h"

@interface AddGroupMembersViewController ()
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@property (weak, nonatomic) IBOutlet UILabel *optionsLabel;
- (IBAction)feedButtonClicked:(id)sender;
- (IBAction)optionsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) JMPickerView *picker;
@property (strong, nonatomic) optionsPickerViewDelegate *optionsPVDelegate;
@end

@implementation AddGroupMembersViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    
    
    NSString *name = [self.database.socialMediaNames objectAtIndex:self.database.selectedMediaNameIndex];
    self.picker = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self withDistanceToTop:65.0f];
    [self.picker hide:-1.0f];
    [self.feedButton setTitle:name forState:UIControlStateNormal];
    [self.picker selectRow:self.database.selectedMediaNameIndex inComponent:0 animated:NO];
    
    self.optionsPVDelegate = [[optionsPickerViewDelegate alloc] init];
    [self.optionsPVDelegate setDatabase:self.database];
    self.optionsPVDelegate.delegate = self;
    self.optionsPicker = [[JMPickerView alloc] initWithDelegate:self.optionsPVDelegate addingToViewController:self withDistanceToTop:65.0f];
    [self.optionsPicker hide:-1.0f];
    //[self.optionsPicker setBackgroundColor:[UIColor lightGrayColor]];
    [self.optionsButton setTitle:[self.database.facebookSearchOptions objectAtIndex:self.database.selectedOptionIndex] forState:UIControlStateNormal];

    [self setSecondary];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)editTable
{
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditTable)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [self.tableView setEditing:YES animated:YES];
    
}

- (void)doneEditTable
{
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    [self.tableView setEditing:NO animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"memberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UserObject *user = [self.groupMembers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.imageView.image = [UIImage imageWithData:user.imageData];
    
    return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.groupMembers removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView reloadData];
        //[self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark -
#pragma mark Standard UIPickerView data source and delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.database.socialMediaNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.database.socialMediaNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.database.selectedMediaNameIndex = row;
    [self.feedButton setTitle:[self.database.socialMediaNames objectAtIndex:row] forState:UIControlStateNormal];
    
    // facebook is the first entry in the mediaNames
    [self setSecondary];
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
    [self.picker hide:0.3f];
}

- (IBAction)feedButtonClicked:(id)sender
{
    [self.picker show:0.3f];
}

- (IBAction)optionsButtonClicked:(id)sender
{
    [self.optionsPicker show:0.3f];

}

- (void)setSecondary
{
    if (self.database.selectedMediaNameIndex == kFacebook)
    {
        [self.optionsLabel setEnabled:YES];
        [self.optionsLabel setAlpha:1.0f];
        
        [self.optionsButton setEnabled:YES];
        [self.optionsButton setAlpha:1.0f];
    }
    else
    {
        [self.optionsLabel setEnabled:NO];
        [self.optionsLabel setAlpha:0.0f];
        
        [self.optionsButton setEnabled:NO];
        [self.optionsButton setAlpha:0.0f];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchMembersSegue"])
    {
        // set title
        searchGroupMembersViewController *vc = (searchGroupMembersViewController *)segue.destinationViewController;
        //NSLog(@"going...");
        //self.database.selectedMediaNameIndex = row;

        NSString *feedName = [self.database.socialMediaNames objectAtIndex:self.database.selectedMediaNameIndex];
        NSString *title = [NSString stringWithFormat:@"Search %@",feedName];
        [vc setTitle:title];
        [vc setDatabase:self.database];
        [vc setMembersTableView:self.tableView];
        [vc setGroupMembers:self.groupMembers];
        switch (self.database.selectedMediaNameIndex) {
            case kFacebook:
                [vc setMinStringLength:2];
                break;
            case kTwitter:
                [vc setMinStringLength:0];
                break;
            case kInstagram:
                [vc setMinStringLength:2];
                break;
            default:
                break;
        }
        //[vc setMinStringLength:2];
        [vc setSearchFeed:feedName];
    }
}

- (void)updateOptionsForRow:(NSInteger)row
{
    // this is set in the optionsPicker delegate
    //self.database.selectedOptionIndex = row;
    [self.optionsButton setTitle:[self.database.facebookSearchOptions objectAtIndex:row] forState:UIControlStateNormal];
}


@end
