//
//  Hero.m
//  marjametsa-arena
//
//  Created by Ridge on 14.10.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Hero.h"

@interface Hero ()
@end

@implementation Hero

- (id)init {
    self = [super init];
    
    if (self) {
        self.image = @"heroInSpace.png";
        self.character = nil;
    }
    
    return self;
}


@end
