//
//  MTOMyScene.h
//  Pong
//

//  Copyright (c) 2014 Motingo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MTOMyScene : SKScene
@property (nonatomic, strong) UITouch *lastTouch;
@property (nonatomic) NSTimeInterval lastUpdateTime;

-(void)movePaddleTowardPoint:(CGPoint)location byTimeDelta:(NSTimeInterval)timeDelta;
-(void)moveBallByTimeDelta:(NSTimeInterval)timeDelta;
@end
