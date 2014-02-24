//
//  searchGroupMembersViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-23.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "searchGroupMembersViewController.h"

@interface searchGroupMembersViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation searchGroupMembersViewController

- (void)addObjectToTable:(displayObject *)obj
{
    NSLog(@"setting tableViewObjects, updating tableView");
    // make sure we only update the table view on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableViewObjects addObject:obj];
        [self.tableView reloadData];
    });
}

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
    
    self.searchBar.delegate = self;
    
    self.tableViewObjects = [[NSMutableArray alloc] init];
    [self searchWithText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableViewObjects count];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"aliasNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    displayObject *obj = [self.tableViewObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.mainTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *dict = [self.names objectAtIndex:indexPath.row];
    //NSString *userID = [dict objectForKey:@"id"];

}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"clicked");
    [searchBar resignFirstResponder];
}

- (void)searchWithText:(NSString *)searchText
{
    NSInteger length = [searchText length];
    
    if (length >= self.minStringLength)
    {
        if ([self.searchFeed isEqualToString:[self.database.socialMediaNames objectAtIndex:kFacebook]])
        {
            [self facebookSearch:searchText];
        }
        
        if ([self.searchFeed isEqualToString:[self.database.socialMediaNames objectAtIndex:kTwitter]])
        {
            [self twitterSearch:searchText];
        }
        
        if ([self.searchFeed isEqualToString:[self.database.socialMediaNames objectAtIndex:kInstagram]])
        {
            [self instagramSearch:searchText];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithText:searchText];
}

- (void)facebookSearch:(NSString *)searchString
{
    NSLog(@"facebookSearch");
    switch (self.database.selectedOptionIndex) {

        case 0:
            [self searchFacebookFriends:searchString];
            break;

        case 1:
            [self searchFacebookPages:searchString];
            break;

        case 2:
            [self searchFacebookUsers:searchString];
            break;

        default:
            break;
    }
    
}

- (void)twitterSearch:(NSString *)searchString
{
    bool emptyStringSearch = NO;
    if ([searchString isEqualToString:@""])
    {
        emptyStringSearch = YES;
    }
    for (NSDictionary *dict in self.database.twitterFriends)
    {
        NSString *name = [dict objectForKey:@"name"];
        NSInteger len = [name rangeOfString:searchString options:NSCaseInsensitiveSearch].length;
        if (len || emptyStringSearch)
        {
            displayObject *obj = [[displayObject alloc] init];
            obj.mainTitle = name;
            [self addObjectToTable:obj];
        }

    }
    
}

- (void)instagramSearch:(NSString *)searchString
{
    NSLog(@"instagramSearch");
}

- (void)searchFacebookFriends:(NSString *)searchString
{
    
}

- (void)searchFacebookPages:(NSString *)searchString
{
    
}

- (void)searchFacebookUsers:(NSString *)searchString
{
    
}

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self searchButtonClicked:nil];
    return YES;
}
*/

@end
