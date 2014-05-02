//
//  MVButtonBar.h
//  Bubble Madness
//
//  Created by Matthew Voss on 3/8/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVButtonBar : UIView

@property (nonatomic, strong) UIImageView               *barImage;
@property (nonatomic, strong) UIImageView               *backButton;
@property (nonatomic, strong) UILabel                   *clock;
@property (nonatomic, strong) UILabel                   *score;
@property (nonatomic, strong) UITapGestureRecognizer    *backTap;

@end