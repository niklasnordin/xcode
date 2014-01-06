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
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        self.physicsBody.categoryBitMask = wallCategory;
        [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"ballSmall"];
        sprite.name = @"ball";
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25.0];
        sprite.position = location;
        sprite.physicsBody.dynamic = YES;
        sprite.physicsBody.affectedByGravity = YES;
        sprite.physicsBody.categoryBitMask = ballCategory;
        sprite.physicsBody.collisionBitMask = wallCategory || ballCategory;

        sprite.physicsBody.restitution = 0.9;
        sprite.physicsBody.friction = 0.1;
        sprite.physicsBody.linearDamping = 0.1;
        sprite.physicsBody.angularDamping = 0.1;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
