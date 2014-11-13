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

static const uint32_t heroCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t monsterCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t borderCategory = 0x1 << 2;  // 00000000000000000000000000000100
//static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000

@interface GameScene ()
@property (nonatomic) Hero *player;
@property (nonatomic) NSMutableArray *monsterArray;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) int monsterCount;
@property (nonatomic) int hitCount;
@property (nonatomic) int secTimer;
@property (nonatomic) SKLabelNode *hits;
@property (nonatomic) SKLabelNode *timer;
- (void) vibrate;

@end


@implementation GameScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"grass_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        // Overall physic utilization
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0f;
        
        self.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        // TODO: move these to a generic place where x monster can be summed to diffrent locations
        [self addMonster:CGPointMake(400, 150)];
        [self addMonster:CGPointMake(150, 150)];
        [self addMonster:CGPointMake(225, 75)];
        
        // Initialize the hero and its physic abilities
        self.player = [[Hero alloc] init];
        SKSpriteNode *hero = [self.player setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
        [self addChild:hero];
        
        hero.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hero.frame.size.width/3];
        hero.physicsBody.friction = 0.0f;
        hero.physicsBody.restitution = 0.05f;
        hero.physicsBody.linearDamping = 0.1f;
        hero.physicsBody.mass = 0.05f;
        hero.physicsBody.allowsRotation = NO;
        
        
        hero.physicsBody.categoryBitMask = heroCategory;
        // borderBody.categoryBitMask = borderCategory;
        
        hero.physicsBody.contactTestBitMask = monsterCategory;
        
        self.physicsWorld.contactDelegate = self;
        
        
        SKLabelNode *tmp = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        tmp.fontSize = 16;
        tmp.text = @"HITS: 0";
        tmp.position = CGPointMake(150, 10);
        [self addChild:tmp];
        
        self.timer = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.timer.fontSize = 16;
        self.timer.text = @"TTIMER: 0";
        self.secTimer = 0;
        self.timer.position = CGPointMake(250, 10);
        [self addChild:self.timer];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
        
        //if a accelometer is found, start queueing data, and handling it with the given function
        if ([self.motionManager isAccelerometerAvailable] == YES) {
            [self setUpMotionManager];
        }
        
        

    }
    return self;
}

// Setup a listener for updates from the accelometer. All movements that are grater
// than 0.1 are passed on to the hero as vectors.
- (void) setUpMotionManager {
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                             withHandler:^(CMAccelerometerData *data, NSError *error) {
         if (error) {
             NSLog(@"%@",[error localizedDescription]);
         }
         
        if (fabs(data.acceleration.x) > 0.1 || fabs(data.acceleration.y) > 0.1) {
            [self.player.character.physicsBody applyForce:CGVectorMake(-50.0*data.acceleration.y, 50.0*data.acceleration.x)];
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

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;

        self.secTimer += 1;
        NSMutableString *tmpSecs = [NSMutableString stringWithString:@"TIMER: "];
        [tmpSecs appendFormat:@"%i", self.secTimer];
        self.timer.text = tmpSecs;
    }
}

- (void)update:(NSTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

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
    
    newMonster.character.physicsBody.categoryBitMask = monsterCategory;
    
    [self.monsterArray addObject:newMonster];
    
 }


- (void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 3 react to the contact between hero and monster
    if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == monsterCategory) {
        self.hitCount += 1;
        NSMutableString *tmpHits = [NSMutableString stringWithString:@"HITS: "];
        [tmpHits appendFormat:@"%i", self.hitCount];
        self.hits.text = tmpHits;
    }
    /*
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == blockCategory) {
        [secondBody.node removeFromParent];
        if ([self isGameWon]) {
            GameOverScene* gameWonScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:YES];
            [self.view presentScene:gameWonScene];
        }
    }
     */
}

@end
