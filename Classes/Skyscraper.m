//
//  Skyscraper.m
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Skyscraper.h"

@implementation Skyscraper


+(id) skyscraperWithPng:(NSString *)png
{
	return [[[self alloc] initWithPng:png] autorelease];
}

-(id) initWithPng: (NSString *) png
{
	if ((self = [super init]))
	{
		gs = [GameState sharedState];
		skyPosX = 0.0f;
		skyscrapers = [CCSprite spriteWithFile:png];
		skyscrapers.position = ccp (gs.size.width /2, 0);
		[self addChild: skyscrapers];
		[self scheduleUpdate];
	}
	return self;
}

-(void) update: (ccTime) delta
{
	static float accel_filter = 0.1f;
	CGPoint pos = skyscrapers.position;
	pos.y += gs.gameSpeed * delta;
	pos.y = (int)(pos.y + 0.5f) % 480;
	skyPosX	= accel_filter * skyPosX +(accel_filter + gs.accelX * (1.8f - accel_filter) * 500.0f);
	if (gs.horizontalMovement) {
		pos.x = pos.x + skyPosX * delta / 4;
	}
	gs.skyscraperOffset = pos.x - gs.size.width /  2;
	if (fabs(gs.skyscraperOffset) < 30)
		skyscrapers.position = pos;
}

-(void) setOpacity: (int) opacity{
	[skyscrapers setOpacity:opacity];
}

-(void) dealloc
{
	[super dealloc];
}
@end
