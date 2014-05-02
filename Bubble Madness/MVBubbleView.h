//
//  MVBubbleView.h
//  Bubble Madness
//
//  Created by Matthew Voss on 3/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVBubbleView : UIView

@property (nonatomic, strong)   UIImageView             *background;
@property (nonatomic, strong)   UIImageView             *forground;
@property (nonatomic, strong)   UIImageView             *pointImage;

@property (nonatomic)           NSInteger                scoreValue;

@property (nonatomic, strong)   UITapGestureRecognizer  *tapRecognizer;
@property (nonatomic, strong)   UIDynamicItemBehavior   *itemBehavior;


- (id)initFrameForStarting:(CGRect)frame;
-(void)removeForgroundFromView;
-(void)removePointImageFromView;
-(void)removeSubviews;

-(void)resetFGAndPointImages;

@end