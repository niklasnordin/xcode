//
//  reminderPickerView.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-07-03.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reminderPickerView : UIPickerView
<
UIPickerViewDataSource,
UIPickerViewDelegate
>

@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSArray *values;

@end
