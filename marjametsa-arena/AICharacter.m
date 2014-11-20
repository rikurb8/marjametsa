//
//  AICharacter.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "AICharacter.h"

@interface AICharacter ()

@end

@implementation AICharacter


- (void) setUpAI {
    /*
     * Creates the PhysicsBody features
     */
    
    self.character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.character.size.width/2];
    self.character.physicsBody.friction = 50.0f;
    self.character.physicsBody.restitution = 1.0f;
    self.character.physicsBody.linearDamping = 0.0f;
    self.character.physicsBody.mass = 0.005f;

    
    self.character.physicsBody.allowsRotation = YES;
}

@end
