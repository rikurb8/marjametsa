//
//  Monster.h
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "AICharacter.h"

@interface Monster : AICharacter

{
    float colorizeSequence;
    NSString *movePattern;
    int coordinateX;
    int coordinateY;
    BOOL vulnerable;
}

- (void) setUpAI;
- (void) setName:(int)index;
- (NSString*) getName;
- (BOOL) isVulnerable;

@end
