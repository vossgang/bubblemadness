//
//  MVHighScoreViewController.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/10/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVHighScoreViewController.h"
#import "MVButtonBar.h"
#import "MVHighScore.h"
#import "MVHighScoreBubble.h"

@interface MVHighScoreViewController ()

@property (nonatomic)         CGRect             screenRect;
@property (nonatomic, strong) MVButtonBar       *toolBar;

@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble0;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble1;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble2;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble3;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble4;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble5;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble6;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble7;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble8;
@property (nonatomic, strong) MVHighScoreBubble *highScoreBubble9;



@end

@implementation MVHighScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"B%d.jpg", ((arc4random() % 5) + 1)]];
    
    [self.view addSubview:bgview];
    [self placeToolBar];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.highScores) {
        [self showHighScores];
    }
    
}

-(void)placeToolBar
{
    CGRect toolBarFrame;
    NSInteger toolBarHieght = (self.screenRect.size.width / 4);
    toolBarFrame = CGRectMake(0, (self.screenRect.size.height - toolBarHieght), self.screenRect.size.width, toolBarHieght);
    
    self.toolBar = [[MVButtonBar alloc] initWithFrame:toolBarFrame];
    self.toolBar.clock.text = @"Scores";
    self.toolBar.score.text = @"High";
    
    [self.view addSubview:self.toolBar];
    [self setUpButton];
}

-(void)setUpButton
{
    self.toolBar.backTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.toolBar.backButton setUserInteractionEnabled:YES];
    [self.toolBar.backButton addGestureRecognizer:self.toolBar.backTap];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#warning NEED-TO-SUBCLASS-UIVIEW-AGAIN
-(void)showHighScores
{
    
    MVHighScore *thisHighScore = [self.highScores objectAtIndex:0];
    self.highScoreBubble0 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(24, 1, 128, 128)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble0 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble0 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble0];

    
    
    thisHighScore = [self.highScores objectAtIndex:1];
    self.highScoreBubble1 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(168, 1, 128, 128)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble1 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble1 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble1];
    
    
    thisHighScore = [self.highScores objectAtIndex:2];
    self.highScoreBubble2 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(1, 130, 106, 106)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble2 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble2 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble2];
    
    
    thisHighScore = [self.highScores objectAtIndex:3];
    self.highScoreBubble3 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(107, 130, 106, 106)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble3 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble3 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble3];
    
    
    thisHighScore = [self.highScores objectAtIndex:4];
    self.highScoreBubble4 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(213, 130, 106, 106)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble4 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble4 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble4];

    
    thisHighScore = [self.highScores objectAtIndex:5];
    self.highScoreBubble5 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(24, 237, 128, 128)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble5 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble5 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble5];
    
    
    thisHighScore = [self.highScores objectAtIndex:6];
    self.highScoreBubble6 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(168, 237, 128, 128)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble6 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble6 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble6];
    
    
    thisHighScore = [self.highScores objectAtIndex:7];
    self.highScoreBubble7 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(1, 367, 106, 106)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble7 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble7 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble7];
    
    
    thisHighScore = [self.highScores objectAtIndex:8];
    self.highScoreBubble8 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(107, 367, 106, 106)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble8 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble8 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble8];
    
    
    thisHighScore = [self.highScores objectAtIndex:9];
    self.highScoreBubble9 = [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(213, 367, 106, 106)];
    thisHighScore.score = [NSString stringWithFormat:@"%ld", thisHighScore.number];
    [self.highScoreBubble9 putHighScoreImage:thisHighScore.score];
    [self.highScoreBubble9 putHighScoreName:thisHighScore.playerName];
    [self.view addSubview:_highScoreBubble9];
    
}

@end







