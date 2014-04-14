//
//  CreditsViewcontroller.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/10/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "CreditsViewcontroller.h"
#import "MVButtonBar.h"

@interface CreditsViewcontroller ()

@property (nonatomic)         CGRect         screenRect;

@property (nonatomic, strong) MVButtonBar   *toolBar;



@end

@implementation CreditsViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenRect = [[UIScreen mainScreen] bounds];

    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"B%d.jpg", ((arc4random() % 5) + 1)]];
    
    [self.view addSubview:bgview];
    [self placeToolBar];
    [self DisplayCredits];
}

-(void)placeToolBar
{
    CGRect toolBarFrame;
    NSInteger toolBarHieght = (self.screenRect.size.width / 4);
    toolBarFrame = CGRectMake(0, (self.screenRect.size.height - toolBarHieght), self.screenRect.size.width, toolBarHieght);
    
    self.toolBar = [[MVButtonBar alloc] initWithFrame:toolBarFrame];
    self.toolBar.clock.text = @" ";
    self.toolBar.score.text = @"Back";
    
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

-(void)DisplayCredits
{
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.screenRect.size.width, 30)];
    name.text = @"Bubble Madness";
    name.textColor = [UIColor blackColor];
    name.font = [UIFont systemFontOfSize:30];
    name.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:name];

    UILabel *design = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.screenRect.size.width, 40)];
    design.text = @"Game By:";
    design.textColor = [UIColor blackColor];
    design.font = [UIFont systemFontOfSize:30];
    design.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:design];
   
    UILabel *designer = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.screenRect.size.width, 40)];
    designer.text = @"Matthew Voss";
    designer.textColor = [UIColor blackColor];
    designer.font = [UIFont systemFontOfSize:30];
    designer.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:designer];

    UILabel *graphics = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, self.screenRect.size.width, 40)];
    graphics.text = @"Graphics By:";
    graphics.textColor = [UIColor blackColor];
    graphics.font = [UIFont systemFontOfSize:30];
    graphics.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:graphics];
    
    UILabel *graphicsBy = [[UILabel alloc] initWithFrame:CGRectMake(0, 275, self.screenRect.size.width, 40)];
    graphicsBy.text = @"Christopher Cohen";
    graphicsBy.textColor = [UIColor blackColor];
    graphicsBy.font = [UIFont systemFontOfSize:30];
    graphicsBy.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:graphicsBy];
    
}


@end
