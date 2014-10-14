//
//  Hero.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Hero.h"

@interface Hero ()
@property (nonatomic) SKSpriteNode *player;

@end

@implementation Hero
- (SKSpriteNode*)setUpSprite: (int)width
                      height:(int)height{
    
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"hero"];
    self.player.position = CGPointMake(width/2, height/2);
    return self.player;
}

- (float)getXCoordinate {
    return self.player.position.x;
}

- (float)getYCoordinate {
    return self.player.position.y;
}

//if we just move, take coordinates not SKACtion
//if multiple actions used, keep like this. really unsafe tho
- (void)runAction: (SKAction*)action {
    [self.player runAction:action];
}

- (int)getHeight {
    return self.player.size.height;
}
- (int)getWidth {
    return self.player.size.width;
}

@end
