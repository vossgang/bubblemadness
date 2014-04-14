//
//  MVViewController.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVViewController.h"
#import "MVBubbleView.h"
#import "MVButtonBar.h"
#import "MVHighScore.h"
#import "EnterHighScoreController.h"

@interface MVViewController ()

@property (nonatomic)         CGRect                 screenRect;
@property (nonatomic, strong) NSMutableArray        *bubbles;
@property (nonatomic, strong) UIDynamicAnimator     *animator;
@property (nonatomic, strong) UIGravityBehavior     *gravity;
@property (nonatomic, strong) UICollisionBehavior   *collision;
@property (nonatomic)         NSInteger              bubbleCount;
@property (nonatomic)         NSInteger              toolBarHieght;
@property (nonatomic)         NSInteger              score;
@property (nonatomic, strong) UIButton              *backButton;
@property (nonatomic, strong) MVButtonBar           *toolBar;
@property (nonatomic, strong) NSTimer               *gameTime;
@property (nonatomic, strong) NSTimer               *countDown;
@property (nonatomic, strong) NSTimer               *gravityTimer;
@property (nonatomic)         CGFloat                timeRemaining;
@property (nonatomic, strong) UIImageView           *playButton;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic)         NSInteger              currentHighScore;

@property (nonatomic, strong) UIImageView           *gameOver;
@property (nonatomic, strong) UIImageView           *highScoreImage;

@property (nonatomic) BOOL newHighScoreFlag;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    if (self.screenRect.size.width > 320) {
        self.bubbleCount = 15;
    } else {
        self.bubbleCount = 5;
    }

//    [self loadFromFile];
    
    NSMutableArray *newArray = [NSMutableArray new];
    MVHighScore *newHighScore = [MVHighScore new];
    if (!self.highScores) {
        newHighScore.number = 0;
        _currentHighScore = 0;
        newHighScore.playerName = @"YOU";
        [newArray addObject:newHighScore];
        self.highScores = newArray;
    } else {
        _currentHighScore = [_highScores[0] number];
    }
    
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"B%d.jpg", ((arc4random() % 5) + 1)]];
    
    [self.view addSubview:bgview];
    [self placeToolBar];
    
    
    self.playButton = [[UIImageView alloc] initWithFrame:CGRectMake((self.screenRect.size.width / 2) - 110, (self.screenRect.size.height / 2) - 79, 220, 158)];
    self.playButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"Play"]];

    [self.view addSubview:self.playButton];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonHit)];
    [self.playButton setUserInteractionEnabled:YES];
    [self.playButton addGestureRecognizer:self.tap];
    
    
}

-(void)playButtonHit
{
    self.score = 0;
    self.toolBar.score.text = @"0";

    [self setUpBubbleArray];

    [self.playButton setHidden:YES];
    [self setUpCollision];
    [self setUpGravity];
    [self setUpAnimator];
    [self setUpTap];
    self.timeRemaining = 6;
    [self setUpTimer];
}

-(void)setUpButton
{
    self.toolBar.backTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.toolBar.backButton setUserInteractionEnabled:YES];
    [self.toolBar.backButton addGestureRecognizer:self.toolBar.backTap];
}

-(void)placeToolBar
{
    CGRect toolBarFrame;
    self.toolBarHieght = (self.screenRect.size.width / 4);
    toolBarFrame = CGRectMake(0, (self.screenRect.size.height - self.toolBarHieght), self.screenRect.size.width, self.toolBarHieght);
    
    self.toolBar = [[MVButtonBar alloc] initWithFrame:toolBarFrame];
    
    [self.view addSubview:self.toolBar];
    [self setUpButton];
}

-(void)setUpBubbleArray
{
    NSMutableArray *bubbleArray = [NSMutableArray new];
    for (int i = 0; i < self.bubbleCount; i++) {
        int size = ((arc4random() % 65) + 64);
        int locationX = (arc4random() % (int)(self.screenRect.size.width - 128));
        int locationY = (arc4random() % (int)((self.screenRect.size.height - self.toolBarHieght) - 128));
        MVBubbleView *newBubble = [[MVBubbleView alloc] initWithFrame:CGRectMake(locationX, locationY, size, size)];
        [self.view addSubview:newBubble];
        [bubbleArray addObject:newBubble];
    }
    self.bubbles = bubbleArray;
}

-(void)setUpCollision
{
    self.collision = [UICollisionBehavior new];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    for (int i = 0 ; i < self.bubbles.count; i++) {
        MVBubbleView *newBubbleViews = [self.bubbles objectAtIndex:i];
        [self.collision addItem:newBubbleViews];
    }
    [self.collision addBoundaryWithIdentifier:@"toolBar" fromPoint:CGPointMake(0, self.screenRect.size.height - self.toolBarHieght)toPoint:CGPointMake(self.screenRect.size.width, self.screenRect.size.height - self.toolBarHieght)];
}

- (void)changeGravity
{
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= -1.0;
    self.gravity.gravityDirection = direction;
    
}

-(void)setUpGravity;
{
    self.gravity = [UIGravityBehavior new];
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= .707;
    [self.gravity setGravityDirection:direction];
    for (int i = 0 ; i < self.bubbles.count; i++) {
        MVBubbleView *newBubbleViews = [self.bubbles objectAtIndex:i];
        [self.gravity addItem:newBubbleViews];
    }
}

-(void)setUpAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    for (int i = 0; i < self.bubbles.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbles objectAtIndex:i];
        [self.animator addBehavior:newBubbleView.itemBehavior];
    }
}

-(void)setUpTap
{
    for (int i = 0; i < self.bubbles.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbles objectAtIndex:i];
        newBubbleView.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [newBubbleView setUserInteractionEnabled:YES];
        [newBubbleView addGestureRecognizer:newBubbleView.tapRecognizer];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    
    if (sender == self.toolBar.backTap){
        [self gameOverPressed];
    }
    
    for (int i = 0; i < self.bubbles.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbles objectAtIndex:i];
        if (newBubbleView.tapRecognizer == sender) {
            [self popThisBubble:newBubbleView count:0];
            [self updateScore:newBubbleView.scoreValue];
        }
    }
}


-(void)updateScore:(NSInteger)withAmount
{
    self.score += withAmount;
    self.toolBar.score.text = [NSString stringWithFormat:@"%d", (int)self.score];
    
}

-(void)addBubbleToAll
{
    if (self.timeRemaining) {
        int size = ((arc4random() % 65) + 64);
        int locationX = (arc4random() % (int)(self.screenRect.size.width - 128));
        int locationY = (arc4random() % (int)((self.screenRect.size.height - self.toolBarHieght) - 128));
        MVBubbleView *newBubbleView = [[MVBubbleView alloc] initWithFrame:CGRectMake(locationX, locationY, size, size)];
        [self.view addSubview:newBubbleView];
    
        newBubbleView.itemBehavior.elasticity = 1.0;
    
        [self.animator addBehavior:newBubbleView.itemBehavior];
        [self.gravity addItem:newBubbleView];
    
        newBubbleView.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [newBubbleView setUserInteractionEnabled:YES];
        [newBubbleView addGestureRecognizer:newBubbleView.tapRecognizer];
    
        [self.collision addItem:newBubbleView];
        [self.bubbles addObject:newBubbleView];
    }
}


-(void)endOfGame
{
    [self.countDown invalidate];
    [self.gameTime invalidate];
    [self.gravityTimer invalidate];
    self.timeRemaining = 0;
 
    if (self.score > self.currentHighScore){
        _newHighScoreFlag = YES;
        
        MVHighScore *newHighScore = [MVHighScore new];
        newHighScore.number = self.score;
        
        [self.highScores insertObject:newHighScore atIndex:0];
        [self.highScores removeLastObject];
        
    } else {
        _newHighScoreFlag = NO;
    }
    
    self.toolBar.clock.text = [NSString stringWithFormat:@"%.1f", self.timeRemaining];

    for (int i = 0; i < self.bubbles.count; i++) {
        MVBubbleView *bubble = [self.bubbles objectAtIndex:i];
        [bubble removeFromSuperview];
    }
    
    
    if (!_newHighScoreFlag) {
        self.gameOver = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 112)];
        self.gameOver.image = [UIImage imageNamed:[NSString stringWithFormat:@"GameOver"]];
        [self.view addSubview:self.gameOver];

        [UIView animateWithDuration:.35 animations:^{
            self.gameOver.frame = CGRectMake(0, ((self.screenRect.size.height - self.toolBarHieght) / 2) - 57, 320, 112);
        } completion:^(BOOL finished) {
            self.tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartGame)];
            [self.gameOver setUserInteractionEnabled:YES];
            [self.gameOver addGestureRecognizer:self.tap];
        }];
    } else {
        self.highScoreImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 112)];
        self.highScoreImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"NewHighScore"]];
        [self.view addSubview:self.highScoreImage];

        [UIView animateWithDuration:.35 animations:^{
            self.highScoreImage.frame = CGRectMake(0, ((self.screenRect.size.height - self.toolBarHieght) / 2) - 57, 320, 112);
        } completion:^(BOOL finished) {
            self.tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterNewHighScore)];
            [self.highScoreImage setUserInteractionEnabled:YES];
            [self.highScoreImage addGestureRecognizer:self.tap];
        }];

    }
    
}

-(void)enterNewHighScore
{
    
    EnterHighScoreController *highScoreVC = [EnterHighScoreController new];
    
    highScoreVC.highScores = self.highScores;
        
    [self   presentViewController:highScoreVC animated:YES completion:^{
        
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *view in self.view.subviews) {
        if (self.highScoreImage == view) {
            [self.highScoreImage removeFromSuperview];
            [self.playButton setHidden:NO];
        }
    }
    
}



-(void)restartGame
{
    [self.gameOver removeFromSuperview];
    self.toolBar.score.text = @"0";
    [self playButtonHit];
}


-(void)gameOverPressed
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}


-(void)setUpTimer
{
    self.gameTime = [NSTimer scheduledTimerWithTimeInterval:self.timeRemaining
                                                     target:self
                                                   selector:@selector(endOfGame)
                                                   userInfo:nil
                                                    repeats:NO];
    
    self.countDown     = [NSTimer scheduledTimerWithTimeInterval:.1
                                                          target:self
                                                        selector:@selector(displayTimer)
                                                        userInfo:Nil
                                                         repeats:YES];
    
    self.gravityTimer     = [NSTimer scheduledTimerWithTimeInterval:.75
                                                          target:self
                                                        selector:@selector(changeGravity)
                                                        userInfo:Nil
                                                         repeats:YES];
}

-(void)displayTimer
{
    self.timeRemaining -= .1;
    self.toolBar.clock.text = [NSString stringWithFormat:@"%.1f", self.timeRemaining];
}

-(void)increaseTime
{
    self.timeRemaining += 5;
    [self.gameTime invalidate];
    [self.countDown invalidate];
    [self setUpTimer];
}

-(void)popThisBubble:(MVBubbleView *)bubble
               count:(int)count
{
    if (count == 0) {
        [self.collision removeItem:bubble];
        [self.gravity removeItem:bubble];
        [self.animator removeBehavior:bubble.itemBehavior];
        [bubble removeForgroundFromView];
        [self popThisBubble:bubble count:(count + 1)];
    } else if (count < 8) {
        [UIView animateWithDuration:.02 animations:^{
            bubble.frame = CGRectMake(bubble.frame.origin.x, bubble.frame.origin.y + 4, bubble.frame.size.width, bubble.frame.size.height);
            bubble.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"POP%d", count]];
         } completion:^(BOOL finished) {
            [self popThisBubble:bubble count:(count + 1)];
        }];
    } else if (count >= 8){
        [bubble removeFromSuperview];
        [self.bubbles removeObject:bubble];
        [self addBubbleToAll];
    }
    
}

-(void)saveToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"save.plist"];
    [NSKeyedArchiver archiveRootObject:self.highScores toFile:appFile];
}

-(void)loadFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"save.plist"];
    NSMutableArray *myArray  = [NSMutableArray new];
    myArray  = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    self.highScores = myArray;
}


+(NSString *)documentsDirectory
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *results = [fileManager URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [results lastObject];
    return documentsURL.path;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveToFile];
}


@end
