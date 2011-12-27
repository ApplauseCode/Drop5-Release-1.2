//
//  LevelScene.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelScene.h"
#define kLevelChangeInc 2000
#define kGameSpreedInc 3.0f

@implementation LevelScene

+(id) sceneWithName: (NSString *) name night: (bool) _night
{
	CCScene *scene = [CCScene node];
	LevelScene *layer = [[[self alloc] initWithName: name night: _night] autorelease];
	[scene addChild:layer z:0];
	return scene;
}

-(id) initWithName: (NSString *) name night: (bool) _night
{
	if ((self = [super init]))
	{
		gs = [GameState sharedState];
		if (gs.parent == nil) 
			[self addChild:gs];
		
#if USE_BATCH_NODE
		gs.sheet = [CCSpriteBatchNode spriteSheetWithFile:@"z.png"];
#endif
		
		NSString *path = [CCFileUtils fullPathFromRelativePath:name];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
		NSDictionary *smallObstacles = [dict objectForKey:@"smallObstacles"];
		NSDictionary *largeObstacles = [dict objectForKey:@"largeObstacles"];
		NSDictionary *longObstacles = [dict objectForKey:@"longObstacles"];
		NSDictionary *powerUps = [dict objectForKey:@"powerUps"];
		gs.horizontalMovement = YES;
		if (gs.level < 4) {
			gs.gameSpeed = [[dict objectForKey:@"gameSpeed"] floatValue];
		}
		else {
			gs.gameSpeed = [[dict objectForKey:@"nightSpeed"] floatValue];
		}
		skyscraper = [Skyscraper skyscraperWithPng:[dict objectForKey:@"skyscraper"]];
		[self addChild: skyscraper];
		obstacleManager = [ObstacleManager node];
		obstacleManager.numberOfSmallObstacles = 2 * [smallObstacles count];
		obstacleManager.numberOfLargeObstacles = 2 * [largeObstacles count];
		obstacleManager.numberOfPowerUps = [powerUps count];

		// small obstacles
		for (NSString *key in smallObstacles) 
			[obstacleManager addThing:[Obstacle obstacleWithName:key dict:[smallObstacles objectForKey: key] left:YES]];
		for (NSString *key in smallObstacles) 
			[obstacleManager addThing:[Obstacle obstacleWithName:key dict:[smallObstacles objectForKey: key] left:NO]];
		// large obstacles
		for (NSString *key in largeObstacles) {
			[obstacleManager addThing:[Obstacle obstacleWithName:key dict:[largeObstacles objectForKey: key] left:YES]];
			[obstacleManager addThing:[Obstacle obstacleWithName:key dict:[largeObstacles objectForKey: key] left:NO]];
		}
		// long obstacle
		for (NSString *key in longObstacles) 
			[obstacleManager addThing:[LongObstacle longObstacleWithName:key dict:[longObstacles objectForKey: key]]];
		// power ups
		for (NSString *key in powerUps) 
			[obstacleManager addThing:[PowerUp powerUpWithName:key dict:[powerUps objectForKey: key]]];
		
		if (_night) {
			backgroundTop = [CCSprite spriteWithFile:[dict objectForKey:@"backgroundNight_top"]];
			backgroundBot = [CCSprite spriteWithFile:[dict objectForKey:@"backgroundNight_bot"]];
		}
		else
		{
			backgroundTop = [CCSprite spriteWithFile:[dict objectForKey:@"background_top"]];
			backgroundBot = [CCSprite spriteWithFile:[dict objectForKey:@"background_bot"]];
		}
		[self addChild:backgroundTop z:-1];
		[self addChild:backgroundBot z:-1];
		backgroundTop.position = ccp (gs.size.width/2, 50);
		backgroundBot.position = ccp (gs.size.width/2, -947);
		id scrollActionTop = [CCMoveBy actionWithDuration:90 position:ccp (0,1000)];
		id scrollActionBot = [CCMoveBy actionWithDuration:90 position:ccp (0,1000)];
		[backgroundTop runAction: [CCRepeatForever actionWithAction: [CCSequence actions: scrollActionTop, nil]]];
		[backgroundBot runAction: [CCRepeatForever actionWithAction: [CCSequence actions: scrollActionBot, nil]]];
		if (! _night && gs.musicOn) {
			if (gs.level < 3) {
				[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"morningLoop.caf" loop:YES];
			}
			else {
				[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"dayLoop.caf" loop:YES];	
			}			
		}
		else if (gs.musicOn) {
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"nightLoop.caf" loop:YES];
		}

#if USE_BATCH_NODE				
		[obstacleManager addChild: gs.sheet];
#endif
		[self addChild: obstacleManager];
		scoreLabel1 = [CCLabelBMFont labelWithString:@"score" fntFile:@"capture.fnt"];
        [scoreLabel1 setColor:ccBLACK];
		//[self addChild:scoreLabel1 z:4];
        scoreLabel1.position = ccp(115,460);
		
		scoreLabel2 = [CCLabelBMFont labelWithString:@"0" fntFile:@"capture.fnt"];
        [scoreLabel2 setColor:ccBLACK];
		scoreLabel2.opacity = 170;
		//scoreLabel2.anchorPoint = ccp(0,0);
		[self addChild:scoreLabel2 z:4];
        scoreLabel2.position = ccp(gs.size.width/2,460);
		
		parachutes = [[CCArray alloc] initWithCapacity:6];
		for (int i = 0; i < 6; i++) {
			CCSprite *parachute = [CCSprite spriteWithSpriteFrameName: @"icon_lives.png"];
			[parachute setScale:.60];
			[parachute setOpacity:180];
			[parachutes addObject:parachute];
			if (i < gs.health) {
				parachute.position = ccp(20,460-i*33);
			}
			else {
				parachute.position = ccp(-20,460-i*33);
			}
			[self addChild:parachute];
		}
		
		CCMenuItem *pause = [CCMenuItemImage itemFromNormalImage:@"pause_button_small.png" selectedImage:@"pause_button_small.png" target:self selector:@selector(onPause)];
		pauseMenu = [CCMenu menuWithItems:pause, nil];
        [pauseMenu setOpacity:110];
		[pauseMenu alignItemsVertically];
		pauseMenu.position = ccp(300,460);
		[self addChild:pauseMenu];
		gs.paused = NO;
		
		/*[CCMenuItemFont setFontSize:20];
		[CCMenuItemFont setFontName:@"Arial"];
		CCMenuItemFont *q = [CCMenuItemFont itemFromString:@"D" target:self selector:@selector(onQuit)];
		CCMenu *quit = [CCMenu menuWithItems:q,nil];
		quit.position =ccp(30,460);
		[quit setColor:ccBLACK];
		[self addChild: quit];*/
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) onQuit
{
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [TryAgain scene]]];
	//[[obstacleManager getChildByTag:1] danceAnim];
}
  
-(void) onPause 
{	
	[self removeChild:pauseMenu cleanup:YES];
	[[CCDirector sharedDirector] pause];
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	gs.paused = YES;
	bg = [CCSprite spriteWithFile:@"pause_BG.png"];
	bg.position = ccp(gs.size.width / 2, gs.size.height / 2);
	bg.flipY = YES;
	bg.opacity = 235;
	[self addChild:bg z:0];
	//Font Size
	[CCMenuItemFont setFontSize:35];
	[CCMenuItemFont	setFontName:@"Stencil Regular.ttf"];
	cont = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resumePlay)];
	[cont setColor: ccWHITE];
	back = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(mainMenu)];
	[back setColor: ccWHITE];
	menu = [CCMenu menuWithItems:back, cont, nil];
	[menu alignItemsHorizontallyWithPadding:30];
	menu.position = ccp(gs.size.width /2, 50);
	[bg addChild : menu];		
}

-(void) resumePlay
{
	[[CCDirector sharedDirector] resume];
	[cont setColor:ccGRAY];
	if (gs.musicOn)
		[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	[self removeChild:bg cleanup:YES];
	[self removeChild:menu cleanup:YES];
	CCMenuItem *pause = [CCMenuItemImage itemFromNormalImage:@"pause_button_small.png" selectedImage:@"pause_button_small.png" target:self selector:@selector(onPause)];
	pauseMenu = [CCMenu menuWithItems:pause, nil];
    [pauseMenu setOpacity:110];
	[pauseMenu alignItemsVertically];
	pauseMenu.position = ccp(300,460);
	[self addChild:pauseMenu];
	gs.paused = NO;
}

-(void)mainMenu {
	[skyscraper unscheduleAllSelectors];
	[obstacleManager unscheduleAllSelectors];
	[self unscheduleAllSelectors];
	[[CCDirector sharedDirector] resume];
	[back setColor:ccGRAY];
	gs.paused = NO;	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [Menu scene]]];
}

-(void) update: (ccTime) delta
{
	if (gs.paused) [self onPause];
	if (!gs.dead) {
		gs.score += delta * 20;
		gs.gameSpeed += (delta * kGameSpreedInc);
		NSString *scoreStr = [NSString stringWithFormat:@"%d",(int) gs.score];
		[scoreLabel2 setString:scoreStr];
		if (gs.parachuteChanged != 0) {
			if (gs.parachuteChanged == -1) {
				CCSprite *parachute = [parachutes objectAtIndex:gs.health];
				CCMoveBy *slideOut = [CCMoveBy actionWithDuration:.2 position:ccp(-40,0)];
				[parachute runAction:slideOut];
				gs.parachuteChanged = 0;
			}
			if (gs.parachuteChanged == 1) {
				CCSprite *parachute = [parachutes objectAtIndex:gs.health - 1];
				CCMoveBy *slideIn = [CCMoveBy actionWithDuration:.2 position:ccp(40,0)];
				[parachute runAction:slideIn];
				gs.parachuteChanged = 0;
			}
		}
		switch (gs.level) {
			case 1:
				if (gs.score > (kLevelChangeInc * (((1 - gs.startLevel) % 8) + 1))) {
					gs.level =2;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 2:
				if (gs.score > (kLevelChangeInc * (((2 - gs.startLevel) % 8) + 1))) {
					gs.level =3;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 3:
				if (gs.score > (kLevelChangeInc * (((3 - gs.startLevel) % 8) + 1))) {
					gs.level =4;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 4:
				if (gs.score > (kLevelChangeInc * (((4 - gs.startLevel) % 8) + 1))) {
					gs.level =5;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 5:
				if (gs.score > (kLevelChangeInc * (((5 - gs.startLevel) % 8) + 1))) {
					gs.level = 6;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 6:
				if (gs.score > (kLevelChangeInc * (((6 - gs.startLevel) % 8) + 1))) {
					gs.level = 7;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 7:
				if (gs.score > (kLevelChangeInc * (((7 - gs.startLevel) % 8) + 1))) {
					gs.level = 8;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			case 8:
				if (gs.score > (kLevelChangeInc * (((8 - gs.startLevel) % 8) + 1))) {
					gs.level = 9;
					[[CCDirector sharedDirector] replaceScene:
					 [CCTransitionFade transitionWithDuration:0.5 scene: [Congrats scene]]];
				}
				break;
			default:
				break;
		}
	}
	if (gs.level > gs.maxLevel) {
		gs.maxLevel = gs.level; 
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setInteger:gs.maxLevel forKey:@"levelKey"];
	}
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
	gs.accelX = acceleration.x;	
}

-(void) onEnterTransitionDidFinish
{
	self.isAccelerometerEnabled = YES;
	gs.isPlaying = YES;
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	gs.isPlaying = NO;
	self.isAccelerometerEnabled = NO;
	[super onExit];
}

-(void) dealloc
{
	[parachutes release];
	parachutes = nil;
	[super dealloc];
}

@end