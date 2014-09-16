//
//  MTOMyScene.m
//  Pong
//
//  Created by Bradley Spaulding on 9/12/14.
//  Copyright (c) 2014 Motingo. All rights reserved.
//

#import "MTOMyScene.h"

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
    }
    return self;
}

- (void)addPaddle1:(CGSize)size {
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    paddle.name = @"paddle1";
    paddle.size = CGSizeMake(6, size.width/6.0);
    paddle.position = CGPointMake(10, size.height/2.0);
    [self addChild:paddle];
}

- (void)addPaddle2:(CGSize)size {
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    paddle.name = @"paddle2";
    paddle.size = CGSizeMake(6, size.width/6.0);
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.lastTouch = [touches anyObject];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.lastTouch = [touches anyObject];
}

-(void)update:(CFTimeInterval)currentTime {
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
    CGFloat paddleSpeed = 200; // points per second
    CGFloat distanceLeft = sqrt(pow(paddle.position.x - point.x, 2) +
                                pow(paddle.position.y - point.y, 2));
    if (distanceLeft > 4) {
        CGFloat distanceToTravel = timeDelta * paddleSpeed;
        CGFloat angle = atan2(point.y - paddle.position.y,
                              point.x - paddle.position.x);
        CGFloat yOffset = distanceToTravel * sin(angle);
        paddle.position = CGPointMake(paddle.position.x,
                                    paddle.position.y + yOffset);
    }
}

-(void)moveBallByTimeDelta:(NSTimeInterval)timeDelta {
    CGFloat ballSpeed = 150; // points per second
    SKNode *ball = [self childNodeWithName:@"ball"];
    
    if (ball.position.x < 0 || ball.position.x > self.size.width) {
        self.ballVelocity = CGPointMake(0, 0);
        [ball removeFromParent];
    } else {
        CGFloat velocityY = self.ballVelocity.y;
        CGFloat velocityX = self.ballVelocity.x;
        if (ball.position.y < 0 || ball.position.y > self.size.height) {
            velocityY = velocityY * -1;
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

@end
