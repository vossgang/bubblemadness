//
//  MVViewController.h
//  Bubble Madness
//
//  Created by Matthew Voss on 3/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVViewController : UIViewController

@property (nonatomic, weak) NSMutableArray        *highScores;

@property (nonatomic) NSInteger GAME_MODE;

+(NSString *)documentsDirectory;

@end