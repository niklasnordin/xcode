//
//  scratchyViewController.h
//  scratchy
//
//  Created by Niklas Nordin on 2013-08-11.
//  Copyright (c) 2013 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pictureView.h"
#import "blockingView.h"

@interface scratchyViewController : UIViewController

@property (weak, nonatomic) IBOutlet pictureView *picture;
@property (weak, nonatomic) IBOutlet blockingView *blocking;

@end
