//
//  levelIndicatorMyScene.h
//  levelIndicator
//

//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

static const float rad2deg = 180.0/3.1415926535898;

@interface levelIndicatorMyScene : SKScene

@property (nonatomic) float verticalBarPosition;
@property (nonatomic) float horisontalBarPosition;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) SKSpriteNode *centerBubble;
@property (strong, nonatomic) SKSpriteNode *verticalBubble;

@property (strong, nonatomic) SKLabelNode *angleLabel;

@end
