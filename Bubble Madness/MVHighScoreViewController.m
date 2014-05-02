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

@interface MVHighScoreViewController () <UIActionSheetDelegate>

@property (nonatomic)         CGRect             screenRect;
@property (nonatomic, strong) MVButtonBar       *toolBar;
@property (nonatomic, strong) NSMutableArray    *highScoreBubbles;
@property (nonatomic, strong) UIImageView       *bgview;
@property (nonatomic, strong) UIActionSheet     *deleteSheet;
@property (nonatomic)         NSInteger          indexOfBubble;
@property (nonatomic, strong) UIDynamicAnimator     *animator;              //animate the bubbles
@property (nonatomic, strong) UIGravityBehavior     *gravity;               //gravity for the bubbles
@property (nonatomic, strong) UICollisionBehavior   *collision;             //collision for everything on screen
@property (nonatomic, strong) NSTimer               *changeGravityXTimer;
@property (nonatomic, strong) NSTimer               *changeGravityYTimer;

@end

@implementation MVHighScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.highScoreBubbles = [NSMutableArray new];
    
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    self.bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.bgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"B%d.jpg", ((arc4random() % 3) + 1)]];
    
    [self.view addSubview:self.bgview];
    [self placeToolBar];
    self.deleteSheet = [[UIActionSheet alloc] initWithTitle:@"Delete HighScore?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete This High Score", nil];
}


-(void)changeGravityX
{
    
    CGVector direction =  self.gravity.gravityDirection;
    direction.dx *= -1.0;
    self.gravity.gravityDirection = direction;
}

-(void)changeGravityY
{
    
    CGVector direction =  self.gravity.gravityDirection;
    direction.dy *= -1.0;
    self.gravity.gravityDirection = direction;
}

-(void)setUpAnimations
{
    self.collision = [UICollisionBehavior new];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.collision addBoundaryWithIdentifier:@"toolbar" fromPoint:CGPointMake(0, self.toolBar.frame.origin.y) toPoint:CGPointMake(self.screenRect.size.width, self.toolBar.frame.origin.y)];
    
    self.gravity = [UIGravityBehavior new];
    CGVector direction = self.gravity.gravityDirection;
    direction.dy *= .207;
    direction.dx  = .105;
    [self.gravity setGravityDirection:direction];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    
    MVHighScoreBubble *HSbubble;
    for (int i = 0 ; i < self.highScores.count; i++) {
        HSbubble = [self.highScoreBubbles objectAtIndex:i];
        HSbubble.itemBehavior = [UIDynamicItemBehavior new];
        HSbubble.itemBehavior.elasticity = 1;
        HSbubble.itemBehavior.allowsRotation = NO;
        [self.gravity addItem:HSbubble];
        [self.collision addItem:HSbubble];
        [self.animator addBehavior:HSbubble.itemBehavior];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.highScores) {
        if (self.screenRect.size.height > 500) {
            [self showHighScoresForTalliPhone];
        } else {
            [self showHighScoresForSmalliPhone];
        }
        [self setUpAnimations];
        self.changeGravityXTimer = [NSTimer scheduledTimerWithTimeInterval:1.4
                                                                    target:self
                                                                  selector:@selector(changeGravityX)
                                                                  userInfo:nil
                                                                   repeats:YES];
        
        self.changeGravityYTimer = [NSTimer scheduledTimerWithTimeInterval:2.1
                                                                    target:self
                                                                  selector:@selector(changeGravityY)
                                                                  userInfo:nil
                                                                   repeats:YES];
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

-(void)showHighScoresForTalliPhone
{
    NSArray *bubblearray = @[   [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(24, 1, 128, 128)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(168, 1, 128, 128)],
                                
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(1, 130, 96, 96)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(107, 130, 96, 96)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(213, 130, 96, 96)],
                                
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(24, 237, 84, 84)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(168, 237, 84, 84)],
                                
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(1, 367, 72, 72)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(107, 367, 72, 72)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(213, 367, 72, 72)],
                                
                                ];
    
    self.highScoreBubbles = [bubblearray mutableCopy];
    
    [self addImagesToHighScoreBubbles];
}

-(void)showHighScoresForSmalliPhone
{
    NSArray *bubblearray = @[   [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(24, 1, 128, 128)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(168, 1, 128, 128)],
                                
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(10, 125, 96, 96)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(112, 125, 96, 96)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(214, 125, 96, 96)],
                                
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(43, 215, 84, 84)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(180, 215, 84, 84)],
                                
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(10, 305, 72, 72)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(112, 305, 72, 72)],
                                [[MVHighScoreBubble alloc] initWithFrame:CGRectMake(214, 305, 72, 72)],
                                
                                ];
    
    self.highScoreBubbles = [bubblearray mutableCopy];
    [self addImagesToHighScoreBubbles];
}

-(void)addImagesToHighScoreBubbles
{
    MVHighScore *thisHighScore = [MVHighScore new];
    
    for (int i = 0; i < self.highScores.count; i++) {
        thisHighScore = [self.highScores objectAtIndex:i];
        thisHighScore.score = [NSString stringWithFormat:@"%ld", (long)thisHighScore.number];
        [self.highScoreBubbles[i] putHighScoreImage:thisHighScore.score];
        //        [self.highScoreBubbles[i] putHighScoreName:thisHighScore.playerName];
        [self.view addSubview:self.highScoreBubbles[i]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:self.view];
        for (MVHighScoreBubble *bubble in self.view.subviews){
            
            if ([bubble isKindOfClass:[MVHighScoreBubble class]]) {
                if ([self distanceBetweenPoint:touchPoint andPoint:bubble.center] < (bubble.frame.size.height * .45)){
                    if (self.highScores.count > 1) {
                        self.indexOfBubble = [self.highScoreBubbles indexOfObject:bubble];
                        [self.deleteSheet showInView:self.view];
                    }
                }
            }
        }
    }
}

-(void)popThisBubble:(MVHighScoreBubble *)bubble
{
    [bubble removeSubviewsFromView];

    [UIView animateWithDuration:.25 animations:^{
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
        [self deleteHighScore:[self.highScores objectAtIndex:self.indexOfBubble]];
        [self.highScoreBubbles removeObject:bubble];
        [bubble removeFromSuperview];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveToFile];
}

-(CGFloat)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2));
}

-(void)saveToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"save.plist"];
    [NSKeyedArchiver archiveRootObject:self.highScores toFile:appFile];
}

-(void)deleteHighScore:(MVHighScore *)score
{
        [self.highScores removeObjectIdenticalTo:score];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete This High Score"]) {
        [self popThisBubble:self.highScoreBubbles[self.indexOfBubble]];
    }
}
@end