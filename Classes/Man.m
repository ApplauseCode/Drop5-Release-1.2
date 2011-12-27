//
//  Man.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/13/10.
//  Copyright 2010 __MyCompanyName_oldHealth_. All rights reserved.
//

#import "Man.h"
#define accel_filter 0.1f

@implementation Man

@synthesize manRect;
@synthesize crashing, dancing, hammering, glowing;
//@synthesize emitter;

+(id) fallingManWithName:(NSString *) name
{
	return [[[self alloc] initWithName: name] autorelease];
}

-(id) initWithName: (NSString *) name
{
	if ((self = [super init]))
	{
		gs = [GameState sharedState];
		crashing = NO;
		dancing = NO;
		hammering = NO;
		glowing = NO;
		manPosX = 0.0f;
		didBounce = NO;
		fallingManSprite = [CCSprite spriteWithSpriteFrameName: name];
		fallingManSprite.position = ccp (gs.size.width / 2, 2.75 * gs.size.height / 4);
		// I don't know why but I need the following code to get the correct bounding box for the falling man
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:name]; 
		[fallingManSprite setTextureRect:frame.rect];

#if USE_BATCH_NODE
		[gs.sheet addChild: fallingManSprite];
#else
		[self addChild:fallingManSprite];
#endif
		[self scheduleUpdate];
	}
	return self;
}

-(void) bounce
{
	didBounce = YES;
	bounceTime = 1.f;
	if (gs.soundOn)
		[[SimpleAudioEngine sharedEngine] playEffect: @"drop_sound.caf"];
}

-(void) glow
{
	glowing = YES;
	id tintUp = [CCTintTo actionWithDuration:0.75 red:255 green:205 blue:0];	
	id tintDown = [CCTintTo actionWithDuration:0.75  red:255 green:255 blue:255];
	id actionCallFunc1 = [CCCallFunc actionWithTarget:self selector:@selector(ripParachute)];
	id actionCallFunc2 = [CCCallFunc actionWithTarget:self selector:@selector(glowDidFinish)];
	[fallingManSprite runAction: [CCSequence actions:tintUp, tintDown, actionCallFunc1, actionCallFunc2, nil]];
}

-(void) glowDidFinish
{
	glowing = NO;
}

-(void) ripParachute
{
	if (gs.health >= 3)
	{
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:@"mc_01.png"]; 
		[fallingManSprite setTextureRect:frame.rect];
	} 
	else if (gs.health == 2)
	{
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:@"mc_02.png"]; 
		[fallingManSprite setTextureRect:frame.rect];
	} 
	else if (gs.health == 1) 
	{
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:@"mc_03.png"]; 
		[fallingManSprite setTextureRect:frame.rect];
	}
}

-(void) crashAnim
{
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:3];
	for (int i = 4; i < 7; i++)
	{
		NSString *file = [NSString stringWithFormat:@"%@%i.png", @"mc_0", i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	crashing = YES;
	CCAnimation* anim = [CCAnimation animationWithFrames:frames delay:0.12f];
	[[CCAnimationCache sharedAnimationCache] addAnimation:anim name:@"crash"];
	CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(crashDidFinish)];
	id crashSequence = [CCSequence actions:animate, [CCDelayTime actionWithDuration:bounceTime], actionCallFunc, nil];
	[fallingManSprite runAction:crashSequence];	
}

-(void) crashDidFinish
{
	crashing = NO;
}

-(void) danceAnim
{
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:11];
	NSString *file;
	for (int i = 11; i < 20; i++)
	{
		file = [NSString stringWithFormat:@"%@%i.png", @"mc_", i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	dancing = YES;
	CCAnimation* anim = [CCAnimation animationWithFrames:frames delay:0.12f];
	CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
	CCRepeat* dance = [CCRepeat actionWithAction:animate times: 6];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(danceDidFinish)];
	id danceSequence = [CCSequence actions: dance, actionCallFunc, nil];
	[fallingManSprite runAction:danceSequence];
	if (gs.soundOn)
	{
		[[SimpleAudioEngine sharedEngine] playEffect: @"Drop_Dance.caf"];
		if (gs.musicOn) [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	}
	//self.emitter = [CCParticleSystemQuad particleWithFile:@"discoFever.plist"];
	//[self addChild: emitter z:-1];
}

-(void) danceDidFinish
{
	dancing = NO;
	//[self removeChild:emitter cleanup:YES];
	if (gs.musicOn) [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void) jackHammerAnim
{
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:2];	
	CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCSpriteFrame* frame = [frameCache spriteFrameByName:@"mc_09.png"];
	[frames addObject:frame];
	frame = [frameCache spriteFrameByName:@"mc_10.png"];
	[frames addObject:frame];
	hammering = YES;
	CCAnimation* anim = [CCAnimation animationWithFrames:frames delay:0.08f];
	CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
	CCRepeat* jackHammer = [CCRepeat actionWithAction:animate times: 25];
	id tintUp = [CCTintTo actionWithDuration:0.5 red:100 green:100 blue:100];
	id tintDown = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(hammerDidFinish)];
	id hammerSequence = [CCSequence actions:tintUp, jackHammer, tintDown, actionCallFunc, nil];
	if (gs.soundOn)
		[[SimpleAudioEngine sharedEngine] playEffect: @"jackhammer_sound.caf"];
	[fallingManSprite runAction:hammerSequence];
}

-(void) hammerDidFinish
{
	hammering = NO;
}

-(void) die
{
	//Send Score to Gamecenter
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper submitScore:gs.score category:@"drop_leaderboard2"];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(changeScene)];
	id actionSequence = [CCSequence actions: [CCMoveBy actionWithDuration:1.0f position:ccp (0,-500)], actionCallFunc, nil];
	[fallingManSprite runAction: actionSequence];
}

-(void) changeScene 
{
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene: [TryAgain scene]]];
}

-(void) update: (ccTime) delta
{
	static float lastAccel = 0;
	float	xMan,yMan,wMan,hMan;
	manPosX	= accel_filter * manPosX +(accel_filter + gs.accelX * (1.8f - accel_filter) * 500.0f);
	if (fallingManSprite.position.x + manPosX * delta > 50 && fallingManSprite.position.x + manPosX * delta < 275) {
		fallingManSprite.position = ccp(fallingManSprite.position.x + manPosX * delta, fallingManSprite.position.y);
		gs.horizontalMovement = YES;
	}
	else {
		gs.horizontalMovement = NO;
	}
    if (gs.health == 0) {
        gs.dead = YES;
    }
	if (didBounce && (bounceTime > 0)) {
		bounceTime -= delta;
		float frac = bounceTime / 1.f;
		float y = (2.75 * gs.size.height / 4.f) + 40.f * ( 4.0f * frac * (1.0f-frac));
		fallingManSprite.position = ccp(fallingManSprite.position.x, y);
	} 
	else {
		didBounce = NO;
		if (gs.dead) {
			[self die];
            [self unscheduleUpdate];
		}
	}
	if(gs.accelX >= .09)
		fallingManSprite.flipX= FALSE;
	else if(gs.accelX <= -.06)
		fallingManSprite.flipX= TRUE;
	xMan = fallingManSprite.position.x-fallingManSprite.contentSize.width/2 + 15;
	yMan = fallingManSprite.position.y-fallingManSprite.contentSize.height/2 - 0;
	hMan = fallingManSprite.contentSize.height - 60;
	wMan = fallingManSprite.contentSize.width - 30;
	manRect=CGRectMake(xMan, yMan, wMan, hMan);
	
	lastAccel = gs.accelX;
}

-(void) dealloc
{
	[super dealloc];
}

/*-(void) draw
 {
 CGRect rect = manRect;
 CGPoint vertices[4]={
 ccp(rect.origin.x,rect.origin.y),ccp(rect.origin.x + rect.size.width,rect.origin.y),
 ccp(rect.origin.x + rect.size.width,rect.origin.y +rect.size.height),ccp(rect.origin.x,rect.origin.y + rect.size.height),
 };
 glLineWidth( 2.0f );
 glColor4ub(255,0,0,255);
 ccDrawPoly(vertices, 4, YES);
 glColor4ub(0,0,0,255);
 
 }*/


@end

