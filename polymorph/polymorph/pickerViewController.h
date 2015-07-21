//
//  pickerViewController.h
//  polymorph
//
//  Created by Niklas Nordin on 2015-07-15.
//  Copyright (c) 2015 nequam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol pickerSelection <NSObject>

-(NSMutableArray *)selectedComponents;
-(void)updatePickerSelection;

@end

@interface pickerViewController : UIViewController
<
    UIPickerViewDelegate,
    UIPickerViewDataSource
>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)buttonOKPressed:(id)sender;
- (IBAction)buttonCancelPressed:(id)sender;

@property (strong,nonatomic) NSMutableArray *selected;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) NSInteger numberOfComponents;
@property (strong, nonatomic) NSArray *pickerList;
@property (strong, nonatomic) NSArray *pickerSubLists;
@property (strong, nonatomic) id <pickerSelection> delegate;
@property (strong, nonatomic) NSString *titleText;

@end
