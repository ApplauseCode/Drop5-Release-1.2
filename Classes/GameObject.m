//
//  GameObject.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

@synthesize active, vibrating /*shuffling*/;

-(id) initWithName: (NSString *) name xCoord: (float) xCoord flipped: (bool) flipped
{
	if ((self = [super init])) {
		gs = [GameState sharedState];
		gameSprite = [CCSprite spriteWithSpriteFrameName: name];
		gameSprite.position=ccp(xCoord, -120);
		gameSprite.flipX = flipped;
		active = NO;
		vibrating = NO;
		posX = xCoord;
#if USE_BATCH_NODE
		[gs.sheet addChild: gameSprite];
#else
		[self addChild:gameSprite];
#endif
	}
	return self;
}

/*-(void) danceHit
{
	shuffling = YES;
	id actionCallFunc = [CCCallFunc actionWithTarget: self selector:@selector(shufflingDidFinish)];
	id shuffle = [CCRepeat actionWithAction:[CCSequence actions: [CCScaleTo actionWithDuration:0.05 scale: .92], 
											 [CCScaleTo actionWithDuration:.05 scale: 1], nil] times: 15];
	id shuffleAction = [CCSequence actions: shuffle, actionCallFunc, nil];
	[gameSprite runAction: shuffleAction];
}*/

-(void) hammerHit
{
	vibrating = YES;
	id actionCallFunc = [CCCallFunc actionWithTarget: self selector:@selector(vibratingDidFinish)];
	id vibrate = [CCRepeat actionWithAction:[CCSequence actions: [CCRotateBy actionWithDuration:0.05 angle:5], 
											 [CCRotateBy actionWithDuration:.05 angle: -5], nil] times: 15];
	id vibrateAction = [CCSequence actions: vibrate, actionCallFunc, nil];
	[gameSprite runAction: vibrateAction];
}

-(void) spin
{
	CCOrbitCamera *orbit;
	orbit = [CCOrbitCamera actionWithDuration:2 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:360 angleX:0 deltaAngleX:0];
	[gameSprite runAction:[CCRepeatForever actionWithAction:orbit]];
}

-(void) vibratingDidFinish
{
	vibrating = NO;
}

-(void) shufflingDidFinish
{
	shuffling = NO;
}

-(void) update: (ccTime) delta
{	
	if (active) 
	{
		CGPoint pos = gameSprite.position;
		pos.y += gs.gameSpeed * delta;
		pos.y = (int)(pos.y + 0.5f);
		pos.x = posX + gs.skyscraperOffset;
		if (pos.y > 550) {
			active = NO;
			pos.y = -120;
		}
		gameSprite.position = pos;
	}
}
@end
