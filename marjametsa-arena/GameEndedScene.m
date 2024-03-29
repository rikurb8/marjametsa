//
//  GameEndedScene.m
//  marjametsa-arena
//
//  Created by Ridge on 13.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "GameEndedScene.h"
#import "GameScene.h"
#import "LevelSelectScene.h"

@implementation GameEndedScene

-(id) initWithSize:(CGSize)size won:(BOOL)didWin {
    if (self = [super initWithSize:size]) {
        NSString *bgImage= @"";
        NSString *text = @"";
        //TODO: get other bg? for both?
        if (didWin) {
            bgImage = @"space_bg.png";
            text = @"YAY! YOU WON!";
            
        } else {
            bgImage = @"space_bg.png";
            text = @"HAAHAA! YOU LOST!";
        }
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:bgImage];
        bg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:bg];
        
        SKLabelNode* textLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        textLabel.fontSize = 42;
        textLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        textLabel.text = text;
        
        [self addChild:textLabel];
        
        // Add MenuButton
        [self addChild: [self ButtonNode:@"Menu"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame =CGRectMake(100, 170, 100, 30);
        [button setTitle:@"Click me" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    return self;
}
- (SKSpriteNode *)ButtonNode:(NSString *) buttonType
{
    SKSpriteNode *button;
    
    if([buttonType isEqualToString:@"Menu"]){
        button = [SKSpriteNode spriteNodeWithImageNamed:@"bestPlayButton.png"];
        button.position = CGPointMake(275, 80);
        button.name = @"startButton";
    
    }
    
    return button;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *pressedNode = [self nodeAtPoint:location];
    
    if ([pressedNode.name isEqualToString:@"startButton"]) {
        SKView *sView = (SKView *)self.view;
        SKScene *Gscene = [LevelSelectScene sceneWithSize:sView.bounds.size];
        Gscene.scaleMode = SKSceneScaleModeAspectFill;
        
        [sView presentScene:Gscene];
    }
    
    if ([pressedNode.name isEqualToString:@"nextLevel"]) {
        exit(0);
    }
    
    
    if ([pressedNode.name isEqualToString:@"exitButton"]) {
        exit(0);
    }
    return;
}

@end
