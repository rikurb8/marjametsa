//
//  Boss.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Boss.h"
#import "Constants.h"

@implementation Boss

- (id)initWithImage:(NSString *)image
          andHealth:(int)hlth
andColorizeSequence:(float)cSequence
     andMovePattern:(int)mPattern
               andX:(int)x
               andY:(int)y {
    
    self = [super initWithImage:image
            andColorizeSequence:cSequence
                 andMovePattern:mPattern
                           andX:x
                           andY:y];
    
    if (self) {
        health = hlth;
    }
    
    return self;
};

-(void) setUpAI {
    [super setUpAI];
    
    SKAction *moveNodeRight = [SKAction moveByX:10.0 y:0.0 duration:0.1];
    SKAction *moveNodeLeft = [SKAction moveByX:-10.0 y:0.0 duration:0.1];
    SKAction *vibrate = [SKAction sequence:@[moveNodeLeft, moveNodeRight]];
    SKAction *vibrateForever = [SKAction repeatActionForever:vibrate];
    
    [self runAction:vibrateForever];
    
    self.character.physicsBody.categoryBitMask = bossCategory;
};

- (int) getHealth {
    return health;
}

@end
