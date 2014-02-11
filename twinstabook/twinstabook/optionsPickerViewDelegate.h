//
//  optionsPickerViewDelegate.h
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-11.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "tif_db.h"
#import "JMPickerView.h"
#import <UIKit/UIKit.h>

@interface optionsPickerViewDelegate : UIPickerView
<
    JMPickerViewDelegate
>

@property (weak, nonatomic) tif_db *database;
@property (weak, nonatomic) id delegate;
@end
