//
//  Banana.h
//  marjametsa-arena
//
//  Created by Ridge on 14.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Character.h"

@interface Item : Character
{
    int effect;
    int coordinateX;
    int coordinateY;
}

- (id)initWithImage:(NSString*)image
          andEffect:(int)eff
               andX:(int)x
               andY:(int)y;

- (void)setUpAI;
@end
