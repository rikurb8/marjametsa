//
//  MyScene.h
//  marjametsa-arena
//

//  Copyright (c) 2014 rb8. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SceneDTO.h"

@interface GameScene : SKScene

-(id)initWithSize:(CGSize)size andInfo:(SceneDTO*)image;

@end
