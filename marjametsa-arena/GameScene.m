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
    
    
    SKAction *group = [SKAction group:@[circulateForever, moveCircleForever, colorizeForever]]; [monster runAction:group];
 }


@end
