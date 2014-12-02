//
//  Banana.m
//  marjametsa-arena
//
//  Created by Ridge on 14.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Item.h"
#import "Constants.h"

@implementation Item

- (id)initWithImage:(NSString*)image
          andEffect:(int)eff
               andX:(int)x
               andY:(int)y {
    
    self = [super init];
    
    if (self) {
        self.image = image;
        effect = eff;
        coordinateX = x;
        coordinateY = y;
    }
    
    return self;
};
-(void) setUpAI {
    
    if (effect == 0){
        
        self.character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.character.size.width/2];
        
        self.character.physicsBody.dynamic = NO;
        
        self.character.physicsBody.restitution = 0.1f;
        
        self.character.physicsBody.friction = 0.4f;
        
    } else {
    
        self.character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.character.size.width/2];
    
        self.character.physicsBody.friction = 0.0f;
    
        self.character.physicsBody.restitution = 1.0f;
    
        self.character.physicsBody.linearDamping = 0.0f;
    
        self.character.physicsBody.mass = 0;
    
        self.character.physicsBody.allowsRotation = YES;
    
        self.character.physicsBody.categoryBitMask = itemCategory;
    }

};

- (void) setName:(int)index {
    self.character.name = [NSString stringWithFormat:@"%d", index];
}

- (NSString*) getName{
    return self.character.name;
}

- (int) getEffect{
    return effect;
}


@end
