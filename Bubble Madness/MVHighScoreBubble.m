//
//  MVHighScoreBubble.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/11/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVHighScoreBubble.h"

@implementation MVHighScoreBubble

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.forground  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.background.image = [UIImage imageNamed:@"bubbleBG"];
        self.forground.image  = [UIImage imageNamed:@"bubbleFG"];
        
        [self addSubview:self.background];
        [self addSubview:self.forground];
    }
    return self;
}

-(void)putHighScoreImage:(NSString *)HighScore
{
    NSString *score = HighScore;
    
    if (score.length == 4) {
        self.firstDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0, self.frame.size.height * .5, self.frame.size.width* .25, self.frame.size.height*.25)];
        self.firstDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:0]]];
        [self addSubview:self.firstDidget];
        
        self.secondDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .25, self.frame.size.height * .5, self.frame.size.width * .25, self.frame.size.height * .25)];
        self.secondDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:1]]];
        [self addSubview:self.secondDidget];

        self.thridDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .5, self.frame.size.height * .5, self.frame.size.width * .25, self.frame.size.height * .25)];
        self.thridDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:2]]];
        [self addSubview:self.thridDidget];
       
        self.fourthDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .75, self.frame.size.height * .5, self.frame.size.width * .25, self.frame.size.height * .25)];
        self.fourthDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:3]]];
        [self addSubview:self.fourthDidget];

        
    } else if (score.length == 3) {
        self.firstDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .12, self.frame.size.height * .5, self.frame.size.width*.25, self.frame.size.height*.25)];
        self.firstDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:0]]];
        [self addSubview:self.firstDidget];
        
        self.secondDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .37, self.frame.size.height * .5, self.frame.size.width * .25, self.frame.size.height * .25)];
        self.secondDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:1]]];
        [self addSubview:self.secondDidget];
        
        self.thridDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .62, self.frame.size.height * .5, self.frame.size.width * .25, self.frame.size.height * .25)];
        self.thridDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:2]]];
        [self addSubview:self.thridDidget];

    } else if (score.length == 2) {
        self.firstDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .25, self.frame.size.height * .5, self.frame.size.width*.25, self.frame.size.height*.25)];
        self.firstDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:0]]];
        [self addSubview:self.firstDidget];
        
        self.secondDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .5, self.frame.size.height * .5, self.frame.size.width * .25, self.frame.size.height * .25)];
        self.secondDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:1]]];
        [self addSubview:self.secondDidget];

    } else if (score.length == 1) {
        self.firstDidget = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * .37, self.frame.size.height * .5, self.frame.size.width*.25, self.frame.size.height*.25)];
        self.firstDidget.image = [UIImage imageNamed:[NSString stringWithFormat:@"%c.png", [score characterAtIndex:0]]];
        [self addSubview:self.firstDidget];

    }
    
}

-(void)putHighScoreName:(NSString *)name
{
    
    UITextField *testName = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width * .2, self.frame.size.height * .25, self.frame.size.width * .6, self.frame.size.height * .25)];
    testName.text = name;
    testName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:testName];
    
}

@end
