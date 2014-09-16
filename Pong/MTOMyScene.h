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
@property (nonatomic) CGPoint ballVelocity;

-(void)movePaddle:(SKNode *)paddle TowardPoint:(CGPoint)point byTimeDelta:(NSTimeInterval)timeDelta;
-(void)moveBallByTimeDelta:(NSTimeInterval)timeDelta;
-(void)moveAIPaddle:(NSTimeInterval)timeDelta;
@end
