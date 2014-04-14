//
//  MVBubbleView.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVBubbleView.h"

@implementation MVBubbleView

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
        [self calulateAndAddPointImage:frame];
        [self setBehavior];
        
    }
    return self;
}

-(void)setBehavior
{
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    self.itemBehavior.elasticity = 1.0;

}

- (id)initFrameForStarting:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.background = [UIImageView alloc];

        if (frame.size.height > 150) {
            self.background = [self.background initWithFrame:CGRectMake(3, 25,  frame.size.width - 3, 112.33)];
            self.background.image = [UIImage imageNamed:@"Play.png"];
        } else if (frame.size.height > 120) {
            self.background = [self.background initWithFrame:CGRectMake(0, 35.75,  frame.size.width, 56.5)];
            self.background.image = [UIImage imageNamed:@"Scores.png"];
        } else {
            self.background = [self.background initWithFrame:CGRectMake(0, 25,  frame.size.width, 51)];
            self.background.image = [UIImage imageNamed:@"Credits.png"];
        }
        
        [self addSubview:self.background];
        
        self.forground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  frame.size.width, frame.size.height)];
        self.forground.image = [UIImage imageNamed:@"bubbleBG"];
        [self addSubview:self.forground];
        
        self.pointImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  frame.size.width, frame.size.height)];
        self.pointImage.image = [UIImage imageNamed:@"bubbleFG"];
        [self addSubview:self.pointImage];
        
        [self setBehavior];
    }
    return self;
}

-(void)calulateAndAddPointImage:(CGRect)frame
{
    
    CGSize thissize = CGSizeMake((frame.size.width / 2), (frame.size.height / 2));
    CGPoint center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    CGPoint startpoint = CGPointMake((center.x - (thissize.width / 2)),(center.y - (thissize.height / 2)));
    self.pointImage = [[UIImageView alloc] initWithFrame:CGRectMake((startpoint.x), (startpoint.y), (thissize.height), (thissize.width))];
    
    if (self.frame.size.height >= 122) {
        self.pointImage.image = [UIImage imageNamed:@"1.png"];
        self.scoreValue = 1;
    } else if  (self.frame.size.height >= 116){
        self.pointImage.image = [UIImage imageNamed:@"2.png"];
        self.scoreValue = 2;
    } else if  (self.frame.size.height >= 109){
        self.pointImage.image = [UIImage imageNamed:@"3.png"];
        self.scoreValue = 3;
    } else if  (self.frame.size.height >= 103){
        self.pointImage.image = [UIImage imageNamed:@"4.png"];
        self.scoreValue = 4;
    } else if  (self.frame.size.height >= 96){
        self.pointImage.image = [UIImage imageNamed:@"5.png"];
        self.scoreValue = 5;
    } else if  (self.frame.size.height >= 90){
        self.pointImage.image = [UIImage imageNamed:@"6.png"];
        self.scoreValue = 6;
    } else if  (self.frame.size.height >= 84){
        self.pointImage.image = [UIImage imageNamed:@"7.png"];
        self.scoreValue = 7;
    } else if  (self.frame.size.height >= 77){
        self.pointImage.image = [UIImage imageNamed:@"8.png"];
        self.scoreValue = 8;
    } else if  (self.frame.size.height >= 70){
        self.pointImage.image = [UIImage imageNamed:@"9.png"];
        self.scoreValue = 9;
    } else if (self.frame.size.height >= 33){
        self.pointImage.image = [UIImage imageNamed:@"10.png"];
        self.scoreValue = 10;
    } else {
        self.pointImage.image = [UIImage imageNamed:@"addTime.png"];
        self.scoreValue = 0;
    }
    [self addSubview:self.pointImage];
    
}


-(void)removeForgroundFromView
{
    [self.forground removeFromSuperview];
    self.forground = nil;
}



@end
