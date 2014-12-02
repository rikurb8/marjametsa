//
//  ViewController.m
//  marjametsa-arena
//
//  Created by Ridge on 24.9.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "LevelSelectScene.h"
#import "Highscore.h"   
#import "SceneDTO.h"
#import "MonsterDTO.h"
#import "HeroDTO.h"
#import "ItemDTO.h"

#import "MonsterDTO.h"
#import "HeroDTO.h"
#import "ItemDTO.h"
#import "GameDTO.h" 
#import "SceneDTO.h"

@interface ViewController()


@property (strong, nonatomic) NSArray *levelsArray;
@property (strong, nonatomic) NSDictionary *selectedLevel;
@property (strong, nonatomic) NSArray *monsterArray;
@property (strong, nonatomic) NSArray *itemArray;


@property (strong, nonatomic) NSDictionary *heroDict;
@property NSMutableArray *monsterObjectArray;
@property NSMutableArray *itemObjectArray;
@property NSMutableArray *scenesArray;



@end

@implementation ViewController



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Create and read plist
    NSString *plistName = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistName];
    
    // Initialize scenes array...
    self.scenesArray = [[NSMutableArray alloc] init];

    
    // Pick level from .plist file
    self.selectedLevel = [[NSMutableDictionary alloc] init];
    _selectedLevel = (dict[@"level1"]);
    
    
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
    
    
    // PUSH one level to array. DELETE THIS
    [self.scenesArray addObject:newScene];

    // Configure the view.
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        skView.showsPhysics = NO;
        
        // Create and configure the scene.
        SKScene * scene = [MenuScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
