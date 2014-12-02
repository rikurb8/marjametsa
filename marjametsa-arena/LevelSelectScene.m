//
//  LevelSelectScene.m
//  marjametsa-arena
//
//  Created by Ridge on 25.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "LevelSelectScene.h"
#import "GameScene.h"
#import "ViewController.h"
#import "Hero.h"
#import "MonsterDTO.h"
#import "ItemDTO.h"
#import "Highscore.h"



//@import CoreMotion;
#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface LevelSelectScene()

@property (nonatomic) NSMutableArray *levels;

@end


@implementation LevelSelectScene


// Initialize Menu
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"space_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
    }
    
    //TODO: get amount of levels from plistfile
    for (int i = 0; i < 10; ++i) {
        
        [self addChild: [self ButtonNode:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Click me" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    
    return self;
    
}

- (SKLabelNode *)ButtonNode:(int) buttonLevel
{
    int width = 90 + (buttonLevel % 5) *90;
    int height = 225;
    
    if (buttonLevel >= 10) {
        height = 75;
    } else if (buttonLevel >= 5) {
        height = 150;
    }
    
    SKLabelNode* textLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    textLabel.fontSize = 42;
    textLabel.position = CGPointMake(width, height);
    textLabel.text = [NSString stringWithFormat:@"%d",buttonLevel+1];
    
    return textLabel;
 }






//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //TODO: actually get this DTO from an array containing all the level DTO's
    int level = [node.name intValue];
    
    //Mock sceneDTO to represent entire level info read from plist
    SceneDTO *scene = [SceneDTO alloc];
    
    scene.game = [GameDTO alloc];
    scene.game.image = @"space_bg";
    
    scene.hero = [HeroDTO alloc];
    scene.hero.image = @"heroInSpace";
    scene.hero.health = 5;
    scene.hero.x = 200;
    scene.hero.y = 200;
    
    //Couple of mock monsters
    MonsterDTO *monster = [MonsterDTO alloc];
    monster.x = 150;
    monster.y = 150;
    monster.image = @"monsterInSpace";
    monster.movePattern = 2;
    monster.colorizeSequence = 1.0f;
    
    MonsterDTO *monster2 = [MonsterDTO alloc];
    monster2.x = 250;
    monster2.y = 250;
    monster2.image = @"monsterInSpace";
    monster2.movePattern = 2;
    monster2.colorizeSequence = 1.0f;
    
    scene.monsterArray = [[NSMutableArray alloc] initWithCapacity:10];
    [scene.monsterArray addObject:monster];
    [scene.monsterArray addObject:monster2];
    
    ItemDTO *item = [ItemDTO alloc];
    item.image = @"asteroid.png";
    item.type = 0;
    item.x = 200;
    item.y = 150;
    
    scene.itemArray = [[NSMutableArray alloc] initWithCapacity:100];
    [scene.itemArray addObject:item];

    SKScene * Gscene = [[GameScene alloc] initWithSize:self.frame.size andInfo:scene];
    Gscene.scaleMode = SKSceneScaleModeAspectFill;
        
    // Present the scene.
    [self.view presentScene:Gscene];

    return;
}
@end




