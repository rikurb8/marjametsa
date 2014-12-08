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
#import "GameDTO.h"
#import "SceneDTO.h"
#import "ItemDTO.h"


//@import CoreMotion;
#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface LevelSelectScene()

@property (strong, nonatomic) NSArray *levelsArray;
@property (strong, nonatomic) NSDictionary *selectedLevel;
@property (strong, nonatomic) NSArray *monsterArray;
@property (strong, nonatomic) NSArray *itemArray;


@property (strong, nonatomic) NSDictionary *heroDict;
@property NSMutableArray *monsterObjectArray;
@property NSMutableArray *itemObjectArray;

@end


@implementation LevelSelectScene


// Initialize Menu
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"space_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
    }
    
    NSString *plistName = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistName];
    
    //TODO: get amount of levels from plistfile
    for (int i = 0; i < [dict count]; ++i) {
        
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
    textLabel.fontSize = 75;
    textLabel.position = CGPointMake(width, height);
    textLabel.text = [NSString stringWithFormat:@"%d",buttonLevel+1];
    textLabel.name = [NSString stringWithFormat:@"%d", buttonLevel+1];
    
    return textLabel;
 }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // If we didn't click anything smart
    if (node.name == nil) {
        return;
    }
    
    //Create and read plist
    NSString *plistName = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistName];
        
    // Pick level from .plist file
    self.selectedLevel = [[NSMutableDictionary alloc] init];
    _selectedLevel = (dict[node.name]);
    
    // Lets pick monsters from level
    self.monsterArray = ([_selectedLevel objectForKey:@"monsters"]);
    self.monsterObjectArray = [[NSMutableArray alloc] init];
    // Also items must be picked
    self.itemArray = ([_selectedLevel objectForKey:@"items"]);
    self.itemObjectArray = [[NSMutableArray alloc] init];
    
    // Pick hero from plist
    self.heroDict = ([_selectedLevel objectForKey:@"hero"]);
    
    // Background image for level
    GameDTO * game = [GameDTO alloc];
    NSString * bg_image = ([_selectedLevel objectForKey:@"bg_image"]);
    game.image = bg_image;
    
    // Loop through monsters, and add them to array
    id obj;
    int i = 0;
    for (obj in _monsterArray) {
        
        MonsterDTO *monster = [MonsterDTO alloc];
        monster.x = [obj[@"x"] integerValue];
        monster.y = [obj[@"y"] integerValue];
        monster.image = obj[@"image"];
        monster.health = [obj[@"health"] integerValue];
        monster.colorizeSequence = [obj[@"colorizeSequence"] floatValue];
        monster.movePattern = [obj[@"movePattern"] integerValue];
        
        [self.monsterObjectArray addObject:monster];
        i += 1;
    }
    
    // Create hero object
    self.heroDict = [[NSMutableDictionary alloc] init];
    self.heroDict = ([_selectedLevel objectForKey:@"hero"]);
    
    HeroDTO *hero = [HeroDTO alloc];
    hero.health = [_heroDict[@"health"] integerValue];
    hero.x = [_heroDict[@"x"] integerValue];
    hero.y = [_heroDict[@"y"] integerValue];
    hero.image = _heroDict[@"image"];
    
    // Next loop through all items, and add them to array
    id obj2;
    int loop = 0;
    for (obj2 in _itemArray) {
        
        ItemDTO *item = [ItemDTO alloc];
        item.x = [obj2[@"x"] integerValue];
        item.y = [obj2[@"y"] integerValue];
        item.image = obj2[@"image"];
        item.type = [obj2[@"type"] integerValue];
        [self.itemObjectArray addObject:item];
        loop += 1;
    }
    
    SceneDTO * newScene = [[SceneDTO alloc] init];
    newScene.monsterArray = _monsterObjectArray;
    newScene.itemArray = _itemObjectArray;
    newScene.hero = hero;
    newScene.game = game;

    SKScene * Gscene = [[GameScene alloc] initWithSize:self.frame.size andInfo:newScene];
    Gscene.scaleMode = SKSceneScaleModeAspectFill;
        
    // Present the scene.
    [self.view presentScene:Gscene];

    return;
}
@end




