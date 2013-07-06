//
//  checkupSchedulerViewController.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-06-21.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface checkupSchedulerViewController : UIViewController
<
    UIPickerViewDataSource,
    UIPickerViewDelegate,
    UITextFieldDelegate,
    ADBannerViewDelegate
>

@property (strong, nonatomic) NSMutableArray *schemeNames;
@property (strong, nonatomic) NSMutableDictionary *schemesDictionary;
- (IBAction)createEvent:(id)sender;
-(void)save;
@property (weak, nonatomic) IBOutlet UIButton *schemeButton;
- (IBAction)clickedSchemeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createEventButton;
@property (weak, nonatomic) IBOutlet UITextField *eventTextField;
- (IBAction)startDateButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet ADBannerView *topBannerView;

@end
