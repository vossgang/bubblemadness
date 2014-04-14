//
//  MVHighScoreBubble.h
//  Bubble Madness
//
//  Created by Matthew Voss on 3/11/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVHighScore.h"
@interface MVHighScoreBubble : UIView

@property (nonatomic, strong)   UIImageView             *background;
@property (nonatomic, strong)   UIImageView             *forground;

@property (nonatomic, strong)   UIImageView             *firstDidget;
@property (nonatomic, strong)   UIImageView             *secondDidget;
@property (nonatomic, strong)   UIImageView             *thridDidget;
@property (nonatomic, strong)   UIImageView             *fourthDidget;

@property (nonatomic, strong)   UIImageView             *firstLetter;
@property (nonatomic, strong)   UIImageView             *secondLetter;
@property (nonatomic, strong)   UIImageView             *thirdLetter;

-(void)putHighScoreImage:(NSString *)HighScore;
-(void)putHighScoreName:(NSString *)name;

@end
