//
//  Monster.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Monster.h"

@implementation Monster

- (id)init {
    self = [super init];
    
    if (self) {
        self.image = @"monster";
    }
    
    return self;
};

-(void) setUpAI {
    [super setUpAI];
    
    self.character.physicsBody.friction = 50.0f;
    
    self.character.physicsBody.restitution = 1.0f;
    
    self.character.physicsBody.linearDamping = 0.0f;
    
    self.character.physicsBody.mass = 0.005f;
    
    SKAction *wait = [SKAction waitForDuration: 3];
    SKAction *moveNodeUp = [SKAction moveByX:0.0 y:200.0 duration:1.0];
    SKAction *moveNodeDown = [SKAction moveByX:0.0 y:-200.0 duration:1.0];
    SKAction *moveNodeRight = [SKAction moveByX:200.0 y:0.0 duration:1.0];
    SKAction *moveNodeLeft = [SKAction moveByX:-200.0 y:0.0 duration:1.0];
    SKAction *moveSequence = [SKAction sequence:@[wait, moveNodeUp, wait, moveNodeDown, wait, moveNodeRight, wait, moveNodeLeft]];
                              
    SKAction *movePattern = [SKAction repeatActionForever:moveSequence];

    [self.character runAction:movePattern];
};

@end
