//
//  Boss.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Boss.h"

@implementation Boss
- (id)init {
    self = [super init];
    
    if (self) {
        self.image = @"boss";
    }
    
    return self;
};

-(void) setUpAI {
    [super setUpAI];
    
    self.character.physicsBody.friction = 0.0f;
    
    self.character.physicsBody.restitution = 1.0f;
    
    self.character.physicsBody.linearDamping = 0.0f;
    
    self.character.physicsBody.mass = 0.01f;
};

@end
