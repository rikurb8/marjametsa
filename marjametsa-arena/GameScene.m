//
//  MyScene.m
//  marjametsa-arena
//
//  Created by Ridge on 24.9.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "GameScene.h"
@import CoreMotion;

#define kPlayerSpeed 700
#define kUpdateInterval (1.0f / 60.0f) //60fps


@interface GameScene ()
@property (nonatomic) SKSpriteNode * player;
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
        
        [self addMonster:CGPointMake(400, 150) isBoss:YES];
        [self addMonster:CGPointMake(150, 150) isBoss:NO];
        [self addMonster:CGPointMake(225, 75) isBoss:NO];

        //add the hero to middle of the screen
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"hero"];
        self.player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self addChild:self.player];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
        
        //if a accelometer is found, start queueing data, and handling it with the given function
        if ([self.motionManager isAccelerometerAvailable] == YES) {
            [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                                withHandler:^(CMAccelerometerData *data, NSError *error) {
                 if (error) {
                     NSLog(@"%@",[error localizedDescription]);
                 }
                 
                 float destX = 0.0;
                 float destY = 0.0;
                 float currentX = self.player.position.x;
                 float currentY = self.player.position.y;
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
    if (coordinates.x < self.player.size.height/2) {
        coordinates.x = self.player.size.height/2;
    } else if (coordinates.x > self.frame.size.width-self.player.size.height/2) {
        coordinates.x = self.frame.size.width-self.player.size.height/2;
    }
    
    if (coordinates.y < self.player.size.width/2) {
        coordinates.y = self.player.size.width/2;
    } else if (coordinates.y > self.frame.size.height-self.player.size.width/2) {
        coordinates.y = self.frame.size.height-self.player.size.width/2;
    }

    return coordinates;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1 && self.monsterCount < 4) {
        self.lastSpawnTimeInterval = 0;
        //[self addMonster];
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


- (void)addMonster:(CGPoint)position isBoss:(BOOL)isBoss{
    NSString *monsterPicture = @"";
    
    if (isBoss) {
        monsterPicture = @"boss";
    } else {
        monsterPicture = @"monster";
    }
    
    SKSpriteNode *monster = [SKSpriteNode spriteNodeWithImageNamed:monsterPicture];

    monster.position = position;
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
