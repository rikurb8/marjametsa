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
#import "ItemDTO.h"


@import CoreMotion;

#define kPlayerSpeed 700
#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface GameScene ()
@property (nonatomic) Hero *player;
@property (nonatomic) Boss *boss;
@property (nonatomic) NSMutableArray *monsterArray;
@property (nonatomic) NSMutableArray *itemArray;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) int hitCount;
@property (nonatomic) int secTimer;
@property (nonatomic) int bossHealth;
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
    monster.image = @"monster2.png";
    monster.movePattern = 2;
    monster.colorizeSequence = 1.0f;
    
    [self addMonster:monster.image
                   x:monster.x
                   y:monster.y
         movePattern:monster.movePattern
    colorizeSequence:monster.colorizeSequence];

}

-(void)bananaSpawner: (NSTimer *) timer {
    
    ItemDTO *item = [ItemDTO alloc];
    
    item.image = @"banana.png";
    item.type = 1;
    item.x = 200;
    item.y = 200;
    
    [self addItem:item.image
           effect:item.type
                x:item.x
                y:item.y];
    
}

-(id)initWithSize:(CGSize)size andInfo:(SceneDTO*)sceneInfo {
    
    if (self = [super initWithSize:size]) {
        
        //set the bg image and position it
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:sceneInfo.game.image];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
        // Overall physic utilization
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0f;
        
        self.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.itemArray = [[NSMutableArray alloc] initWithCapacity:10];
                
        // Add found monsters from plist file
        for (MonsterDTO *monster in sceneInfo.monsterArray) {
            [self addMonster:monster.image
                           x:monster.x
                           y:monster.y
                 movePattern:monster.movePattern
            colorizeSequence:monster.colorizeSequence];
        }

        for (ItemDTO *item in sceneInfo.itemArray) {
            [self addItem:item.image
                   effect:item.type
                        x:item.x
                        y:item.y];
        }

        [self addHero:sceneInfo.hero.image
               health:sceneInfo.hero.health
                    x:sceneInfo.hero.x
                    y:sceneInfo.hero.y];
        
        if (sceneInfo.boss != nil) {
            [self addBoss:sceneInfo.boss.image
                      health:sceneInfo.boss.health
                           x:sceneInfo.boss.x
                           y:sceneInfo.boss.y
                 movePattern:sceneInfo.boss.movePattern
            colorizeSequence:sceneInfo.boss.colorizeSequence];
        }
        
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
- (void)addItem:(NSString*)image
         effect:(int)eff
              x:(int)x
              y:(int)y {

    
    Item *newItem = [[Item alloc] initWithImage:image
                                      andEffect:eff
                                           andX:x
                                           andY:y];
    
    
    
    [newItem setUp];
    
    [self addChild:newItem.character];
    
    [newItem setName:[self.itemArray count]];
    
    [self.itemArray addObject:newItem];
}

- (void)addBoss:(NSString*)image
         health:(int)health
              x:(int)x
              y:(int)y
    movePattern:(int)pattern
colorizeSequence:(float)cSeq{
    
    self.boss = [[Boss alloc] initWithImage:image
                                  andHealth:health
                        andColorizeSequence:cSeq
                             andMovePattern:pattern
                                       andX:x
                                       andY:y ];
    
    [self.boss setUpAI];
    
    self.bossHealth = [self.boss getHealth];
    
    [self addChild:self.boss.character];
}


- (void)didBeginContact:(SKPhysicsContact*)contact {
    
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    NSMutableString *tmpHits = [NSMutableString stringWithString:@"LIVES: "];
    int livesLeft;
    
    if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == monsterCategory) {
        
        for (Monster *monster in self.monsterArray){
            if([secondBody.node.name isEqualToString:[monster getName]]) {
                //TODO: maybe we should get a cool hit sound
                AudioServicesPlaySystemSound(1104);
                if ([monster isVulnerable]) {
                    [monster.character removeFromParent];
                    self.aliveMonsters -= 1;
                    
                } else {
                    [self vibrate];
                    
                    self.hitCount += 1;
                }
            }
        }
    } else if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == itemCategory) {
        
        for (Item *item in self.itemArray){
            if([secondBody.node.name isEqualToString:[item getName]]) {
                //TODO: maybe we should get a cool hit sound
                AudioServicesPlaySystemSound(1104);
                
                [item.character removeFromParent];
                
                if([item getEffect] > 0){
                    
                    if([item getEffect] > self.hitCount){
                        self.hitCount = 0;
                    } else {
                        self.hitCount -= [item getEffect];
                    }
                    
                } else {
                    [self vibrate];
                    self.hitCount += [item getEffect];
                }
            }
        }
      
    } else if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == bossCategory) {
    
        AudioServicesPlaySystemSound(1104);
        if([self.boss isVulnerable]){
            self.bossHealth -= 1;
            
            if(self.bossHealth <= 0){
                [self.boss.character removeFromParent];
            }
        } else {
            [self vibrate];
            self.hitCount += 2;
        }
    }
    
    livesLeft = self.player.getHealth - self.hitCount;
    [tmpHits appendFormat:@"%i", livesLeft];
    [tmpHits appendString:[NSString stringWithFormat: @"/%d", self.player.getHealth]];
    self.hits.text = tmpHits;
    
    if (self.hitCount >= self.player.getHealth) {
        GameEndedScene* gameEnded = [[GameEndedScene alloc] initWithSize:self.frame.size won:NO];
        [self.view presentScene:gameEnded];
        
    } else if (self.aliveMonsters <= 0 && self.boss == nil) {
        NSLog(@"boss == nil");
        GameEndedScene* gameWon = [[GameEndedScene alloc] initWithSize:self.frame.size won:YES];
        [self.view presentScene:gameWon];
        
    } else if (self.aliveMonsters <= 0 && self.bossHealth <= 0){
        NSLog(@"bossHealth <= 0");
        GameEndedScene* gameWon = [[GameEndedScene alloc] initWithSize:self.frame.size won:YES];
        [self.view presentScene:gameWon];
    }
}

@end
