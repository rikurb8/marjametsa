//
//  Highscore.m
//  marjametsa-arena
//
//  Created by Jeebus on 13.11.2014.
//  Copyright (c) 2014 rb8. All rights reserved.
//

#import "Highscore.h"

@implementation Highscore


// This function is not used
+(instancetype)GameData{
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


// Check if player score is the bestscore. If yes return true, else return false
-(BOOL)scores:(int)bestscore{
    
    
    long highscore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore_1"];
    
    if(highscore < bestscore){
        [[NSUserDefaults standardUserDefaults] setInteger: bestscore forKey: @"highScore_1"];
        
    
        NSLog(@"Nyt sait %d", bestscore);
        NSLog(@"ja nyt tuli %ld", highscore);
        
        return true;
    }
    
    
    NSLog(@"Nyt sait %d", bestscore);
    NSLog(@"ja nyt tuli %ld", highscore);
    
    return false;
}




-(void)reset{
    
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: @"highScore_1"];
    
    return;
}






@end
