//
//  MVStatingViewController.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVStatingViewController.h"
#import "MVBubbleView.h"
#import "MVViewController.h"
#import "CreditsViewcontroller.h"
#import "MVHighScoreViewController.h"
#import "MVHighScore.h"

@interface MVStatingViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) MVBubbleView          *startBubble;
@property (nonatomic, strong) MVBubbleView          *creditsBubble;
@property (nonatomic, strong) MVBubbleView          *highScoreBubble;
@property (nonatomic, strong) NSMutableArray        *highScores;
@property (nonatomic, strong) NSMutableArray        *extraBubbles;
@property (nonatomic, strong) UIDynamicAnimator     *animator;
@property (nonatomic, strong) UIGravityBehavior     *gravity;
@property (nonatomic, strong) UICollisionBehavior   *collision;
@property (nonatomic, strong) NSTimer               *gravityTimer;

@end

@implementation MVStatingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:@"B3.jpg"];
    [self.view addSubview:bgview];
    
    self.startBubble        = [[MVBubbleView alloc] initFrameForStarting:CGRectMake(50, 50, 156, 156)];
    self.creditsBubble      = [[MVBubbleView alloc] initFrameForStarting:CGRectMake(200, 200, 100, 100)];
    self.highScoreBubble    = [[MVBubbleView alloc] initFrameForStarting:CGRectMake(100, 300, 128, 128)];
    [self.view addSubview:self.creditsBubble];
    [self.view addSubview:self.startBubble];
    [self.view addSubview:self.highScoreBubble];
    
    [self setUpExtraBubbles];
    [self setUpTap];
    [self setUpGravity];
    [self setUpCollision];
    self.collision.collisionDelegate = self;
    [self setUpAnimator];
    self.highScores = [NSMutableArray new];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSMutableArray *myArray = [NSMutableArray new];
    [self loadFromFile];

    if (!self.highScores) {
        NSString *pathForPlistInBudle = [[NSBundle mainBundle] pathForResource:@"save" ofType:@"plist"];
        myArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pathForPlistInBudle];

        self.highScores = myArray;
        if (self.highScores.count) {
            [self saveToFile];
        }
    }
    
    [self setUpTimers];
}

-(void)setUpGravity;
{
    self.gravity = [UIGravityBehavior new];
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= .207;
    [self.gravity setGravityDirection:direction];
    for (int i = 0 ; i < self.extraBubbles.count; i++) {
            MVBubbleView *newBubble = [self.extraBubbles objectAtIndex:i];
            [self.gravity addItem:newBubble];
    }
    [self.gravity addItem:self.startBubble];
    [self.gravity addItem:self.creditsBubble];
    [self.gravity addItem:self.highScoreBubble];
}

-(void)setUpCollision
{
    self.collision = [UICollisionBehavior new];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    for (int i = 0; i < self.extraBubbles.count; i++) {
        MVBubbleView *newBubble = [self.extraBubbles objectAtIndex:i];
        [self.collision addItem:newBubble];
    }
    [self.collision addItem:self.startBubble];
    [self.collision addItem:self.creditsBubble];
    [self.collision addItem:self.highScoreBubble];
}

-(void)setUpAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    for (int i = 0; i < self.extraBubbles.count; i++) {
        MVBubbleView *bubble = [self.extraBubbles objectAtIndex:i];
        [self.animator addBehavior:bubble.itemBehavior];
    }
    [self.animator addBehavior:self.startBubble.itemBehavior];
    [self.animator addBehavior:self.highScoreBubble.itemBehavior];
    [self.animator addBehavior:self.creditsBubble.itemBehavior];
}

-(void)setUpTap
{
    self.startBubble.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.startBubble setUserInteractionEnabled:YES];
    [self.startBubble addGestureRecognizer:self.startBubble.tapRecognizer];
    
    self.creditsBubble.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.creditsBubble setUserInteractionEnabled:YES];
    [self.creditsBubble addGestureRecognizer:self.creditsBubble.tapRecognizer];
    
    self.highScoreBubble.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.highScoreBubble setUserInteractionEnabled:YES];
    [self.highScoreBubble addGestureRecognizer:self.highScoreBubble.tapRecognizer];
    
    for (int i = 0; i < self.extraBubbles.count; i++) {
        MVBubbleView *thisBubble = [self.extraBubbles objectAtIndex:i];
        thisBubble.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distortBubble:)];
        [thisBubble setUserInteractionEnabled:YES];
        [thisBubble addGestureRecognizer:thisBubble.tapRecognizer];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (self.startBubble.tapRecognizer == sender) {
        MVViewController *timedGame = [MVViewController new];
        timedGame.highScores = self.highScores;
        timedGame.GAME_MODE = timedMode;
        [self presentViewController:timedGame animated:YES completion:Nil];
        
    } else if (self.creditsBubble.tapRecognizer == sender) {
        CreditsViewcontroller *continuous = [CreditsViewcontroller new];
        [self presentViewController:continuous animated:YES completion:Nil];
        
    } else if (self.highScoreBubble.tapRecognizer == sender) {
        MVHighScoreViewController *highScore = [MVHighScoreViewController new];
        highScore.highScores = self.highScores;
        [self presentViewController:highScore animated:YES completion:Nil];
    }
}

-(void)distortBubble:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < self.extraBubbles.count; i++) {
        MVBubbleView *thisBubble = [self.extraBubbles objectAtIndex:i];
        if (thisBubble.tapRecognizer == sender) {
            [self popThisBubble:thisBubble];
            break;
        }
    }
}

-(void)setUpExtraBubbles
{
    
    NSMutableArray *newArray = [NSMutableArray new];
 
    MVBubbleView *bubble1 = [[MVBubbleView alloc] initWithFrame:CGRectMake(150, 150, 96, 96)];
    [self.view addSubview:bubble1];
    [newArray addObject:bubble1];
    
    MVBubbleView *bubble2 = [[MVBubbleView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
    [self.view addSubview:bubble2];
    [newArray addObject:bubble2];
 
    MVBubbleView *bubble3 = [[MVBubbleView alloc] initWithFrame:CGRectMake(250, 150, 64, 64)];
    [self.view addSubview:bubble3];
    [newArray addObject:bubble3];
 
    self.extraBubbles = newArray;
}

-(void)setUpTimers
{
    self.gravityTimer     = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                             target:self
                                                           selector:@selector(changeGravity)
                                                           userInfo:Nil
                                                            repeats:YES];
}

-(void)changeGravity
{
    CGVector direction = self.gravity.gravityDirection;
    direction.dy *= -1.0;
    [self.gravity setGravityDirection:direction];
}

-(void)popThisBubble:(MVBubbleView *)bubble
{
    [self.collision removeItem:bubble];
    [self.gravity removeItem:bubble];
    [self.animator removeBehavior:bubble.itemBehavior];
    [bubble removeForgroundFromView];
    
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
        bubble.transform = CGAffineTransformMakeScale(1,1);
        bubble.alpha = 1;
        [self.collision addItem:bubble];
        [self.gravity addItem:bubble];
        [self.animator addBehavior:bubble.itemBehavior];
        bubble.background.image = [UIImage imageNamed:@"bubbleBG"];
        bubble.forground.image = [UIImage imageNamed:@"bubbleFG"];
        [bubble addSubview:bubble.forground];
    }];
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

@end