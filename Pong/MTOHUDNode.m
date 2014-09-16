//
//  MTOHUDNode.m
//  Pong
//
//  Created by Bradley Spaulding on 9/15/14.
//  Copyright (c) 2014 Motingo. All rights reserved.
//

#import "MTOHUDNode.h"

@implementation MTOHUDNode
-(instancetype)init {
    if (self = [super init]) {
        self.playerOneScore = 0;
        self.playerTwoScore = 0;
        
        [self addScoreLabelWithName:@"player1Score" HorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft  AtPosition:CGPointMake(-40, 0)];
        [self addScoreLabelWithName:@"player2Score" HorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight AtPosition:CGPointMake( 40, 0)];
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

-(void)addScoreLabelWithName:(NSString *)name HorizontalAlignmentMode:(SKLabelHorizontalAlignmentMode)horizontalAlignmentMode AtPosition:(CGPoint)position {
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    scoreLabel.fontColor = [SKColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = horizontalAlignmentMode;
    scoreLabel.text = @"0";
    scoreLabel.name = name;
    scoreLabel.position = position;
    [self addChild:scoreLabel];
}
-(void)incrementPlayerOneScore {
    self.playerOneScore += 1;
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"player1Score"];
    label.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.playerOneScore]];
}
-(void)incrementPlayerTwoScore {
    self.playerTwoScore += 1;
    SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"player2Score"];
    label.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.playerTwoScore]];
}
@end
