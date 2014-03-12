//
//  twinstabookFirstViewController.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-01-17.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "tif_db.h"
#import "twinstabookAppDelegate.h"
#import "JMPickerView.h"

@interface twinstabookFirstViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    NSFetchedResultsControllerDelegate,
    JMPickerViewDelegate
>

@property (weak, nonatomic) tif_db *database;
@property (strong, nonatomic) JMPickerView *picker;
@property (strong, nonatomic) UIRefreshControl *refreshController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UIButton *feedButton;
- (IBAction)feedButtonClicked:(id)sender;
- (NSString *)nameForPicker:(NSInteger)index;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;


// Causes the fetchedResultsController to refetch the data.
// You almost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
- (void)performFetch;

// Turn this on before making any changes in the managed object context that
//  are a one-for-one result of the user manipulating rows directly in the table view.
// Such changes cause the context to report them (after a brief delay),
//  and normally our fetchedResultsController would then try to update the table,
//  but that is unnecessary because the changes were made in the table already (by the user)
//  so the fetchedResultsController has nothing to do and needs to ignore those reports.
// Turn this back off after the user has finished the change.
// Note that the effect of setting this to NO actually gets delayed slightly
//  so as to ignore previously-posted, but not-yet-processed context-changed notifications,
//  therefore it is fine to set this to YES at the beginning of, e.g., tableView:moveRowAtIndexPath:toIndexPath:,
//  and then set it back to NO at the end of your implementation of that method.
// It is not necessary (in fact, not desirable) to set this during row deletion or insertion
//  (but definitely for row moves).
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

// Set to YES to get some debugging output in the console.
@property BOOL debug;

@end
