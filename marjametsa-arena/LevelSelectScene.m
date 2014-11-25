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
#import "Highscore.h"



//@import CoreMotion;
#import <UIKit/UIKit.h>


#define kUpdateInterval (1.0f / 60.0f) //60fps

@interface LevelSelectScene()


@end


@implementation LevelSelectScene


// Initialize Menu
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"space_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
    }
    
    //TODO: generic for loop for creating buttons
    
    for (int i = 0; i < 15; ++i) {
        
        [self addChild: [self ButtonNode:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Click me" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    
    return self;
    
}

- (SKSpriteNode *)ButtonNode:(int) buttonLevel
{

    int width = 75 + (buttonLevel % 5) *90;
    int height = 250;
    
    if (buttonLevel >= 10) {
        height = 100;
    } else if (buttonLevel >= 5) {
        height = 175;
    }
    
    SKSpriteNode *levelNode = [SKSpriteNode spriteNodeWithImageNamed:@"banana.png"];
    levelNode.position = CGPointMake(width, height);
    levelNode.name = [NSString stringWithFormat:@"%d",buttonLevel];
    return levelNode;
 }






//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    NSLog(node.name);
    
    int level = [node.name intValue];
    
    SKScene * Gscene = [[GameScene alloc] initWithSize:self.frame.size];
    Gscene.scaleMode = SKSceneScaleModeAspectFill;
        
    // Present the scene.
    [self.view presentScene:Gscene];

    return;
}
@end




