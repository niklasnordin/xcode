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
        self.angleLabel.fontSize = 30;
        self.angleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:self.angleLabel];
        
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startDeviceMotionUpdates];
        
        CGPoint location = CGPointMake(self.frame.origin.x + 0.5*self.frame.size.width, self.frame.origin.y+0.5*self.frame.size.height);
        
        float radius = 25.0;
        self.centerBubble = [SKSpriteNode spriteNodeWithImageNamed:@"hollowBall"];
        self.centerBubble.size = CGSizeMake(2*radius, 2*radius);
        self.centerBubble.position = location;
        self.centerBubble.name = @"ball";
        self.centerBubble.physicsBody.dynamic = NO;
        self.centerBubble.physicsBody.affectedByGravity = NO;
        [self addChild:self.centerBubble];

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

    CGPoint center;
    center.x = self.frame.origin.x + 0.5*self.frame.size.width;
    center.y = self.frame.origin.y + 0.5*self.frame.size.height;
    
    CGPoint pos;
    pos.x = center.x - 0.5*self.frame.size.width*gravity.x;
    pos.y = center.y - 0.5*self.frame.size.height*gravity.y;
    self.centerBubble.position = pos;
}

@end
