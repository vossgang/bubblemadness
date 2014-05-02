//
//  CreditsView.m
//  Bubble Madness
//
//  Created by Matthew Voss on 5/1/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "CreditsView.h"
#import "UIColor+Extension.h"

@implementation CreditsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int middleY = frame.size.height / 2;
        int labelHeight = frame.size.height / 10;
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];

        self.gameName = [[UILabel alloc] initWithFrame:CGRectMake(0, (middleY - (2 * labelHeight)), frame.size.width, labelHeight)];
        self.gameDesignedBy = [[UILabel alloc] initWithFrame:CGRectMake(0, (middleY - labelHeight), frame.size.width, labelHeight)];
        self.gameDesgnerName = [[UILabel alloc] initWithFrame:CGRectMake(0, middleY,frame.size.width, labelHeight)];
        self.gameArtWorkBy = [[UILabel alloc] initWithFrame:CGRectMake(0, (middleY + labelHeight), frame.size.width, labelHeight)];
        self.gameArtistName = [[UILabel alloc] initWithFrame:CGRectMake(0, (middleY + (2 * labelHeight)),frame.size.width, labelHeight)];
        
        self.gameName.text = @"bubble OPP";
        self.gameDesignedBy.text = @"Designed by:";
        self.gameDesgnerName.text = @"Matthew Voss";
        self.gameArtWorkBy.text = @"Art work by:";
        self.gameArtistName.text = @"Christopher Cohen";
        
        self.gameName.textAlignment = NSTextAlignmentCenter;
        self.gameDesignedBy.textAlignment = NSTextAlignmentCenter;
        self.gameDesgnerName.textAlignment = NSTextAlignmentCenter;
        self.gameArtWorkBy.textAlignment = NSTextAlignmentCenter;
        self.gameArtistName.textAlignment = NSTextAlignmentCenter;
        
        self.gameName.textColor = [UIColor LapisLazuliColor];
        self.gameDesignedBy.textColor = [UIColor LapisLazuliColor];
        self.gameDesgnerName.textColor = [UIColor LapisLazuliColor];
        self.gameArtWorkBy.textColor = [UIColor LapisLazuliColor];
        self.gameArtistName.textColor = [UIColor LapisLazuliColor];
        
        self.gameName.alpha = .8;
        self.gameDesignedBy.alpha = .8;
        self.gameDesgnerName.alpha = .8;
        self.gameArtWorkBy.alpha = .8;
        self.gameArtistName.alpha = .8;
        
        self.gameName.font = [UIFont systemFontOfSize:42];
        self.gameDesignedBy.font = [UIFont systemFontOfSize:42];
        self.gameDesgnerName.font = [UIFont systemFontOfSize:42];
        self.gameArtWorkBy.font = [UIFont systemFontOfSize:42];
        self.gameArtistName.font = [UIFont systemFontOfSize:42];
        
        self.gameName.adjustsFontSizeToFitWidth = YES;
        self.gameDesignedBy.adjustsFontSizeToFitWidth = YES;
        self.gameDesgnerName.adjustsFontSizeToFitWidth = YES;
        self.gameArtWorkBy.adjustsFontSizeToFitWidth = YES;
        self.gameArtistName.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.gameName];
        [self addSubview:self.gameDesignedBy];
        [self addSubview:self.gameDesgnerName];
        [self addSubview:self.gameArtWorkBy];
        [self addSubview:self.gameArtistName];
        
        // Initialization code
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
