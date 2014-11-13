//
//  Character.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Character.h"

@interface Character ()

@end

@implementation Character

- (SKSpriteNode*)setUpSprite: (int)width
                      height:(int)height{
    self.character = [SKSpriteNode spriteNodeWithImageNamed:self.image];
    self.character.position = CGPointMake(width, height);
    return self.character;
}

- (float)getXCoordinate {
    return self.character.position.x;
}

- (float)getYCoordinate {
    return self.character.position.y;
}

- (void)runAction: (SKAction*)action {
    [self.character runAction:action];
}

- (int)getHeight {
    return self.character.size.height;
}
- (int)getWidth {
    return self.character.size.width;
}

@end
