//
//  GameEndedScene.m
//  marjametsa-arena
//
//  Created by Ridge on 13.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "GameEndedScene.h"

@implementation GameEndedScene

-(id) initWithSize:(CGSize)size won:(BOOL)didWin {
    if (self = [super initWithSize:size]) {
        NSString *bgImage= @"";
        NSString *text = @"";
        //TODO: get other bg? for both?
        if (didWin) {
            bgImage = @"grass_bg.png";
            text = @"YAY! YOU WON!";
        } else {
            bgImage = @"grass_bg.png";
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
    }
    
    
    return self;
}


@end
