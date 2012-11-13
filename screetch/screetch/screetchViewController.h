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

@property (strong, nonatomic) NSArray *pictures;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSArray *animals;
@property (strong, nonatomic) NSArray *things;

@property (weak, nonatomic) IBOutlet screetchView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *scoreField;
- (IBAction)choiceButtonPressed:(UIButton *)sender;

-(void)setDisplayWithText:(NSString *)text;
-(void)setScoreWithInt:(int)score;

@end
