//
//  levelIndicatorMyScene.m
//  levelIndicator
//
//  Created by Niklas Nordin on 2014-01-10.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "levelIndicatorMyScene.h"

@implementation levelIndicatorMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.angleLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        self.angleLabel.text = @"Hello, World!";
        self.angleLabel.fontSize = 25;
        
        self.angleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:self.angleLabel];
        
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startDeviceMotionUpdates];
        
        CGPoint location = CGPointMake(self.frame.origin.x + 0.5*self.frame.size.width, self.frame.origin.y+0.5*self.frame.size.height);
        
        float radius = 25.0;
        float extraSpace = 3.0;
        self.centerBubble = [SKSpriteNode spriteNodeWithImageNamed:@"hollowBall"];
        self.centerBubble.size = CGSizeMake(2*radius, 2*radius);
        self.centerBubble.position = location;
        self.centerBubble.name = @"ball";
        self.centerBubble.physicsBody.dynamic = NO;
        self.centerBubble.physicsBody.affectedByGravity = NO;
        [self addChild:self.centerBubble];
        
        SKSpriteNode *circle = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
        circle.size = CGSizeMake(2*radius+extraSpace*2, 2*radius+extraSpace*2);
        circle.position = location;
        [self addChild:circle];
        
        self.verticalBarPosition = self.frame.origin.x + 0.1*self.frame.size.width;
        self.horisontalBarPosition = self.frame.origin.y + 0.1*self.frame.size.height;
        SKSpriteNode *verticalBar = [SKSpriteNode spriteNodeWithImageNamed:@"square"];
        verticalBar.size = CGSizeMake(2*radius+extraSpace, 18*radius+extraSpace);
        CGPoint vBar, hBar;
        vBar.x = self.verticalBarPosition;
        vBar.y = location.y;
        hBar.x = location.x;
        hBar.y = self.horisontalBarPosition;
        verticalBar.position = vBar;
        
        [self addChild:verticalBar];
        
        self.verticalBubble = [SKSpriteNode spriteNodeWithImageNamed:@"hollowBall"];
        self.verticalBubble.size = CGSizeMake(2*radius, 2*radius);
        self.verticalBubble.position = vBar;
        self.verticalBubble.alpha = 0.5;
        
        [self addChild:self.verticalBubble];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        /*
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.position = location;
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        [sprite runAction:[SKAction repeatActionForever:action]];
        [self addChild:sprite];
         */
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    CMAcceleration gravity = self.motionManager.deviceMotion.gravity;
    CMAttitude *att = self.motionManager.deviceMotion.attitude;
    
    // gMag should be 1.0
    float gMag = sqrtf(gravity.x*gravity.x + gravity.y*gravity.y + gravity.z*gravity.z);
    float at = gravity.x/gMag;
    float bt = gravity.y/gMag;
    
    // sidvinkel
    double roll = att.roll*rad2deg;
    // fram/bak vinkel
    double pitch = att.pitch*rad2deg;
    // yaw är rotationsvinkeln runt gravitations-riktingen
    double yaw = att.yaw*rad2deg;
    
    self.angleLabel.text = [NSString stringWithFormat:@"%4.1f deg",roll];
    
    CGPoint center;
    center.x = self.frame.origin.x + 0.5*self.frame.size.width;
    center.y = self.frame.origin.y + 0.5*self.frame.size.height;
    
    CGPoint pos;
    pos.x = center.x - 0.5*self.frame.size.width*gravity.x;
    pos.y = center.y - 0.5*self.frame.size.height*gravity.y;
    
    self.centerBubble.position = pos;
    
    CGPoint vPos;
    vPos.x = self.verticalBubble.position.x;
    vPos.y = pos.y;
    
    self.verticalBubble.position = vPos;
    
}

@end
