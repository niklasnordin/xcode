//
//  menuViewController.h
//  scratchPicture
//
//  Created by Niklas Nordin on 2012-12-05.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface menuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *topNavigationBarItem;
@property (weak, nonatomic) IBOutlet UIButton *allButtons;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
