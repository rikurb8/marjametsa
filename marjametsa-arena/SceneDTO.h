//
//  SceneDTO.h
//  marjametsa-arena
//
//  Created by Ridge on 25.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroDTO.h"
#import "GameDTO.h"
#import "BossDTO.h"

@interface SceneDTO : NSObject

@property (nonatomic) NSMutableArray *monsterArray;
@property (nonatomic) NSMutableArray *itemArray;
@property (nonatomic) HeroDTO *hero;
@property (nonatomic) GameDTO *game;
@property (nonatomic) BossDTO *boss;

@end
