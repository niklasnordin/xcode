//
//  tasPickerView.h
//  Checkup Scheduler
//
//  Created by Niklas Nordin on 2013-09-16.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tasPickerView : UIPickerView
<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (strong, nonatomic) NSArray *minutes;

@end
