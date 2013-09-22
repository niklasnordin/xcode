//
//  MCSchedulerViewController.h
//  MCScheduler
//
//  Created by Niklas Nordin on 9/22/13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "settingsDB.h"

@interface MCSchedulerViewController : UIViewController
<
UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate,
ADBannerViewDelegate
>

@property (strong,nonatomic) settingsDB *preferences;
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
@property (weak, nonatomic) IBOutlet UILabel *calendarInfoLabel;

//- (void)setupButton:(UIButton *)button withColor:(UIColor *)color;

- (IBAction)pressedSchemeButton:(UIButton *)sender;
- (IBAction)releasedSchemeButtonOutside:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *schemesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *preferencesButton;


@end
