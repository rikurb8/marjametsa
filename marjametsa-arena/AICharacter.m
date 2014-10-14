//
//  AICharacter.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "AICharacter.h"

@implementation AICharacter

- (void) setUpAI {
    /*
     * Creates the SKActions for the movement and color changes of monster
     */
    
    SKAction *colorize = [SKAction colorizeWithColor: [UIColor redColor] colorBlendFactor: 0.5 duration: 1];
    SKAction *wait1 = [SKAction waitForDuration: 3];
    SKAction *uncolorize = [SKAction colorizeWithColorBlendFactor: 0.0 duration: 1];
    SKAction *wait2 = [SKAction waitForDuration: 10];
    SKAction *colorizePulse = [SKAction sequence:@[colorize, wait1, uncolorize, wait2]];
    SKAction *colorizeForever = [SKAction repeatActionForever:colorizePulse];
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-49, 0, 100, 100) cornerRadius:100];
    SKAction *followCircle = [SKAction followPath:circle.CGPath asOffset:YES orientToPath:NO duration:5.0];
    
    SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration:3.0];
    SKAction *circulateForever = [SKAction repeatActionForever:oneRevolution];
    SKAction *moveCircleForever = [SKAction repeatActionForever:followCircle];
    
    
    SKAction *group = [SKAction group:@[circulateForever, moveCircleForever, colorizeForever]];

    
    [self.character runAction:group];
}

@end
