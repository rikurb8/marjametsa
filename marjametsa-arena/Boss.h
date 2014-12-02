//
//  Boss.h
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Monster.h"

@interface Boss : Monster {

    int health;
}

- (id)initWithImage:(NSString *)image
          andHealth:(int)hlth
andColorizeSequence:(float)cSequence
     andMovePattern:(int)mPattern
               andX:(int)x
               andY:(int)y;

-(void) setUpAI;

- (int) getHealth;
@end
