//
//  AICharacter.h
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Character.h"

@interface AICharacter : Character

//TODO: params in the future?
- (void) setUpAI;
- (void) setName:(int)index;
- (NSString*) getName;
- (bool) isVulnerable;
@end
