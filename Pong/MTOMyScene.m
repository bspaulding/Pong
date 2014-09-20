//
//  MTOMyScene.m
//  Pong
//
//  Created by Bradley Spaulding on 9/12/14.
//  Copyright (c) 2014 Motingo. All rights reserved.
//

#import "MTOMyScene.h"
#import "MTOHUDNode.h"

@implementation MTOMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:235.0/255.0
                                               green:235.0/255.0
                                                blue:235.0/255.0
                                               alpha:1.0];
        [self addPaddle1:size];
        [self addPaddle2:size];
        [self addBall:size];
        [self addHUD:size];
        [self addTapToPlay:size];
        
        self.playing = NO;
    }
    return self;
}

- (void)addPaddle1:(CGSize)size {
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    paddle.name = @"paddle1";
    paddle.size = CGSizeMake(6, size.width/8.0);
    paddle.position = CGPointMake(10, size.height/2.0);
    [self addChild:paddle];
}

- (void)addPaddle2:(CGSize)size {
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    paddle.name = @"paddle2";
    paddle.size = CGSizeMake(6, size.width/8.0);
    paddle.position = CGPointMake(size.width - 10, size.height/2.0);
    [self addChild:paddle];
}

-(void)addBall:(CGSize)size {
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.name = @"ball";
    ball.size = CGSizeMake(12, 12);
    ball.position = CGPointMake(size.width / 2, size.height / 2);
    
    [self addChild:ball];
    self.ballVelocity = CGPointMake(-1, 1);
}

-(void)addHUD:(CGSize)size {
    MTOHUDNode *hud = [MTOHUDNode node];
    hud.name = @"hud";
    hud.position = CGPointMake(size.width / 2, size.height - 24);
    [self addChild:hud];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.lastTouch = [touches anyObject];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.lastTouch = [touches anyObject];
}

-(void)update:(CFTimeInterval)currentTime {
    if (!self.playing) {
        if (!self.tapGesture) {
            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
            [self.view addGestureRecognizer:self.tapGesture];
        }
        
        self.lastUpdateTime = currentTime;
        return;
    }
    
    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = currentTime;
    }
    
    NSTimeInterval timeDelta = currentTime - self.lastUpdateTime;
    
    [self moveAIPaddle:timeDelta];
    
    if (self.lastTouch) {
        SKNode *paddle = [self childNodeWithName:@"paddle1"];
        [self movePaddle:paddle TowardPoint:[self.lastTouch locationInNode:self] byTimeDelta:timeDelta];
    }
    
    [self moveBallByTimeDelta:timeDelta];
    [self checkCollisions];
    
    self.lastUpdateTime = currentTime;
}

-(void)movePaddle:(SKNode *)paddle TowardPoint:(CGPoint)point byTimeDelta:(NSTimeInterval)timeDelta {
    CGFloat paddleSpeed = 250; // points per second
    CGFloat distanceLeft = sqrt(pow(0, 2) +
                                pow(paddle.position.y - point.y, 2));
    if (distanceLeft > 4) {
        CGFloat distanceToTravel = timeDelta * paddleSpeed;
        CGFloat angle = atan2(point.y - paddle.position.y,
                              0);
        CGFloat yOffset = distanceToTravel * sin(angle);
        paddle.position = CGPointMake(paddle.position.x,
                                    paddle.position.y + yOffset);
    }
}

-(void)moveBallByTimeDelta:(NSTimeInterval)timeDelta {
    CGFloat ballSpeed = 300; // points per second
    SKNode *ball = [self childNodeWithName:@"ball"];
    
    if (ball.position.x < 0 || ball.position.x > self.size.width) {
        MTOHUDNode *hud = (MTOHUDNode *)[self childNodeWithName:@"hud"];
        if (ball.position.x < 0) {
            [hud incrementPlayerTwoScore];
        } else {
            [hud incrementPlayerOneScore];
        }
        
        [self reset];
    } else {
        CGFloat velocityY = self.ballVelocity.y;
        CGFloat velocityX = self.ballVelocity.x;
        if (ball.position.y < 0 || ball.position.y > self.size.height) {
            velocityY = velocityY * -1;
            if (ball.position.y < 0) {
                ball.position = CGPointMake(ball.position.x, 0 + ball.frame.size.height / 2);
            } else {
                ball.position = CGPointMake(ball.position.x, self.size.height - ball.frame.size.height / 2);
            }
        }
        self.ballVelocity = CGPointMake(velocityX, velocityY);
        ball.position = CGPointMake(ball.position.x + velocityX * timeDelta * ballSpeed,
                                    ball.position.y + velocityY * timeDelta * ballSpeed);
    }
}

-(void)checkCollisions {
    SKNode *ball = [self childNodeWithName:@"ball"];
    SKNode *paddle1 = [self childNodeWithName:@"paddle1"];
    SKNode *paddle2 = [self childNodeWithName:@"paddle2"];
   
    if ([ball intersectsNode:paddle1] || [ball intersectsNode:paddle2]) {
        self.ballVelocity = CGPointMake(-1 * self.ballVelocity.x, self.ballVelocity.y);
        ball.position = CGPointMake(ball.position.x + 4 * self.ballVelocity.x,
                                    ball.position.y + 4 * self.ballVelocity.y);
    }
}

-(void)moveAIPaddle:(NSTimeInterval)timeDelta {
    SKNode *ball = [self childNodeWithName:@"ball"];
    SKNode *paddle = [self childNodeWithName:@"paddle2"];
    if (ball) {
        CGFloat newY = ball.position.y;
        CGFloat newX = self.size.width * 0.9;
        
        [self movePaddle:paddle
             TowardPoint:CGPointMake(newX, newY)
             byTimeDelta:timeDelta];
    }
}

-(void)showTapToPlay {
    [self addTapToPlay:self.view.frame.size];
}
-(void)hideTapToPlay {
    [[self childNodeWithName:@"tapToPlay"] removeFromParent];
}
-(void)addTapToPlay:(CGSize)size {
    SKLabelNode *tapToPlay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    tapToPlay.name = @"tapToPlay";
    tapToPlay.text = @"tap to play";
    tapToPlay.fontSize = 24;
    tapToPlay.fontColor = [SKColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    tapToPlay.position = CGPointMake(size.width / 2, size.height * 0.6);
    
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:0.7];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:0.7];
    SKAction *blink = [SKAction sequence:@[fadeOut, fadeIn]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [tapToPlay runAction:blinkForever];
    
    [self addChild:tapToPlay];
}

-(void)tapped {
    [self hideTapToPlay];
    [self.view removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
    self.playing = YES;
}

-(void)resetPaddlePositions {
    CGSize size = self.view.frame.size;
    SKNode *paddle = [self childNodeWithName:@"paddle1"];
    paddle.position = CGPointMake(10, size.height/2.0);
    paddle = [self childNodeWithName:@"paddle2"];
    paddle.position = CGPointMake(size.width - 10, size.height/2.0);
}

-(void)reset {
    self.playing = NO;
    CGSize size = self.view.frame.size;
    SKNode *ball = [self childNodeWithName:@"ball"];
    ball.position = CGPointMake(size.width / 2, size.height / 2);
    [self addTapToPlay:self.view.frame.size];
    [self resetPaddlePositions];
}

@end
