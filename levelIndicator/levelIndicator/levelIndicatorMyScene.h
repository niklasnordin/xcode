//
//  levelIndicatorMyScene.h
//  levelIndicator
//

//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface levelIndicatorMyScene : SKScene

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) SKSpriteNode *centerBubble;
@property (strong, nonatomic) SKLabelNode *angleLabel;

@end
