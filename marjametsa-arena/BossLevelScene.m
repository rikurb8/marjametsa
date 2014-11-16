//
//  BossLevelScene.m
//  marjametsa-arena
//
//  Created by Ridge on 16.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "BossLevelScene.h"
#import "GameScene.h"
#import "GameEndedScene.h"
#import "Hero.h"
#import "Monster.h"
#import "Boss.h"
#import "Banana.h"

@import CoreMotion;

#define kPlayerSpeed 700
#define kUpdateInterval (1.0f / 60.0f) //60fps

static const uint32_t heroCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t monsterCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t bananaCategory = 0x1 << 2; // 0000000000000000000000000000100
static const uint32_t bossCategory = 0x1 << 3; // 0000000000000000000000000001000


@interface BossLevelScene ()
@property (nonatomic) Hero *player;
@property (nonatomic) NSMutableArray *monsterArray;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) int hitCount;
@property (nonatomic) int secTimer;
@property (nonatomic) SKLabelNode *hits;
@property (nonatomic) SKLabelNode *timer;

@property (nonatomic) int aliveMonsters;
- (void) vibrate;

@end


@implementation BossLevelScene

-(void)createObstacle: (NSTimer *) timer {
    [self addMonster:CGPointMake(400, 150)];
}

-(void)bananaSpawner: (NSTimer *) timer {
    Banana *newBanana = [[Banana alloc] init];
    
    newBanana.character = [newBanana setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
    
    [newBanana setUpAI];
    
    [self addChild:newBanana.character];
    
    newBanana.character.physicsBody.categoryBitMask = bananaCategory;
}

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"dungeon_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        // Overall physic utilization
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0f;
        
        self.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Initialize the hero and its physic abilities
        self.player = [[Hero alloc] init];
        [self.player unmountSpaceship];
        SKSpriteNode *hero = [self.player setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
        [self addChild:hero];
        
        CGSize tmp = CGSizeMake(hero.frame.size.width*0.95, hero.frame.size.height*0.95);
        
        
        hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tmp];
        
        //hero.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:hero.frame.size.width/3];
        hero.physicsBody.friction = 0.0f;
        hero.physicsBody.restitution = 0.05f;
        hero.physicsBody.linearDamping = 0.1f;
        hero.physicsBody.mass = 0.05f;
        hero.physicsBody.allowsRotation = YES;
        
        hero.physicsBody.categoryBitMask = heroCategory;
        // borderBody.categoryBitMask = borderCategory;

        Boss *boss = [[Boss alloc] init];
        
        boss.character = [boss setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
        
        [boss setUpAI];
        
        [self addChild:boss.character];
        
        boss.character.physicsBody.categoryBitMask = bossCategory;

        
        hero.physicsBody.contactTestBitMask = monsterCategory | bananaCategory;
        
        self.physicsWorld.contactDelegate = self;
        
        self.hits = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.hits.fontSize = 16;
        self.hits.text = @"LIVES: 10/10";
        self.hits.position = CGPointMake(150, 10);
        [self addChild:self.hits];
        
        self.timer = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.timer.fontSize = 16;
        self.timer.text = @"POINTS: 0";
        self.secTimer = 0;
        self.timer.position = CGPointMake(250, 10);
        [self addChild:self.timer];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
        
        //if a accelometer is found, start queueing data, and handling it with the given function
        if ([self.motionManager isAccelerometerAvailable] == YES) {
            [self setUpMotionManager];
        }
        
        // Extra monsters!
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(createObstacle:) userInfo:nil repeats:YES];
        
        //Health! FUCK YEAH!
        NSTimer *bananaTimer;
        bananaTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(bananaSpawner:) userInfo:nil repeats:YES];
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

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.1) {
        self.lastSpawnTimeInterval = 0;
        
        self.secTimer += 1;
        NSMutableString *tmpSecs = [NSMutableString stringWithString:@"POINTS: "];
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
    
    newMonster.character.physicsBody.categoryBitMask = monsterCategory;
    
    
    [newMonster setName:[self.monsterArray count]];
    
    self.aliveMonsters += 1;
    
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
        for (Monster *monster in self.monsterArray){
            if([secondBody.node.name isEqualToString:[monster getName]]) {
                if ([monster isVulnerable]) {
                    [monster.character removeFromParent];
                    self.aliveMonsters -= 1;
                    
                    //TODO: remove monster from array? do we need monsterArray? what the fuck?
                } else {
                    self.hitCount += 1;
                    NSMutableString *tmpHits = [NSMutableString stringWithString:@"LIVES: "];
                    int livesLeft = 10 - self.hitCount;
                    [tmpHits appendFormat:@"%i", livesLeft];
                    [tmpHits appendString:@"/10"];
                    self.hits.text = tmpHits;
                }
            }
        }
        
        //TODO: maybe we should get a cool hit sound
        AudioServicesPlaySystemSound(1104);
        [self vibrate];
        
        if (self.hitCount >= 10) {
            GameEndedScene* gameWon = [[GameEndedScene alloc] initWithSize:self.frame.size won:NO];
            [self.view presentScene:gameWon];
            
        } else if (self.aliveMonsters <= 0) {
            GameEndedScene* gameWon = [[GameEndedScene alloc] initWithSize:self.frame.size won:YES];
            [self.view presentScene:gameWon];
        }
    } else if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == bananaCategory) {
        [secondBody.node removeFromParent];
        self.hitCount -= 1;
    }
    
    
}

@end
