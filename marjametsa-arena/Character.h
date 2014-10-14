//
//  Character.h
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Character : NSObject
@property (nonatomic) NSString *image;
@property (nonatomic) SKSpriteNode *character;
- (SKSpriteNode*)setUpSprite: (int)width
                      height:(int)height;
- (float)getXCoordinate;
- (float)getYCoordinate;
- (int)getHeight;
- (int)getWidth;
- (void)runAction: (SKAction*)action;

@end
