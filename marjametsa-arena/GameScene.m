//
//  MyScene.m
//  marjametsa-arena
//
//  Created by Ridge on 24.9.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "GameScene.h"
#import "Hero.h"
#import "Monster.h"
#import "Boss.h"
@import CoreMotion;

#define kPlayerSpeed 700
#define kUpdateInterval (1.0f / 60.0f) //60fps


@interface GameScene ()
@property (nonatomic) Hero *player;
@property (nonatomic) NSMutableArray *monsterArray;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) CMMotionManager *motionManager;


@property (nonatomic) int monsterCount;

@end


@implementation GameScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"grass_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        
        self.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        
        [self addMonster:CGPointMake(400, 150)];
        [self addMonster:CGPointMake(150, 150)];
        [self addMonster:CGPointMake(225, 75)];

        
        self.player = [[Hero alloc] init];
        
        
        //add the hero to middle of the screen
        SKSpriteNode *hero = [self.player setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
        
        [self addChild:hero];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
        
        
        //if a accelometer is found, start queueing data, and handling it with the given function
        if ([self.motionManager isAccelerometerAvailable] == YES) {
            
            //TODO: refactor to own function or somewhere
            [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                                withHandler:^(CMAccelerometerData *data, NSError *error) {
                 if (error) {
                     NSLog(@"%@",[error localizedDescription]);
                 }
                 
                 float destX = 0.0;
                 float destY = 0.0;
                 float currentX = [self.player getXCoordinate];
                 float currentY = [self.player getYCoordinate];
                 BOOL shouldMove = NO;
                 
                 destX = currentX;
                 destY = currentY;
                 
                 if(data.acceleration.y < -0.05 || data.acceleration.y > 0.05) {
                     destX = currentX - (data.acceleration.y * kPlayerSpeed);
                     shouldMove = YES;
                 }
                
                 if (data.acceleration.x < -0.05 || data.acceleration.x > 0.05) {
                     destY = currentY + (data.acceleration.x * kPlayerSpeed);
                     shouldMove = YES;
                 }
                 
                 if(shouldMove) {
                     SKAction *action = [SKAction moveTo:[self isInsideLimits:CGPointMake(destX, destY)] duration:1];
                     [self.player runAction:action];
                 }
             }];
        }

    }
    return self;
}



/*
 * Function that checks if the given coordinates are within the screen.
 * If coordinates are ok, returns coordinates, else changes the coordinate to 
 * coordinate of side + player.width/2
*/
- (CGPoint)isInsideLimits:(CGPoint)coordinates {
    if (coordinates.x < [self.player getHeight]/2) {
        coordinates.x = [self.player getHeight]/2;
    } else if (coordinates.x > self.frame.size.width-[self.player getHeight]/2) {
        coordinates.x = self.frame.size.width-[self.player getHeight]/2;
    }
    
    if (coordinates.y < [self.player getWidth]/2) {
        coordinates.y = [self.player getWidth]/2;
    } else if (coordinates.y > self.frame.size.height-[self.player getWidth]/2) {
        coordinates.y = self.frame.size.height-[self.player getWidth]/2;
    }

    return coordinates;
}

/* THESE CAN BE USED TO SPAWN MONSTERS AT CERTAIN TIMERATE
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1 && self.monsterCount < 4) {
        self.lastSpawnTimeInterval = 0;
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
*/

- (void)addMonster:(CGPoint)position {
    
    Monster *newMonster = [[Monster alloc] init];
    
    //onko x ja y oikein?
    newMonster.character = [newMonster setUpSprite:position.x height:position.y];
    
    //TODO: move to monsterInit or setUpSprite
    [newMonster setUpAI];
    
    [self addChild:newMonster.character];
    [self.monsterArray addObject:newMonster];
    
 }


@end
