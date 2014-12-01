//
//  MyScene.m
//  marjametsa-arena
//
//  Created by Ridge on 24.9.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "GameScene.h"
#import "GameEndedScene.h"
#import "Hero.h"
#import "Monster.h"
#import "Boss.h"
#import "Item.h"
#import "Constants.h"

#import "MonsterDTO.h"
#import "HeroDTO.h"

@import CoreMotion;

#define kPlayerSpeed 700
#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface GameScene ()
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


@implementation GameScene

-(void)createMonster: (NSTimer *) timer {
    MonsterDTO *monster = [MonsterDTO alloc];

    monster.x = 150;
    monster.y = 150;
    monster.image = @"monsterInSpace";
    monster.movePattern = 2;
    monster.colorizeSequence = 1.0f;
    
    [self addMonster:monster.image
                   x:monster.x
                   y:monster.y
         movePattern:monster.movePattern
    colorizeSequence:monster.colorizeSequence];

}

-(void)bananaSpawner: (NSTimer *) timer {
    Item *newItem = [[Item alloc] init];
    
    newItem.character = [newItem setUpSprite:self.frame.size.width/2 height:self.frame.size.height/2];
    
    [newItem setUpAI];
    
    [self addChild:newItem.character];
    
    newItem.character.physicsBody.categoryBitMask = itemCategory;
}

-(id)initWithSize:(CGSize)size andInfo:(SceneDTO*)sceneInfo {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"space_bg.png"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        // Overall physic utilization
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0f;
        
        self.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (MonsterDTO *monster in sceneInfo.monsterArray) {
            [self addMonster:monster.image
                           x:monster.x
                           y:monster.y
                 movePattern:monster.movePattern
            colorizeSequence:monster.colorizeSequence];
        }

        HeroDTO *hero = sceneInfo.hero;
        
        [self addHero:hero.image
               health:hero.health
                    x:hero.x
                    y:hero.y];
         
        self.physicsWorld.contactDelegate = self;
        
        self.hits = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.hits.fontSize = 16;
        self.hits.text = [NSString stringWithFormat:@"LIVES: %d/%d", self.player.getHealth - self.hitCount, self.player.getHealth];
        
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
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(createMonster:) userInfo:nil repeats:YES];
        
        //Health! FUCK YEAH!
        NSTimer *bananaTimer;
        bananaTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(bananaSpawner:) userInfo:nil repeats:YES];
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

- (void)addMonster:(NSString*)image
                 x:(int)x
                 y:(int)y
       movePattern:(int)pattern
  colorizeSequence:(float)cSeq{
    
    Monster *newMonster = [[Monster alloc] initWithImage:image
                                            andColorizeSequence:cSeq
                                            andMovePattern:pattern
                                                    andX:x
                                                    andY:y ];
    
    [newMonster setUpAI];
    
    [self addChild:newMonster.character];
    
    [newMonster setName:[self.monsterArray count]];
    
    self.aliveMonsters += 1;
    
    [self.monsterArray addObject:newMonster];
    
 }

- (void)addHero:(NSString*)image
         health:(int)health
              x:(int)x
              y:(int)y {

    self.player = [[Hero alloc] initWithImage:image
                                    andHealth:health
                                         andX:x
                                         andY:y];
    
    SKSpriteNode *hero = [self.player setUpSprite:x height:y];
    [self.player setPhysicsAbilities];
    [self addChild:hero];
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
                    
                } else {
                    self.hitCount += 1;
                    NSMutableString *tmpHits = [NSMutableString stringWithString:@"LIVES: "];
                    int livesLeft = self.player.getHealth - self.hitCount;
                    [tmpHits appendFormat:@"%i", livesLeft];
                    [tmpHits appendString:[NSString stringWithFormat: @"/%d", self.player.getHealth]];
                    self.hits.text = tmpHits;
                }
            }
        }
        
        //TODO: maybe we should get a cool hit sound
        AudioServicesPlaySystemSound(1104);
        [self vibrate];
        
        if (self.hitCount >= self.player.getHealth) {
            GameEndedScene* gameWon = [[GameEndedScene alloc] initWithSize:self.frame.size won:NO];
            [self.view presentScene:gameWon];
            
        } else if (self.aliveMonsters <= 0) {
            GameEndedScene* gameWon = [[GameEndedScene alloc] initWithSize:self.frame.size won:YES];
            [self.view presentScene:gameWon];
        }
    } else if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == itemCategory) {
        [secondBody.node removeFromParent];
        self.hitCount -= 1;
    }
    
    
}

@end
