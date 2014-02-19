//
//  MenuTableViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-18.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "MenuTableViewController.h"
#import "twinstabookFirstViewController.h"
#import "firstViewController.h"
#import "FacebookSettingsViewController.h"
#import "twitterSettingsViewController.h"
#import "instagramSettingsViewController.h"

@interface MenuTableViewController ()

@end

@implementation SWUITableViewCell
@end

@implementation MenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    switch ( indexPath.row )
    {
        case 1:
            CellIdentifier = @"Feed";
            break;
            
        case 2:
            CellIdentifier = @"Facebook";
            break;
            
        case 3:
            CellIdentifier = @"Twitter";
            break;
            
        case 4:
            CellIdentifier = @"Instagram";
            break;
            
        case 5:
            CellIdentifier = @"Settings";
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id) sender
{
    SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
    SWRevealViewController* rvc = self.revealViewController;
/*
    NSLog(@"segue class = %@",[segue class]);
    NSLog(@"frontViewController = %@",[rvc.frontViewController class]);
    NSLog(@"rearViewController = %@",[rvc.rearViewController class]);
    NSLog(@"revealViewController = %@",[rvc.revealViewController class]);
    NSLog(@"destination = %@",[segue.destinationViewController class]);
    */
    // configure the destination view controller:
    if ( [segue.destinationViewController isKindOfClass: [twinstabookFirstViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]] )
    {
 
        // if feed already is frontview, just slide it in
        if ([rvc.frontViewController isKindOfClass:[firstViewController class]])
        {
            NSLog(@"nu skall vi tillbaka till feed från main...");
            rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
            {
                [rvc setFrontViewController:rvc.frontViewController animated:YES];
            };
        }
        

        //[self performSegueWithIdentifier:@"Feed" sender:sender];

    }
    
    NSLog(@"destination class = %@",[segue.destinationViewController class]);
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        NSLog(@"tjolahopp");
        //SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        if ([segue.destinationViewController isKindOfClass:[FacebookSettingsViewController class]])
        {
            FacebookSettingsViewController *vc = (FacebookSettingsViewController *)segue.destinationViewController;
            //[vc setFa]
        }
        
        if ([segue.destinationViewController isKindOfClass:[twitterSettingsViewController class]])
        {
            twitterSettingsViewController *vc = (twitterSettingsViewController *)segue.destinationViewController;
            //[vc setFa]
        }
        
        if ([segue.destinationViewController isKindOfClass:[instagramSettingsViewController class]])
        {
            instagramSettingsViewController *vc = (instagramSettingsViewController *)segue.destinationViewController;
            //[vc setFa]
        }

        if ([segue.destinationViewController isKindOfClass:[twinstabookFirstViewController class]])
        {
            twinstabookFirstViewController *vc = (twinstabookFirstViewController *)segue.destinationViewController;
            //[vc setFa]
        }
        

        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
    
}

@end
