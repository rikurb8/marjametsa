//
//  MenuScene.m
//  marjametsa-arena
//
//  Created by HK on 14.10.2014 by Henkka
//  Copyright (c). All rights reserved.
//



#import "MenuScene.h"
#import "GameScene.h"
#import "ScoresScene.h"
#import "ViewController.h"
#import "levelSelectScene.h"

#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface MenuScene()


@end


@implementation MenuScene


// Initialize Menu
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"grass_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];

    }
 
    // Add MenuButton
    [self addChild: [self ButtonNode:@"Menu"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame =CGRectMake(100, 170, 100, 30);
    [button setTitle:@"menu" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self addChild: [self ButtonNode:@"Exit"]];
    UIButton *exitbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitbutton.frame =CGRectMake(100, 170, 100, 30);
    [exitbutton setTitle:@"exit" forState:UIControlStateNormal];
    [self.view addSubview:exitbutton];
    
    
    [self addChild: [self ButtonNode:@"bestPlayers"]];
    UIButton *bestplayers = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bestplayers.frame =CGRectMake(100, 170, 100, 30);
    [bestplayers setTitle:@"best" forState:UIControlStateNormal];
    [self.view addSubview:bestplayers];
    
    

    
    
    return self;

}


// Menu Button node
- (SKSpriteNode *)ButtonNode:(NSString *) buttonType
{
    if([buttonType isEqualToString:@"Menu"]){
    SKSpriteNode *MenuNode = [SKSpriteNode spriteNodeWithImageNamed:@"StartButton.png"];
    MenuNode.position = CGPointMake(300, 200);
    MenuNode.name = @"startButton";//how the node is identified later
    
    
    return MenuNode;
    }else if([buttonType isEqualToString:@"Exit"]){
        SKSpriteNode *ExitNode = [SKSpriteNode spriteNodeWithImageNamed:@"exitButton.png"];
        ExitNode.position = CGPointMake(300, 80);
        ExitNode.name = @"exitButton";
        return ExitNode;
    
    }else if([buttonType isEqualToString:@"bestPlayers"]){
        SKSpriteNode *BestNode = [SKSpriteNode spriteNodeWithImageNamed:@"bestPlayers.png"];
        BestNode.position = CGPointMake(300, 140);
        BestNode.name = @"BestPlayers";
        return BestNode;
    }
    return NULL;
}






//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if StartButton touched start the GameScene
    if ([node.name isEqualToString:@"startButton"]) {
        
        // Create new scene
        SKView * sView = (SKView *)self.view;
        SKScene * levelSelectscene = [levelSelectScene sceneWithSize:sView.bounds.size];
        levelSelectscene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [sView presentScene:levelSelectscene];
    }
    
    // if highScores is pressed
    if ([node.name isEqualToString:@"BestPlayers"]) {
        
        SKView * sView = (SKView *)self.view;
        SKScene * Sscene = [ScoresScene sceneWithSize:sView.bounds.size];
        Sscene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [sView presentScene:Sscene];
        
        
    }
    // if Exit is pressed quit the game
    if ([node.name isEqualToString:@"exitButton"]) {
        exit(0);
    }

    
    
    return;
}
@end



