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
#import "Highscore.h"   

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
    
    
    

    
    
    // Configure the view.
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        skView.showsPhysics = NO;
        
        // Create and configure the scene.
        //SKScene * scene =
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
