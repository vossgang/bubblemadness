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
#import <AudioToolbox/AudioToolbox.h>
#import "constants.h"
#import "UIColor+Extension.h"

@interface MVViewController ()

@property (nonatomic)         CGRect                 screenRect;            //size of curent screen
@property (nonatomic, strong) NSMutableArray        *bubbles;               //array of bubbles on screen
@property (nonatomic, strong) UIDynamicAnimator     *animator;              //animate the bubbles
@property (nonatomic, strong) UIGravityBehavior     *gravity;               //gravity for the bubbles
@property (nonatomic, strong) UICollisionBehavior   *collision;             //collision for everything on screen
@property (nonatomic)         NSInteger              startingBubbleCount;   //number of bubbles we want to start
@property (nonatomic)         NSInteger              maxBubbleCount;        //maximun bubbles on screen at any one time
@property (nonatomic)         NSInteger              toolBarHeight;         //height of toolbar based on screen size
@property (nonatomic)         NSInteger              score;                 //current session score
@property (nonatomic, strong) UIButton              *backButton;            //button to return to home screen
@property (nonatomic, strong) MVButtonBar           *toolBar;               //bottom layout bar to display score and time

@property (nonatomic, strong) NSTimer               *gameTime;              //time of any given session
@property (nonatomic, strong) NSTimer               *countDown;             //visual count down of time remaining in current session
@property (nonatomic, strong) NSTimer               *gravityTimer;          //change the gravity of the game
@property (nonatomic, strong) NSTimer               *centerPointTimer;

@property (nonatomic)         CGFloat                timeRemaining;         //time remaining in current session
@property (nonatomic, strong) UIImageView           *playButton;            //start of game button
@property (nonatomic, strong) UITapGestureRecognizer *tapPlay;              //start of game tap gesture
@property (nonatomic)         NSInteger              currentHighScore;      //the highest high score in the game

@property (nonatomic, strong) UIImageView           *gameOverImageView;     //end of game image
@property (nonatomic, strong) UIImageView           *highScoreImageView;    //new high score image
@property (nonatomic, strong) UIImageView           *keepGoingImageView;
@property (nonatomic, strong) UIImageView           *bubblesPoppedImageView;

@property (nonatomic)         BOOL                  newHighScoreFlag;       //new high score acheived
@property (nonatomic)         BOOL                  keepGoingFlag;
@property (nonatomic)         BOOL                  bubblesPoppedFlag;

@property (nonatomic)         CGFloat               pointsPerSecond;
@property (nonatomic)         CGFloat               PPSNeededForNewHighScore;
@property (nonatomic)         NSInteger             bubblesPoppedCounter;
@property (nonatomic)         NSInteger             bubblesPoppedNeededForFlag;

@end

@implementation MVViewController
{
    SystemSoundID bubblePop1;
    SystemSoundID bubblePop2;
    SystemSoundID bubblePop3;
    
    CGPoint bubblesCenterPoint[LARGE_IPHONE_BUBBLE_COUNT + 1];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get Screen size and get bubble count accourdingly
    self.screenRect = [[UIScreen mainScreen] bounds];
   
    if (self.screenRect.size.height < 500) {
        self.maxBubbleCount = SMALL_IPHONE_BUBBLE_COUNT;
    } else {
        self.maxBubbleCount = LARGE_IPHONE_BUBBLE_COUNT;
    }
    self.startingBubbleCount = (self.maxBubbleCount / 2);
    
    self.bubblesPoppedNeededForFlag = 100;
    
    self.bubblesPoppedCounter = 0;

    //get arrays and score ready for use
    NSMutableArray *newArray = [NSMutableArray new];
    MVHighScore *newHighScore = [MVHighScore new];
    
    //check to see if there are high scores & set current high score
    if (!self.highScores) {
        newHighScore.number = 0;
        _currentHighScore = 0;
        [newArray addObject:newHighScore];
        self.highScores = newArray;
    } else {
        self.currentHighScore = [_highScores[0] number];
        self.PPSNeededForNewHighScore = (self.currentHighScore / STARTING_TIME);
    }
    
    //Set the Background image
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"B%d.jpg", ((arc4random() % 3) + 1)]];
    [self.view addSubview:bgview];
    
    //put toolbar on the bottom of screen
    [self placeToolBar];
    
    //place start up game button
    self.playButton = [[UIImageView alloc] initWithFrame:CGRectMake((self.screenRect.size.width / 2) - 110,
                                                                    ((self.screenRect.size.height - (self.toolBarHeight))/ 2) - 79, 220, 158)];
    self.playButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"Play"]];
    [self.view addSubview:self.playButton];
    
    //Start of game button
    self.tapPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonHit)];
    [self.playButton setUserInteractionEnabled:YES];
    [self.playButton addGestureRecognizer:self.tapPlay];
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"bubblepop1" ofType:@"m4a"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &bubblePop1);
    
    path  = [[NSBundle mainBundle] pathForResource:@"bubblepop2" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &bubblePop2);
    
    path  = [[NSBundle mainBundle] pathForResource:@"bubblepop3" ofType:@"m4a"];
    pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &bubblePop3);
}

-(void)playButtonHit
{
    if (self.GAME_MODE == timedMode ) {
        self.timeRemaining = STARTING_TIME;
    } else if (self.GAME_MODE == continuousMode){
        self.timeRemaining = 1;
    }
    //Start of new session
    self.score              = 0;
    self.toolBar.score.text = @"0";
    
    [self.playButton setHidden:YES];

    [self countdown:^{
        [self setUpBubbleArray];
        [self setUpCollision];
        [self setUpGravity];
        [self setUpAnimator];
        [self setUpTap];
        [self setUpTimer];
    }];
}

-(void)countdown:(void (^)(void))completionblock
{
    UIImageView *countDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((self.screenRect.size.width / 2) - 50), (((self.screenRect.size.height - self.toolBarHeight) / 2) - 100), 100, 200)];
    [self.view addSubview:countDownImageView];
    [UIView animateWithDuration:1 animations:^{
        countDownImageView.image = [UIImage imageNamed:@"3"];
        AudioServicesPlaySystemSound(bubblePop1);
        countDownImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        countDownImageView.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:1 animations:^{
            countDownImageView.image = [UIImage imageNamed:@"2"];
            AudioServicesPlaySystemSound(bubblePop1);
            countDownImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            countDownImageView.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:1 animations:^{
                countDownImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                countDownImageView.image = [UIImage imageNamed:@"1"];
                AudioServicesPlaySystemSound(bubblePop1);
            } completion:^(BOOL finished) {
                [countDownImageView removeFromSuperview];
                completionblock();
            }];
        }];
    }];
}

-(void)setUpButton
{   //set up back button to go to main screen
    self.toolBar.backTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.toolBar.backButton setUserInteractionEnabled:YES];
    [self.toolBar.backButton addGestureRecognizer:self.toolBar.backTap];
}

-(void)placeToolBar
{
    //set the tool bar at the bottom of the screen
    CGRect toolBarFrame;
    self.toolBarHeight = (self.screenRect.size.width / 4);
    toolBarFrame = CGRectMake(0, (self.screenRect.size.height - self.toolBarHeight), self.screenRect.size.width, self.toolBarHeight);
    self.toolBar = [[MVButtonBar alloc] initWithFrame:toolBarFrame];
    [self.view insertSubview:self.toolBar atIndex:3000];
    [self setUpButton];
}

-(void)setUpBubbleArray
{
    //set starting bubble array for game
    NSMutableArray *bubbleArray = [NSMutableArray new];
    MVBubbleView *newBubble;
    for (int i = 0; i < self.startingBubbleCount; i++) {
        int size = ((arc4random() % 65) + 64);
        int locationX = (arc4random() % (int)(self.screenRect.size.width - 84));
        newBubble = [[MVBubbleView alloc] initWithFrame:CGRectMake(locationX, (self.screenRect.size.height + arc4random_uniform(50)), size, size)];
        [self.view insertSubview:newBubble belowSubview:self.toolBar];
        [bubbleArray addObject:newBubble];
    }
    self.bubbles = bubbleArray;
}

-(void)setUpCollision
{
    //Set up bubble Collision
    self.collision = [UICollisionBehavior new];
    [self.collision addBoundaryWithIdentifier:@"left Side" fromPoint:CGPointMake((self.screenRect.size.width - 55), -10)
                                      toPoint:CGPointMake((self.screenRect.size.width - 55), 700)];
    [self.collision addBoundaryWithIdentifier:@"right Side" fromPoint:CGPointMake((self.screenRect.size.width + 55), -10)
                                      toPoint:CGPointMake((self.screenRect.size.width + 55), 700)];
    MVBubbleView *newBubbleViews;
    for (int i = 0 ; i < self.bubbles.count; i++) {
        newBubbleViews = [self.bubbles objectAtIndex:i];
        [self.collision addItem:newBubbleViews];
    }
}

- (void)changeGravity
{
    //invert gravity
    CGVector direction = self.gravity.gravityDirection;
    direction.dx *= -1.0;
    self.gravity.gravityDirection = direction;
    
    if (self.bubbles.count < self.maxBubbleCount) {
        [self addBubbleToAll];
    }
    
    for (MVBubbleView *bubbleView in self.view.subviews) {
        if (bubbleView.frame.origin.x < -75 || bubbleView.frame.origin.y < -90 || bubbleView.frame.origin.x > _screenRect.size.width + 75) {
            [self popThisBubbleWOAnimation:bubbleView];
        }
    }
}

-(void)setUpGravity;
{
    //set up initial gravity for bubbles
    self.gravity = [UIGravityBehavior new];
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= -.197;
    direction.dx  = .093;
    [self.gravity setGravityDirection:direction];
    MVBubbleView *newBubbleViews;
    for (int i = 0 ; i < self.bubbles.count; i++) {
        newBubbleViews = [self.bubbles objectAtIndex:i];
        [self.gravity addItem:newBubbleViews];
    }
}

-(void)setUpAnimator
{
    //animate the bubble around the screen
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    MVBubbleView *newBubbleView;
    for (int i = 0; i < self.bubbles.count; i++) {
        newBubbleView = [self.bubbles objectAtIndex:i];
        [self.animator addBehavior:newBubbleView.itemBehavior];
    }
}

-(void)setUpTap
{
    //set up bubble interaction -allow them to be 'popped'
    MVBubbleView *newBubbleView;
    for (int i = 0; i < self.bubbles.count; i++) {
        newBubbleView = [self.bubbles objectAtIndex:i];
        newBubbleView.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [newBubbleView setUserInteractionEnabled:YES];
        [newBubbleView addGestureRecognizer:newBubbleView.tapRecognizer];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    //go to main screen
    if (sender == self.toolBar.backTap){
        [self gameOverPressed];
    }

    //pop the bubble
    MVBubbleView *newBubbleView;
    for (int i = 0; i < self.bubbles.count; i++) {
        newBubbleView = [self.bubbles objectAtIndex:i];
        if (newBubbleView.tapRecognizer == sender) {
            if ((++self.bubblesPoppedCounter > self.bubblesPoppedNeededForFlag) && (!self.bubblesPoppedFlag)) {
                self.bubblesPoppedFlag = YES;
                [self animateBubblesPopped];
            }
            [self popThisBubble:newBubbleView];
            [self updateScore:newBubbleView.scoreValue];
            switch (newBubbleView.scoreValue) {
                case 1: case 2: case 3: AudioServicesPlaySystemSound(bubblePop3); break;
                case 4: case 5: case 6: AudioServicesPlaySystemSound(bubblePop2); break;
                default:                AudioServicesPlaySystemSound(bubblePop1); break;
            }
        }
    }
}

-(void)animateBubblesPopped
{
    self.bubblesPoppedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (((self.screenRect.size.height - self.toolBarHeight) / 2) - 32), 320, 64)];
    self.bubblesPoppedImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"100BubblesPopped"]]; /*904 × 180*/
    self.bubblesPoppedImageView.alpha = 0;
    self.bubblesPoppedImageView.transform = CGAffineTransformMakeScale(0, 0);
    [self.view addSubview:self.bubblesPoppedImageView];
    
    [UIView animateWithDuration:1 animations:^{
        self.bubblesPoppedImageView.alpha = .9;
        self.bubblesPoppedImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.bubblesPoppedImageView.alpha = 0;
            self.bubblesPoppedImageView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [self.bubblesPoppedImageView removeFromSuperview];
        }];
    }];
}

-(void)updateScore:(NSInteger)withAmount
{
    //update score with amount passed in
    self.score += withAmount;
    self.pointsPerSecond = (self.score / (STARTING_TIME - self.timeRemaining));
    
    if ((self.pointsPerSecond > self.PPSNeededForNewHighScore) && (!self.newHighScoreFlag) && (!self.keepGoingFlag) && (self.timeRemaining < (STARTING_TIME * .35))) {
        self.keepGoingFlag = YES;
        if (self.GAME_MODE == timedMode) {
            [self animateKeepGoing];
        }
    }
    
    self.toolBar.score.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    [UIView animateWithDuration:.1 animations:^{
        self.toolBar.score.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            self.toolBar.score.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    
    if (!self.newHighScoreFlag && (self.score > self.currentHighScore)) {
        self.newHighScoreFlag = YES;  //a new high score has been achieved
        [self animateNewHighScore];
    }
}

-(void)animateKeepGoing
{
    self.keepGoingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (((self.screenRect.size.height - self.toolBarHeight) / 2) - 58), 320, 116)];
    self.keepGoingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"KeepGoing"]]; /* 528 × 191 */
    self.keepGoingImageView.alpha = 0;
    self.keepGoingImageView.transform = CGAffineTransformMakeScale(0, 0);
    [self.view addSubview:self.keepGoingImageView];
    
    [UIView animateWithDuration:1 animations:^{
        self.keepGoingImageView.alpha = .9;
        self.keepGoingImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.keepGoingImageView.alpha = 0;
            self.keepGoingImageView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [self.keepGoingImageView removeFromSuperview];
        }];
    }];
}

-(void)animateNewHighScore
{
    self.highScoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (((self.screenRect.size.height - self.toolBarHeight) / 2) - 57), 320, 112)];
    self.highScoreImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NewHighScore"]];
    self.highScoreImageView.alpha = 0;
    self.highScoreImageView.transform = CGAffineTransformMakeScale(0, 0);
    [self.view addSubview:self.highScoreImageView];
        
    [UIView animateWithDuration:1 animations:^{
        self.highScoreImageView.alpha = .9;
        self.highScoreImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
            [UIView animateWithDuration:2 animations:^{
                self.highScoreImageView.alpha = 0;
                self.highScoreImageView.transform = CGAffineTransformMakeScale(0, 0);
            } completion:^(BOOL finished) {
                [self.highScoreImageView removeFromSuperview];
            }];
    }];
}

-(void)addBubbleToAll
{
    //add a bubble to the screen
    if (self.timeRemaining > .1) {
        int size = ((arc4random() % 65) + 64);
        int locationX = (arc4random() % (int)((self.screenRect.size.width * .5) + self.screenRect.size.width * .3));
        MVBubbleView *newBubbleView = [[MVBubbleView alloc] initWithFrame:CGRectMake(locationX, (self.screenRect.size.height + arc4random_uniform(20)), size, size)];
        [self.view insertSubview:newBubbleView belowSubview:self.toolBar];
        
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
    //end the game --timer has hit zero or back buttom pressed
    [self.countDown invalidate];
    [self.gameTime invalidate];
    [self.gravityTimer invalidate];
    [self.centerPointTimer invalidate];
    
    if (self.newHighScoreFlag){
        
        MVHighScore *newHighScore = [MVHighScore new];
        self.currentHighScore = newHighScore.number = self.score;
        
        self.PPSNeededForNewHighScore = (self.currentHighScore / STARTING_TIME);
        
        [self.highScores insertObject:newHighScore atIndex:0];
        if (self.highScores.count > 10) {
            [self.highScores removeLastObject];
        }
    }
    
    self.toolBar.clock.text = [NSString stringWithFormat:@"0"];
    MVBubbleView *bubble;
    for (int i = 0; i < self.bubbles.count; i++) {
        bubble = [self.bubbles objectAtIndex:i];
        [bubble removeFromSuperview];
    }

    self.gameOverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 112)];
    self.gameOverImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"GameOver"]];
    [self.view addSubview:self.gameOverImageView];
    [UIView animateWithDuration:1 animations:^{
        self.gameOverImageView.frame = CGRectMake(0, ((self.screenRect.size.height - self.toolBarHeight) / 2) - 57, 320, 112);
    } completion:^(BOOL finished) {
        self.toolBar.clock.textColor = [UIColor flatMidnightBlueColor];
        [UIView animateWithDuration:1.5 animations:^{
            self.gameOverImageView.alpha = 0;
            self.playButton.alpha = 0;
            self.gameOverImageView.transform = CGAffineTransformMakeScale(.33, .33);
            self.playButton.transform = CGAffineTransformMakeScale(.33, .33);
        } completion:^(BOOL finished) {
            [self.gameOverImageView removeFromSuperview];
            [self.playButton setHidden:NO];
            [UIView animateWithDuration:1 animations:^{
                self.playButton.alpha = 1;
                self.playButton.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                self.gameOverImageView.alpha = 1;
            }];
        }];
    }];
    self.newHighScoreFlag = self.keepGoingFlag = NO;
    for (MVBubbleView *bubble in self.bubbles) {
        [bubble removeFromSuperview];
    }

}

-(void)restartGame
{
    self.toolBar.score.text = @"0";
    [self playButtonHit];
}

-(void)gameOverPressed
{
    for (MVBubbleView *bubble in self.bubbles) {
        [bubble removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)setUpTimer
{
    if (self.GAME_MODE == timedMode ) {
        //time remaining for the current session
        self.gameTime       = [NSTimer scheduledTimerWithTimeInterval:self.timeRemaining
                                                               target:self
                                                             selector:@selector(endOfGame)
                                                             userInfo:nil
                                                              repeats:NO];
        //visual countdown of current session
        self.countDown      = [NSTimer scheduledTimerWithTimeInterval:.2
                                                               target:self
                                                             selector:@selector(displayTimer)
                                                             userInfo:Nil
                                                              repeats:YES];
    } 
    
    //change the gravity on current session
    self.gravityTimer   = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(changeGravity)
                                                         userInfo:Nil
                                                          repeats:YES];
    //remove any bubble that doesnt move
    self.centerPointTimer = [NSTimer scheduledTimerWithTimeInterval:.2
                                                             target:self
                                                           selector:@selector(checkCenterPoints)
                                                           userInfo:nil
                                                            repeats:YES];
}

-(void)checkCenterPoints
{
    MVBubbleView *bubble;
    for (int i = 0; i < self.bubbles.count; i++) {
        bubble = self.bubbles[i];
        if ([self distanceBetweenPoint:bubble.center andPoint:bubblesCenterPoint[i]] < 2) {
            [self popThisBubbleWOAnimation:bubble];
        }
        bubblesCenterPoint[i] = bubble.center;
    }
}

-(CGFloat)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2));
}

-(void)displayTimer
{    //visual countdown of current session
    self.timeRemaining -= .2;
    if (self.timeRemaining < 10) {
        self.toolBar.clock.textColor = [UIColor RubyColor];
        if (self.timeRemaining < 5) {
            [UIView animateWithDuration:.15 animations:^{
                self.toolBar.clock.transform = CGAffineTransformMakeScale(1.3, 1.3);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    self.toolBar.clock.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        }
    }
    self.toolBar.clock.text = [NSString stringWithFormat:@"%.1f", self.timeRemaining];
}

-(void)popThisBubble:(MVBubbleView *)bubble
{
    [self.collision removeItem:bubble];
    [self.gravity removeItem:bubble];
    [self.animator removeBehavior:bubble.itemBehavior];
    [bubble removeForgroundFromView];
    [bubble removePointImageFromView];
    
    [UIView animateWithDuration:.125 animations:^{
        int rotaion = arc4random() % 2;
        if (rotaion) {
            rotaion =(M_PI/3);
        } else
        {
            rotaion = (M_PI / -3);
        }
        bubble.transform = CGAffineTransformMakeRotation(rotaion);
        bubble.transform = CGAffineTransformMakeScale(1.5,1.5);
        [UIView animateWithDuration:.125 animations:^{
            bubble.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"POP4"]];
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    } completion:^(BOOL finished) {
        [bubble removeFromSuperview];
        [self.bubbles removeObject:bubble];
        //reset image to regular image
        bubble.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"bubbleBG"]];
        //put forground and point image back
        [bubble resetFGAndPointImages];
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1, 1);
        [self addThisBubbleBack:bubble];
    }];
}

-(void)popThisBubbleWOAnimation:(MVBubbleView *)bubble
{
    
    [self.collision removeItem:bubble];
    [self.gravity removeItem:bubble];
    [self.animator removeBehavior:bubble.itemBehavior];
    [bubble removeFromSuperview];
    [self.bubbles removeObject:bubble];
    [self addThisBubbleBack:bubble];
}

-(void)addThisBubbleBack:(MVBubbleView *)bubble
{
    //add a bubble to the screen
    int locationX = (arc4random_uniform(self.screenRect.size.width / 3) + (self.screenRect.size.width / 3));
    int locationY = self.screenRect.size.height + 60;
    bubble.center = CGPointMake(locationX, locationY);
    
    [self.view insertSubview:bubble belowSubview:self.toolBar];
    
    [self.gravity addItem:bubble];
    [self.collision addItem:bubble];
    [self.animator addBehavior:bubble.itemBehavior];
    [self.bubbles addObject:bubble];
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
    if (self.GAME_MODE == timedMode) {
        [self saveToFile];
    }
    [super viewWillDisappear:animated];
}

@end
