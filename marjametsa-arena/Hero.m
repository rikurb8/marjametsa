//
//  Hero.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Hero.h"
#import "Constants.h"

@interface Hero ()
@end

@implementation Hero

- (id)initWithImage:(NSString*)image
          andHealth:(int)health
               andX:(int)x
               andY:(int)y {

    self = [super init];
    
    if (self) {
        self.image = image;
        self.character = nil;
        
        playerHealth = health;
        coordinateX = x;
        coordinateY = y;
    }
    
    return self;
}

- (void) unmountSpaceship {
        self.image = @"hero.png";
}

- (void) setPhysicsAbilities {
    CGSize tmp = CGSizeMake(self.character.frame.size.width*0.95, self.character.frame.size.height*0.95);
    self.character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tmp];
    self.character.physicsBody.friction = 0.0f;
    self.character.physicsBody.restitution = 0.05f;
    self.character.physicsBody.linearDamping = 0.1f;
    self.character.physicsBody.mass = 0.05f;
    self.character.physicsBody.allowsRotation = YES;
    self.character.physicsBody.categoryBitMask = heroCategory;
    self.character.physicsBody.contactTestBitMask = monsterCategory | itemCategory;

}

- (int) getHealth {
    return playerHealth;
}

@end
