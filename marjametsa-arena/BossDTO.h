//
//  BossDTO.h
//  marjametsa-arena
//
//  Created by Ridge on 6.12.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BossDTO : NSObject
@property (nonatomic) NSString *image;
@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int movePattern;
@property (nonatomic) int health;
@property (nonatomic) float colorizeSequence;

@end
