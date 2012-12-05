//
//  thermoViewViewController.h
//  screetch
//
//  Created by Niklas Nordin on 2012-10-23.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "screetchView.h"

@interface screetchViewController : UIViewController

@property (strong, nonatomic) UIImage *loadedImage;
@property (strong, nonatomic) NSArray *buttonNames;
@property (weak, nonatomic) IBOutlet screetchView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *scoreField;

- (IBAction)choiceButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;

-(void)setDisplayWithText:(NSString *)text;
-(void)setScoreWithInt:(int)score;

@end
