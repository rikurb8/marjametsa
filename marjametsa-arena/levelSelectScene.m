//
//  levelSelectScene.m
//  marjametsa-arena
//
//  Created by HK on 12.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//
// Viev for Selecting Level

#import "MenuScene.h"
#import "GameScene.h"
#import "ScoresScene.h"
#import "ViewController.h"
#import "levelSelectScene.h"

#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface levelSelectScene()


@end


@implementation levelSelectScene


// Initialize Level Select View
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"simple_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
    }
    
    // Add level 1 - button
    [self addChild: [self ButtonNode:@"Level_1"]];
    UIButton *button_level1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button_level1.frame =CGRectMake(100, 170, 100, 30);
    [button_level1 setTitle:@"Level_1" forState:UIControlStateNormal];
    [self.view addSubview:button_level1];
    
    // Add level 2 - button
    [self addChild: [self ButtonNode:@"Level_2"]];
    UIButton *button_level2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button_level1.frame =CGRectMake(100, 170, 100, 30);
    [button_level1 setTitle:@"Level_2" forState:UIControlStateNormal];
    [self.view addSubview:button_level2];
    
    // Add level 3 - button
    [self addChild: [self ButtonNode:@"Level_3"]];
    UIButton *button_level3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button_level1.frame =CGRectMake(100, 170, 100, 30);
    [button_level1 setTitle:@"Level_3" forState:UIControlStateNormal];
    [self.view addSubview:button_level3];
    
    
    // Add button to returning Main menu
    [self addChild: [self ButtonNode:@"Exit"]];
    UIButton *exitbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitbutton.frame =CGRectMake(100, 170, 100, 30);
    [exitbutton setTitle:@"exit" forState:UIControlStateNormal];
    [self.view addSubview:exitbutton];
    
    
    
    return self;
    
}


// Initialize buttons by type
- (SKSpriteNode *)ButtonNode:(NSString *) buttonType
{
    if([buttonType isEqualToString:@"Exit"]){
        SKSpriteNode *ReturnToMenu = [SKSpriteNode spriteNodeWithImageNamed:@"exitButton.png"];
        ReturnToMenu.position = CGPointMake(500, 280);
        ReturnToMenu.name = @"Return";
        return ReturnToMenu;
    }else if([buttonType isEqualToString:@"Level_1"]){
        SKSpriteNode * Node = [SKSpriteNode spriteNodeWithImageNamed:@"level_1"];
        Node.position = CGPointMake(130, 140);
        Node.name = @"level_1";
        return Node;
    }else if([buttonType isEqualToString:@"Level_2"]){
        SKSpriteNode *Node = [SKSpriteNode spriteNodeWithImageNamed:@"level_2"];
        Node.position = CGPointMake(290, 140);
        Node.name = @"level_2";
        return Node;
    }else if([buttonType isEqualToString:@"Level_3"]){
        SKSpriteNode *Node = [SKSpriteNode spriteNodeWithImageNamed:@"level_3"];
        Node.position = CGPointMake(450, 140);
        Node.name = @"level_3";
        return Node;
    }

    return NULL;
}




// If buttons touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Create new scene, which used when button pressed
    SKView * sView = (SKView *)self.view;
    SKScene * NextScene;
    
    // Check which button touched and act accordingly
    if ([node.name isEqualToString:@"Return"]) {
        NextScene = [MenuScene sceneWithSize:sView.bounds.size];
        NextScene.scaleMode = SKSceneScaleModeAspectFill;
    
    }else if ([node.name isEqualToString:@"level_1"] || [node.name isEqualToString:@"level_2"]
               || [node.name isEqualToString:@"level_3"] ) {
        NextScene = [GameScene sceneWithSize:sView.bounds.size];
        NextScene.scaleMode = SKSceneScaleModeAspectFill;
    }
    

    // Present the scene.
    [sView presentScene:NextScene];
    
    
    return;
}



@end