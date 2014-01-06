//
//  ballsOnTableMyScene.m
//  ballsOnTable
//
//  Created by Niklas Nordin on 2014-01-05.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "ballsOnTableMyScene.h"

@implementation ballsOnTableMyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        self.physicsBody.categoryBitMask = wallCategory;
        [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];

        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startDeviceMotionUpdates];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"round"];
        sprite.size = CGSizeMake(20.0, 20.0);
        sprite.name = @"ball";
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10.0];
        sprite.position = location;
        sprite.physicsBody.dynamic = YES;
        sprite.physicsBody.affectedByGravity = YES;
        sprite.physicsBody.categoryBitMask = ballCategory;
        sprite.physicsBody.collisionBitMask = wallCategory || ballCategory;

        sprite.physicsBody.restitution = 0.8;
        sprite.physicsBody.friction = 0.1;
        sprite.physicsBody.linearDamping = 0.3;
        sprite.physicsBody.angularDamping = 0.0;
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    CGFloat scale = 10.0;
    CGFloat accScale = 50.0;
    /* Called before each frame is rendered */
    CMAcceleration gravity = self.motionManager.deviceMotion.gravity;
    CMAcceleration acc = self.motionManager.deviceMotion.userAcceleration;
    //NSLog(@"gravity = %f %f %f",gravity.x, gravity.y, gravity.z);
    CGVector g = CGVectorMake(scale*gravity.x, scale*gravity.y);
    CGVector a = CGVectorMake(accScale*acc.x, accScale*acc.y);
    CGVector ag = CGVectorMake(a.dx + g.dx, a.dy+g.dy);
    self.physicsWorld.gravity = ag;
}

@end
