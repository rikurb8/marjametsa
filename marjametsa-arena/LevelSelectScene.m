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

@property (nonatomic) NSMutableArray *levels;

@end


@implementation LevelSelectScene


// Initialize Menu
-(id)initWithSize:(CGSize)size andLevelInfo:(NSMutableArray*)levelInfo {
    
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"space_bg"];
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bgImage];
        
    }
    
    self.levels = levelInfo;
    
    for (int i = 0; i < [levelInfo count]; ++i) {
        
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
    textLabel.fontSize = 42;
    textLabel.position = CGPointMake(width, height);
    textLabel.text = [NSString stringWithFormat:@"%d",buttonLevel+1];
    
    return textLabel;
 }






//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //TODO: actually get this DTO from an array containing all the level DTO's
    int level = [node.name intValue];
    SceneDTO* scene = [self.levels objectAtIndex:level];
    
    SKScene * Gscene = [[GameScene alloc] initWithSize:self.frame.size andInfo:scene];
    Gscene.scaleMode = SKSceneScaleModeAspectFill;
        
    // Present the scene.
    [self.view presentScene:Gscene];

    return;
}
@end




