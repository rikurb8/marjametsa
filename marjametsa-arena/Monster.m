//
//  Monster.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Monster.h"


@implementation Monster

- (void) handleTimer: (NSTimer *) timer {
    vulnerable = !vulnerable;
}


- (id)initWithImage:(NSString*)image
        andColorizeSequence:(float)cSequence
        andMovePattern:(NSString*)mPattern
               andX:(int)x
               andY:(int)y  {
    
    self = [super init];
    
    if (self) {
        self.image = image;
        
        colorizeSequence = cSequence;
        movePattern = mPattern;
        coordinateX = x;
        coordinateY = y;
    }
    
    return self;
};

-(void) setUpAI {
    [super setUpAI];
    
    //TODO: loop YES/NO according to the coloring below. How?
    vulnerable = NO;
    
    SKAction *colorize = [SKAction colorizeWithColor: [UIColor redColor] colorBlendFactor: 0.5 duration: 0.1];
    SKAction *wait1 = [SKAction waitForDuration: colorizeSequence];
    SKAction *uncolorize = [SKAction colorizeWithColorBlendFactor: 0.0 duration: 0.1];
    SKAction *colorizePulse = [SKAction sequence:@[colorize, wait1, uncolorize]];
    SKAction *colorizeSeq = [SKAction sequence:@[wait1, colorizePulse]];
    SKAction *colorizeForever = [SKAction repeatActionForever:colorizeSeq];
    
    [self.character runAction:colorizeForever];
    
    // TODO: make the interval same as the colorizePulse. now just a lucky guess :)
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
       
    SKAction *wait = [SKAction waitForDuration: 3];
    SKAction *moveNodeUp = [SKAction moveByX:0.0 y:200.0 duration:1.0];
    SKAction *moveNodeDown = [SKAction moveByX:0.0 y:-200.0 duration:1.0];
    SKAction *moveNodeRight = [SKAction moveByX:200.0 y:0.0 duration:1.0];
    SKAction *moveNodeLeft = [SKAction moveByX:-200.0 y:0.0 duration:1.0];
    SKAction *moveSequence;
    
    // Chooses movement pattern
    if([movePattern isEqualToString: @"pattern1"]){
        
        moveSequence = [SKAction sequence:@[wait, moveNodeUp, wait, moveNodeDown, wait, moveNodeRight, wait, moveNodeLeft]];
    
    } else if([movePattern isEqualToString: @"pattern2"]){
        
        moveSequence = [SKAction sequence:@[moveNodeDown, moveNodeUp, moveNodeUp, moveNodeDown, moveNodeRight, moveNodeLeft, moveNodeLeft, moveNodeRight]];
        
    } else if([movePattern isEqualToString: @"pattern3"]){
    
        moveSequence = [SKAction sequence:@[moveNodeRight, moveNodeRight, moveNodeUp, moveNodeUp, moveNodeLeft, moveNodeLeft, moveNodeDown, moveNodeDown]];
    }
    
    SKAction *movement = [SKAction repeatActionForever:moveSequence];

    [self.character runAction:movement];
};

- (void) setName:(int)index {
    self.character.name = [NSString stringWithFormat:@"%d", index];
}

- (BOOL) isVulnerable {
    return vulnerable;
}

- (NSString*) getName{
    return self.character.name;
}


@end