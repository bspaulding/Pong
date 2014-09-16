//
//  MTOHUDNode.h
//  Pong
//
//  Created by Bradley Spaulding on 9/15/14.
//  Copyright (c) 2014 Motingo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MTOHUDNode : SKNode
@property (nonatomic) CGFloat playerOneScore;
@property (nonatomic) CGFloat playerTwoScore;
@property (nonatomic) NSNumberFormatter *numberFormatter;

-(void)incrementPlayerOneScore;
-(void)incrementPlayerTwoScore;
@end
