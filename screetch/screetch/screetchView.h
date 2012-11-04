//
//  screetchView.h
//  screetch
//
//  Created by Niklas Nordin on 2012-10-31.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import <UIKit/UIKit.h>

static float windowWidth = 300.0;
static float windowHeight = 300.0;
static int widthDivisions = 10;
static int heightDivisions = 10;

@interface screetchView : UIView

@property (weak, nonatomic) id delegate;
@property (nonatomic) bool *pixelMatrix;
@property (strong, nonatomic) UIImage *bgImage;
@property (strong, nonatomic) UIImageView *bgView;
@property CGImageRef      bgImageRef;

-(void)pan:(UIPanGestureRecognizer *)gesture;
-(int)score;

@end
