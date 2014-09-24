//
//  MyScene.m
//  marjametsa-arena
//
//  Created by Ridge on 24.9.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "GameScene.h"
@import CoreMotion;

@interface GameScene ()
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (nonatomic) int monsterCount;

@end


@implementation GameScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"grass_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        //add the hero to middle of the screen
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"hero"];
        self.player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self addChild:self.player];
        
    }
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1 && self.monsterCount < 4) {
        self.lastSpawnTimeInterval = 0;
        [self addMonster];
        self.monsterCount += 1;
    }
}

- (void)update:(NSTimeInterval)currentTime {
    
    //function used to handdle spawning of monsters
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}


- (void)addMonster {
    
    SKSpriteNode *monster = [SKSpriteNode spriteNodeWithImageNamed:@"monster"];
    
    //calculates the xy -coordinates for the spawning monster randomly
    int minY = monster.size.height / 2;
    int maxY = self.frame.size.height - monster.size.height / 2;
    int rangeY = maxY - minY;
    int calculatedY = (arc4random() % rangeY) + minY;
    
    int minX = monster.size.width / 2;
    int maxX = self.frame.size.width - monster.size.width / 2;
    int rangeX = maxX - minX;
    int calculatedX = (arc4random() % rangeX) + minX;
    
    monster.position = CGPointMake(calculatedX, calculatedY);
    [self addChild:monster];
    
    /*
     
     //säädä suhteellinen nopeus nopeus
     //TODO: säädä kohtuulliset rajat, levelien mukaa kasvava?
     int minDuration = 2.0;
     int maxDuration = 4.0;
     int rangeDuration = maxDuration - minDuration;
     int actualDuration = (arc4random() % rangeDuration) + minDuration;
     
     
     SKAction *actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, calculatedY) duration:actualDuration];
     
     SKAction * actionMoveDone = [SKAction removeFromParent];
     
     //adds sequence for spritenode -> do action and delete action
     [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
     
     */
    
}


@end
