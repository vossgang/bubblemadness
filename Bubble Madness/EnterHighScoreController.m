//
//  EnterHighScoreController.m
//  Bubble Madness
//
//  Created by Matthew Voss on 4/11/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "EnterHighScoreController.h"
#import "MVButtonBar.h"

@interface EnterHighScoreController () <UITextFieldDelegate>

@property (nonatomic, strong)   MVButtonBar             *toolBar;
@property (nonatomic)           NSInteger               toolBarHieght;
@property (nonatomic)           CGRect                  screenRect;
@property (nonatomic, strong)   UITextField             *highScoreName;
@property (nonatomic, weak)     MVHighScore             *currentHighScore;


@end

@implementation EnterHighScoreController

-(void)viewWillDisappear:(BOOL)animated
{
    self.currentHighScore.playerName = self.highScoreName.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentHighScore = [self.highScores objectAtIndex:0];

    
    self.screenRect = [[UIScreen mainScreen] bounds];
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgview.image = [UIImage imageNamed:[NSString stringWithFormat:@"B%d.jpg", ((arc4random() % 5) + 1)]];
    
    [self.view addSubview:bgview];
    
    self.currentHighScore.playerName = [NSString new];

    self.highScoreName = [[UITextField  alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    self.highScoreName.userInteractionEnabled = YES;
    self.highScoreName.borderStyle = UITextBorderStyleRoundedRect;
    self.highScoreName.text = @"";
    self.highScoreName.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.highScoreName.delegate = self;
    [self.view addSubview:self.highScoreName];
    
    

    [self placeToolBar];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)handleTap:(UITapGestureRecognizer *)sender
{
  
    if (sender == _toolBar.backTap) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 3 && range.length == 0)
    {
    	return NO; // return NO to not change text
    }
    else
    {return YES;}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.currentHighScore.playerName = self.highScoreName.text;
        
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
