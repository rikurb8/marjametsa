//
//  Monster.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Monster.h"
#import "Constants.h"


@implementation Monster


// Handles the state changes of monster's vulnerability
- (void) handleTimer: (NSTimer *) timer {
    
    
    SKAction *colorize = [SKAction colorizeWithColor: [UIColor redColor]colorBlendFactor: 0.5 duration: 0.1];
    SKAction *uncolorize = [SKAction colorizeWithColorBlendFactor: 0.0 duration: 0.1];
    
    
    vulnerable = !vulnerable;
    
    if (vulnerable){
        [self.character runAction:colorize];
    } else {
        [self.character runAction:uncolorize];
    }
}


- (id)initWithImage:(NSString*)image
        andColorizeSequence:(float)cSequence
        andMovePattern:(int)mPattern
               andX:(int)x
               andY:(int)y
          andHealth:(int)monsHealth{
    
    self = [super init];
    
    if (self) {
        self.image = image;
        
        colorizeSequence = cSequence;
        movePattern = mPattern;
        coordinateX = x;
        coordinateY = y;
        health = monsHealth;
    }
    
    return self;
};

-(void) setUpAI {
    
    self.character = [super setUpSprite:coordinateX height:coordinateY];
    
    [super setUpAI];
    
    // Monster starts from an unvulnerable state
    vulnerable = NO;
    
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval: colorizeSequence target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
       
    SKAction *wait = [SKAction waitForDuration: 3];
    SKAction *moveNodeUp = [SKAction moveByX:0.0 y:110.0 duration:0.5];
    SKAction *moveNodeDown = [SKAction moveByX:0.0 y:-110.0 duration:0.5];
    SKAction *moveNodeRight = [SKAction moveByX:110.0 y:0.0 duration:0.5];
    SKAction *moveNodeLeft = [SKAction moveByX:-110.0 y:0.0 duration:0.5];
    SKAction *moveSequence;
    
    // Chooses movement pattern
    if(movePattern == 1){
        
        moveSequence = [SKAction sequence:@[wait, moveNodeUp, wait, moveNodeDown, wait, moveNodeRight, wait, moveNodeLeft]];
    
    } else if(movePattern == 2){
        
        moveSequence = [SKAction sequence:@[moveNodeDown, moveNodeUp, moveNodeUp, moveNodeDown, moveNodeRight, moveNodeLeft, moveNodeLeft, moveNodeRight]];
        
    } else if(movePattern == 3){
    
        moveSequence = [SKAction sequence:@[moveNodeRight, moveNodeRight, moveNodeUp, moveNodeUp, moveNodeLeft, moveNodeLeft, moveNodeDown, moveNodeDown]];
    }
    
    SKAction *movement = [SKAction repeatActionForever:moveSequence];

    [self.character runAction:movement];
    
    self.character.physicsBody.categoryBitMask = monsterCategory;
};

- (void) setName:(int)index {
    self.character.name = [NSString stringWithFormat:@"%d", index];
}

// Returns true if monster is in a vulnerable state (colorized with red)
- (BOOL) isVulnerable {
    return vulnerable;
}

- (NSString*) getName{
    return self.character.name;
}

- (int) getHealth {
    return health;
}

- (void) removeHealth {
    health -= 1;
}


@end