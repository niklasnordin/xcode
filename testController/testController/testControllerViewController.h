//
//  testControllerViewController.h
//  testController
//
//  Created by Niklas Nordin on 2013-09-13.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testControllerViewController : UIViewController
<
    UIPickerViewDataSource,
    UIPickerViewDelegate,
    UIActionSheetDelegate
>

- (IBAction)buttonPressed:(id)sender;

@end
