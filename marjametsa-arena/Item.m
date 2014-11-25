//
//  Banana.m
//  marjametsa-arena
//
//  Created by Ridge on 14.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)init {
    self = [super init];
    
    if (self) {
        self.image = @"banana.png";
    }
    
    return self;
};
-(void) setUpAI {
    
    self.character.physicsBody.friction = 0.0f;
    
    self.character.physicsBody.restitution = 1.0f;
    
    self.character.physicsBody.linearDamping = 0.0f;
    
    self.character.physicsBody.mass = 0;
    
    self.character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.character.size.width/2];
    
    self.character.physicsBody.allowsRotation = YES;
};

@end
