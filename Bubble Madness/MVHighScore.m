//
//  MVHighScore.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/10/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVHighScore.h"

@implementation MVHighScore



- (void)encodeWithCoder:(NSCoder *)encoder
{
    self.score = [NSString stringWithFormat:@"%d", (int)self.number];
    [encoder encodeObject:self.playerName forKey:@"playerName"];
    [encoder encodeObject:self.score      forKey:@"score"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        [self setPlayerName:[decoder decodeObjectForKey:@"playerName"]];
        [self setScore:[decoder decodeObjectForKey:@"score"]];
        self.number     = [self.score intValue];
        
     }
    return self;
}


@end
