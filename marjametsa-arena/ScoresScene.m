//
//  ScoresScene.m
//  marjametsa-arena
//
//  Created by HK on 12.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//


#import "MenuScene.h"
#import "GameScene.h"
#import "ViewController.h"
#import "ScoresScene.h"
#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface ScoresScene()


@end


@implementation ScoresScene



// Initialize HighScores
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"highscore_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
    }
    
    
    [self addChild: [self ButtonNode:@"Exit"]];
    UIButton *exitbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitbutton.frame =CGRectMake(100, 170, 100, 30);
    [exitbutton setTitle:@"exit" forState:UIControlStateNormal];
    [self.view addSubview:exitbutton];

    
    
    return self;
    
}


- (SKSpriteNode *)ButtonNode:(NSString *) buttonType
{
    
    if([buttonType isEqualToString:@"Exit"]){
        SKSpriteNode *ReturnToMenu = [SKSpriteNode spriteNodeWithImageNamed:@"exitButton.png"];
        ReturnToMenu.position = CGPointMake(500, 280);
        ReturnToMenu.name = @"Return";
        return ReturnToMenu;
    }
    return NULL;
}



// Function for buttons functionality
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    // Create new scene
    SKView * sView = (SKView *)self.view;
    SKScene * NextScene;
    
    
    //if ReturnToMenu touched
    if ([node.name isEqualToString:@"Return"]) {
        
        NextScene = [MenuScene sceneWithSize:sView.bounds.size];
        NextScene.scaleMode = SKSceneScaleModeAspectFill;
        
    }
    
    // Present the scene.
    [sView presentScene:NextScene];
    
    return;
}


@end