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
