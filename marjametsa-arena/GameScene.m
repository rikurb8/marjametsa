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
- (void) vibrate;
- (BOOL) isInsideBoundaries;

@end


@implementation GameScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"grass_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        //set the scenes gravityfield
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        
        // 1 Create a physics body that borders the screen
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody;
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody.friction = 0.0f;
        
        
        self.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        [self addMonster:CGPointMake(400, 150)];
        [self addMonster:CGPointMake(150, 150)];
        [self addMonster:CGPointMake(225, 75)];
        
        

        
        self.player = [[Hero alloc] init];
        
        
        //add the hero to middle of the screen
        SKSpriteNode *hero = [self.player setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
        
        [self addChild:hero];
        
        hero.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hero.frame.size.width/3];
        // 3
        hero.physicsBody.friction = 0.0f;
        // 4
        hero.physicsBody.restitution = 1.0f;
        // 5
        hero.physicsBody.linearDamping = 0.0f;
        // 6
        hero.physicsBody.allowsRotation = NO;
        
        [hero.physicsBody applyImpulse:CGVectorMake(8.0f, -8.0f)];
        
        SKLabelNode *tmp = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        tmp.fontSize = 16;
        tmp.text = @"HITS: 0";
        tmp.position = CGPointMake(150, 10);
        [self addChild:tmp];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
        
        //if a accelometer is found, start queueing data, and handling it with the given function
        if ([self.motionManager isAccelerometerAvailable] == YES) {
            [self setUpMotionManager];
        }

    }
    return self;
}




- (void) setUpMotionManager {
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
             
             CGPoint newPoint = [self isInsideLimits:CGPointMake(destX, destY)];
             //boundries where the player is going to be
             float maxY = newPoint.y + ([self.player getHeight]/2);
             float minY = newPoint.y - ([self.player getHeight]/2);
             
             float maxX = newPoint.x + ([self.player getWidth]/2);
             float minX = newPoint.x - ([self.player getWidth]/2);
             
             //NSLog(@"NEW MOVE ATTEMPT");
             //NSLog(@"PLAYER INFO:");
             //NSLog(@"Player X coodinate: %f", newPoint.x);
             //NSLog(@"Player Y coodinate: %f", newPoint.y);
             
             //Tässä pitäs lähtee tarkastaan jostain suunnasta et voidaanko liikkua (otus, item jne)
             for (Monster *mons in [self monsterArray]) {
                                  
                 [self isInBoundaries:CGPointMake([mons getXCoordinate], [mons getYCoordinate]) :[mons getHeight] :CGPointMake(minX, minY) :self.player.getHeight];
             }
             
             // move to new location
             SKAction *action = [SKAction moveTo:newPoint duration:1];
             [self.player runAction:action];
         }
    }];
};

- (BOOL)isInBoundaries:(CGPoint)monsterCoordinates :(int)monsterHeight :(CGPoint)playerCoordinates :(int)playerHeight{
    
    CGFloat xDiff = monsterCoordinates.x - playerCoordinates.x;
    CGFloat yDiff = monsterCoordinates.y - playerCoordinates.y;
    
    if (xDiff < 0) {
        xDiff = xDiff * -1;
    }
    
    if (yDiff < 0) {
        yDiff = yDiff * -1;
    }
    
    if (xDiff < playerHeight && yDiff < playerHeight) {
        return true;
    } else {
        return false;
    }
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
    
    newMonster.character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newMonster.character.size];
    // 3
    newMonster.character.physicsBody.friction = 0.0f;
    // 4
    newMonster.character.physicsBody.restitution = 1.0f;
    // 5
    newMonster.character.physicsBody.linearDamping = 0.0f;
    // 6
    newMonster.character.physicsBody.allowsRotation = YES;
    
    [self.monsterArray addObject:newMonster];
    
 }


@end
