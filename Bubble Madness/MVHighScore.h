//
//  MVHighScore.h
//  Bubble Madness
//
//  Created by Matthew Voss on 3/10/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVHighScore : NSObject <NSCoding>

@property (nonatomic, strong) NSString *playerName;
@property (nonatomic, strong) NSString *score;
@property (nonatomic)         NSInteger number;


@end
