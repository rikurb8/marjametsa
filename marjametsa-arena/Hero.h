//
//  Hero.h
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Character.h"
#import <SpriteKit/SpriteKit.h>

@interface Hero : Character
- (SKSpriteNode*)setUpSprite: (int)width
                      height:(int)height;
- (float)getXCoordinate;
- (float)getYCoordinate;
- (int)getHeight;
- (int)getWidth;
- (void)runAction: (SKAction*)action;

@end
