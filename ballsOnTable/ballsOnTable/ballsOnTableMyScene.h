//
//  ballsOnTableMyScene.h
//  ballsOnTable
//

//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

static const uint8_t ballCategory = 1;
static const uint8_t wallCategory = 2;

@interface ballsOnTableMyScene : SKScene

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
