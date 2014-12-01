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

@interface ViewController()

@property (strong, nonatomic) NSArray *monsterArray;


@end

@implementation ViewController



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    
    
    // ADD plist read temporarily. Check the correct place later
    
    NSString *plistName = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary *creatureDict = [[NSDictionary alloc] initWithContentsOfFile:plistName];
    
    self.monsterArray = creatureDict[@"Monster"];
   // id obj;
   // for (obj in self.monsterArray) {
        
    NSLog(self.monsterArray[0][@"Image"]);
    NSLog(self.monsterArray[0][@"Health"]);
    NSLog(self.monsterArray[0][@"xPosition"]);
    NSLog(self.monsterArray[0][@"yPosition"]);

   // }
    
    
    NSMutableArray *sceneArray = [[NSMutableArray alloc] initWithCapacity:15];
    
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
    
    
    [sceneArray addObject:scene];
    [sceneArray addObject:scene];
    [sceneArray addObject:scene];
    [sceneArray addObject:scene];
    
    // Configure the view.
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        skView.showsPhysics = NO;
        
        // Create and configure the scene.
        LevelSelectScene *scene = [[LevelSelectScene alloc] initWithSize:skView.bounds.size andLevelInfo:sceneArray];
        //SKScene * scene = [MenuScene sceneWithSize:skView.bounds.size];
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
