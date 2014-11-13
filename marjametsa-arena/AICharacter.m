//
//  AICharacter.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "AICharacter.h"

@interface AICharacter ()
@property (getter=isVulnerable) BOOL vulnerable;

@end

@implementation AICharacter

- (void) setUpAI {
    /*
     * Creates the SKActions for the color changes of AICharacter
     */
    
    self.vulnerable = YES;
    
    SKAction *colorize = [SKAction colorizeWithColor: [UIColor redColor] colorBlendFactor: 0.5 duration: 0.1];
    SKAction *wait1 = [SKAction waitForDuration: 3];
    SKAction *uncolorize = [SKAction colorizeWithColorBlendFactor: 0.0 duration: 0.1];
    SKAction *wait2 = [SKAction waitForDuration: 5];
    SKAction *colorizePulse = [SKAction sequence:@[colorize, wait1, uncolorize]];
    SKAction *colorizeSeq = [SKAction sequence:@[wait2, colorizePulse]];
    SKAction *colorizeForever = [SKAction repeatActionForever:colorizeSeq];
    
    [self.character runAction:colorizePulse completion:^{
        self.vulnerable = NO;
    }];
    
    [self.character runAction:colorizeForever];
    
    

    CGSize tmp = CGSizeMake(self.character.size.height*0.70, self.character.size.width*0.70);
    
    self.character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tmp];
    
    self.character.physicsBody.friction = 0.0f;
    
    self.character.physicsBody.restitution = 1.0f;
    
    self.character.physicsBody.linearDamping = 0.0f;
    
    self.character.physicsBody.allowsRotation = YES;
}


@end
