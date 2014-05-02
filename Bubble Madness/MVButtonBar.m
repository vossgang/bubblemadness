//
//  MVButtonBar.m
//  Bubble Madness
//
//  Created by Matthew Voss on 3/8/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVButtonBar.h"
#import "UIColor+Extension.h"

@implementation MVButtonBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.barImage.image = [UIImage imageNamed:@"newNavBar"];
        [self addSubview:self.barImage];
        
        self.backButton = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width * .0508), (frame.size.height * .1347), (frame.size.width * .3001), (frame.size.height * .7335))];
        [self addSubview:self.backButton];
        
        self.clock = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width * .66), (frame.size.height * .255), (frame.size.width * .2773), (frame.size.height * .494))];
        [self addSubview:self.clock];
        self.clock.textColor = [UIColor flatMidnightBlueColor];
        self.clock.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20];
        self.clock.textAlignment = NSTextAlignmentCenter;
        self.clock.text = [NSString stringWithFormat:@"Time"];
   
        self.score = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width * .3711), (frame.size.height * .255), (frame.size.width * .2891), (frame.size.height * .494))];
        [self addSubview:self.score];
        self.score.textColor = [UIColor flatMidnightBlueColor];
        self.score.textAlignment = NSTextAlignmentCenter;
        self.score.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20];
        self.score.text = [NSString stringWithFormat:@"Score"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end