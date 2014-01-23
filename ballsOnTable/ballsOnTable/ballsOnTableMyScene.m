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
        
        float radius = 15.0;
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"round"];
        sprite.size = CGSizeMake(2*radius, 2*radius);
        sprite.name = @"ball";

        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
        sprite.position = location;
        CGPoint center;
        center.x = self.frame.origin.x + 0.5*self.frame.size.width;
        center.y = self.frame.origin.y + 0.5*self.frame.size.height;
        //sprite.position = center;

        sprite.physicsBody.dynamic = YES;
        sprite.physicsBody.affectedByGravity = YES;
        sprite.physicsBody.usesPreciseCollisionDetection = NO;
        sprite.physicsBody.categoryBitMask = ballCategory;
        sprite.physicsBody.collisionBitMask = wallCategory || ballCategory;

        sprite.physicsBody.restitution = 0.95;
        sprite.physicsBody.friction = 0.1;
        
        // airflow resistance
        sprite.physicsBody.linearDamping = 0.0;
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
    
    /*
    CGPoint center;
    center.x = self.frame.origin.x + 0.5*self.frame.size.width;
    center.y = self.frame.origin.y + 0.5*self.frame.size.height;
    
    [self enumerateChildNodesWithName:@"ball" usingBlock: ^(SKNode *node, BOOL *stop)
    {
        //SKSpriteNode *ball = (SKSpriteNode *)node;
        CGPoint pos;
        pos.x = center.x - 0.5*self.frame.size.width*gravity.x;
        pos.y = center.y - 0.5*self.frame.size.height*gravity.y;
        node.position = pos;
        
    }];
     */

}

@end
