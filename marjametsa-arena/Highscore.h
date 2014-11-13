//
//  Highscore.h
//  marjametsa-arena
//
//  Created by Jeebus on 13.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Highscore: NSObject

@property (assign, nonatomic) long score;


+(instancetype)GameData;


// - (return_type) method_name:( argumentType1 )argumentName1

-(BOOL)scores:(int)bestscore;



-(void)reset;

@end







