//
//  AICharacter.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "AICharacter.h"

@interface AICharacter ()
@property (nonatomic) BOOL vulnerable;

@end

@implementation AICharacter

- (void) handleTimer: (NSTimer *) timer {
    self.vulnerable = !self.vulnerable;
}


- (void) setUpAI {
    /*
     * Creates the SKActions for the color changes of AICharacter
     */
    
    //TODO: loop YES/NO according to the coloring below. How?
    self.vulnerable = NO;
    
    SKAction *colorize = [SKAction colorizeWithColor: [UIColor redColor] colorBlendFactor: 0.5 duration: 0.1];
    SKAction *wait1 = [SKAction waitForDuration: 3];
    SKAction *uncolorize = [SKAction colorizeWithColorBlendFactor: 0.0 duration: 0.1];
    SKAction *wait2 = [SKAction waitForDuration: 5];
    SKAction *colorizePulse = [SKAction sequence:@[colorize, wait1, uncolorize]];
    SKAction *colorizeSeq = [SKAction sequence:@[wait2, colorizePulse]];
    SKAction *colorizeForever = [SKAction repeatActionForever:colorizeSeq];
    
    [self.character runAction:colorizeForever];

    CGSize tmp = CGSizeMake(self.character.size.height*0.70, self.character.size.width*0.70);
    
    self.character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tmp];
    
    
    
    self.character.physicsBody.allowsRotation = YES;
    
    // TODO: make the interval same as the colorizePulse. now just a lucky guess :)
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}


- (void) setName:(int)index {
    self.character.name = [NSString stringWithFormat:@"%d", index];
}

- (BOOL) isVulnerable {
    return self.vulnerable;
}

- (NSString*) getName{
    return self.character.name;
}

@end
