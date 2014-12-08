//
//  MenuScene.m
//  marjametsa-arena
//
//  Created on 14.10.2014 by Henkka
//  Copyright (c). All rights reserved.
//



#import "MenuScene.h"
#import "GameScene.h"
#import "ViewController.h"
#import "Hero.h"
#import "Highscore.h"   
#import "LevelSelectScene.h"



//@import CoreMotion;
#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface MenuScene()


@end


@implementation MenuScene


// Initialize Menu
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background-568h@2x"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];

    }
 
    // Add MenuButton
    [self addChild: [self ButtonNode:@"Menu"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame =CGRectMake(100, 170, 100, 30);
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self addChild: [self ButtonNode:@"Highscore"]];
    UIButton *highbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    highbutton.frame =CGRectMake(100, 170, 100, 30);
    [highbutton setTitle:@"Click me" forState:UIControlStateNormal];
    [self.view addSubview:highbutton];
    
    return self;

}

- (SKSpriteNode *)ButtonNode:(NSString *) buttonType
{
    if([buttonType isEqualToString:@"Menu"]){
    SKSpriteNode *MenuNode = [SKSpriteNode spriteNodeWithImageNamed:@"bestPlayButton.png"];
    MenuNode.position = CGPointMake(280, 180);
    MenuNode.name = @"startButton";//how the node is identified later
    
    return MenuNode;
    }else if([buttonType isEqualToString:@"Highscore"]){
        SKSpriteNode *ExitNode = [SKSpriteNode spriteNodeWithImageNamed:@"bestHighscoreButton.png"];
        ExitNode.position = CGPointMake(280, 120);
        ExitNode.name = @"hiscoreButton";
        return ExitNode;
    
    }
    
    return nil;
}






//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if StartButton touched start the GameScene
    if ([node.name isEqualToString:@"startButton"]) {
               SKView * sView = (SKView *)self.view;

        
        SKScene * Gscene = [LevelSelectScene sceneWithSize:sView.bounds.size];
        Gscene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [sView presentScene:Gscene];
        
        
    }

    return;
}
@end



