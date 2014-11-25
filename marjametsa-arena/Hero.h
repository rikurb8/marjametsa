//
//  Hero.h
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Character.h"

@interface Hero : Character

{
    int playerHealth;
    int coordinateX;
    int coordinateY;
}

- (id)initWithImage:(NSString*)image
          andHealth:(int)health
               andX:(int)x
               andY:(int)y;

- (void)setPhysicsAbilities;

- (void) unmountSpaceship;

- (int) getHealth;

@end


