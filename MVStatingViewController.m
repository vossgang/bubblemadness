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


@property (nonatomic, strong) MVBubbleView  *startBubble;
@property (nonatomic, strong) MVBubbleView  *creditsBubble;
@property (nonatomic, strong) MVBubbleView  *highScoreBubble;

@property (nonatomic, strong) NSMutableArray *highScores;

@property (nonatomic, strong) NSMutableArray *extraBubbles;

@property (nonatomic, strong) UIDynamicAnimator     *animator;
@property (nonatomic, strong) UIGravityBehavior     *gravity;
@property (nonatomic, strong) UICollisionBehavior   *collision;


@end

@implementation MVStatingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:@"B5.jpg"];
    [self.view addSubview:bgview];
    
    self.startBubble = [[MVBubbleView alloc] initFrameForStarting:CGRectMake(50, 50, 156, 156)];
    self.creditsBubble = [[MVBubbleView alloc] initFrameForStarting:CGRectMake(200, 200, 100, 100)];
    self.highScoreBubble = [[MVBubbleView alloc] initFrameForStarting:CGRectMake(100, 300, 128, 128)];
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
        
}


-(void)setUpGravity;
{
    self.gravity = [UIGravityBehavior new];
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= .807;
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
        MVViewController *playGame = [MVViewController new];
        playGame.highScores = self.highScores;
        [self presentViewController:playGame animated:YES completion:Nil];
        
    } else if (self.creditsBubble.tapRecognizer == sender) {
        CreditsViewcontroller *credits = [CreditsViewcontroller new];
        [self presentViewController:credits animated:YES completion:Nil];
        
    } else if (self.highScoreBubble.tapRecognizer == sender) {
        MVHighScoreViewController *highScore = [MVHighScoreViewController new];
        highScore.highScores = self.highScores;
        [self presentViewController:highScore animated:YES completion:Nil];
        
    } else {
#warning DO SOMETHING COOL WHEN THE EXTRA BUBBLES ARE TOUCHED
        NSLog(@"DO SOMETHING COOL WHEN THE EXTRA BUBBLES ARE TOUCHED");
    }
    
}


-(void)distortBubble:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < self.extraBubbles.count; i++) {
        MVBubbleView *thisBubble = [self.extraBubbles objectAtIndex:i];
        if (thisBubble.tapRecognizer == sender) {
            [self popThisBubble:thisBubble count:0];
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


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= -1.0;

    MVBubbleView *newbubble = [self.extraBubbles objectAtIndex:0];
    
    if (item == newbubble) {
        [self.gravity setGravityDirection:direction];
    }
    
}

-(void)popThisBubble:(MVBubbleView *)bubble
               count:(int)count
{
    if (count == 0) {
        [bubble.forground removeFromSuperview];
        [self popThisBubble:bubble count:(count + 1)];
    } else if (count < 4) {
        [UIView animateWithDuration:.09 animations:^{
            bubble.frame = CGRectMake(bubble.frame.origin.x, bubble.frame.origin.y + 1, bubble.frame.size.width, bubble.frame.size.height);
            bubble.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"POP%d", count]];
        } completion:^(BOOL finished) {
            [self popThisBubble:bubble count:(count + 1)];
        }];
    } else {
        bubble.background.image = [UIImage imageNamed:[NSString stringWithFormat:@"bubbleBG"]];
        [bubble addSubview:bubble.forground];
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

@end
