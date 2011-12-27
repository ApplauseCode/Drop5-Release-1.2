//
//  MenuScene.m
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "LevelScene.h"
#import "Level_Menu.h"
#import "About.h"
#import "Scores.h"
#import "OptionsMenu.h"

#define accel_filter 0.1f


@implementation Menu

+(id) scene
{
	CCScene* scene = [CCScene node];
	Menu* layer = [Menu node];
	[scene addChild: layer z:0];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		gs = [GameState sharedState];
		leaving = NO;
		posX = 0.0f;
		posY = 0.0f;
		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		// Note: if you change scenes, make sure to set the delegate back to nil, otherwise the delegate
		// won't be released from memory, essentially leaking it.
		gkHelper.delegate = self;
		[gkHelper authenticateLocalPlayer];
		
		
		if (gs.musicOn && ![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menuLoop.caf" loop:YES];
		parachute = [CCMenuItemImage itemFromNormalImage:@"logoMM.png" selectedImage:@"logoMM.png" target:self selector:@selector(leave)];
		paraMenu = [CCMenu menuWithItems:parachute, nil];
		[paraMenu setPosition:ccp(gs.size.width/2, 360)];
		[self addChild:paraMenu];
		
		CCSprite *bg=[CCSprite spriteWithFile:@"BGMM.png"];
		bg.position = ccp(gs.size.width /2, gs.size.height /2);
		[self addChild : bg z:-1];
		
		CCMenuItemImage  *start = [CCMenuItemImage itemFromNormalImage:@"startMM.png" selectedImage:@"startMMP.png" target:self selector:@selector(startGame:)];
		[start setPosition:ccp(gs.size.width/4, 167)];
		CCMenuItemImage  *levels = [CCMenuItemImage itemFromNormalImage:@"worldMM.png" selectedImage:@"worldMMP.png" target:self selector:@selector(chooseLevel:)];
		[levels setPosition:ccp(gs.size.width/4 - 3, 123)];
		CCMenuItemImage  *options = [CCMenuItemImage itemFromNormalImage:@"optionsMM.png" selectedImage:@"optionsMMP.png" target:self selector:@selector(options:)];
		[options setPosition:ccp(gs.size.width/4 * 3 - 5, 123)];
		CCMenuItemImage  *highscores = [CCMenuItemImage itemFromNormalImage:@"scoresMM.png" selectedImage:@"scoresMMP.png" target:self selector:@selector(scores)];
		[highscores setPosition:ccp(gs.size.width/4 * 3 - 5, 167)];
		CCMenuItemImage  *fb = [CCMenuItemImage itemFromNormalImage:@"fbMM.png" selectedImage:@"fbMMP.png" target:self selector:@selector(toFacebook:)];
		[fb setPosition:ccp(245, 35)];
		CCMenuItemImage  *tw = [CCMenuItemImage itemFromNormalImage:@"twMM.png" selectedImage:@"twMMP.png" target:self selector:@selector(toTwitter:)];
		[tw setPosition:ccp(285, 35)];
		CCMenuItemImage  *gc = [CCMenuItemImage itemFromNormalImage:@"gamecenter_icon.png" selectedImage:@"gamecenter_iconP.png" target:self selector:@selector(highScores:)];
		[gc setPosition:ccp(285, 80)];
		CCMenu *menu;
		if (gkHelper.isGameCenterAvailable) {
			menu = [CCMenu menuWithItems:start, levels, highscores, options, fb, tw, gc, nil];
		}
		else {
			menu = [CCMenu menuWithItems:start, levels, highscores, options, fb, tw, nil];
		}
		[menu setPosition:ccp (0,0)];
		[self addChild : menu z:1];
		
		

	}
	return self;
}

-(void) leave
{
	if (! leaving)
	{
		leaving = YES;
		id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveDidFinish)];
		CCScaleTo *actScale = [CCScaleTo actionWithDuration:2 scale:.2];
		CCMoveTo *actMove = [CCMoveTo actionWithDuration:2 position:ccp(gs.size.width/2 +100, 435)];
		CCEaseIn *scaleOut1 = [CCEaseIn actionWithAction:actScale rate:3];
		CCEaseIn *moveOut1 = [CCEaseIn actionWithAction:actMove rate:3];
		CCScaleTo *actScale2 = [CCScaleTo actionWithDuration:2 scale:1];
		CCMoveTo *actMove2 = [CCMoveTo actionWithDuration:2 position:ccp(gs.size.width/2, 360)];
		CCEaseOut *scaleOut2 = [CCEaseOut actionWithAction:actScale2 rate:3];
		CCEaseOut *moveOut2 = [CCEaseOut actionWithAction:actMove2 rate:3];
		CCSequence *sOut = [CCSequence actions:scaleOut1, scaleOut2, nil];
		CCSequence *sIn = [CCSequence actions:moveOut1, moveOut2, actionCallFunc, nil];
		[paraMenu runAction:sOut];
		[paraMenu runAction:sIn];
		CCRotateBy *rt = [CCRotateBy actionWithDuration:.5 angle:7];
		CCRotateBy *lf = [CCRotateBy actionWithDuration:.5 angle:-7];
		CCSequence *rot = [CCSequence actions: rt, lf, lf, rt, nil];
		CCRepeat *rr = [CCRepeat actionWithAction:rot times:2];
		[paraMenu runAction:rr];
	}
}

-(void) leaveDidFinish
{
	leaving = NO;
}

-(void) onEnterTransitionDidFinish
{
	self.isAccelerometerEnabled = YES;
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	self.isAccelerometerEnabled = NO;
	[super onExit];
}

#pragma mark GameKitHelper delegate methods
-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		[gkHelper getLocalPlayerFriends];
	}
}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", [friends description]);
	
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper getPlayerInfo:friends];
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", [players description]);
	
	for (GKPlayer* gkPlayer in players)
	{
		CCLOG(@"PlayerID: %@, Alias: %@, isFriend: %i", gkPlayer.playerID, gkPlayer.alias, gkPlayer.isFriend);
	}
}

-(void)chooseLevel: (id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene: [Level_Menu scene]]];
}

-(void)startGame: (id)sender {
	gs.health = 3;
	gs.parachuteChanged = 0;
	gs.score = 0;
	gs.accelX = 0.0;
	gs.level = 1;
	gs.startLevel = 1;
	gs.dead = NO;
	CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Stencil Regular.ttf" fontSize:20];
	loading.position = ccp(gs.size.width/2, 75);
	[loading setColor:ccBLACK]; 
	[self addChild:loading];
	[self schedule:@selector(change) interval:0.01];
}

-(void) change
{
	[self unschedule:@selector(change)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: 
		[LevelScene sceneWithName: @"Level1.plist" night:NO]]];
}

-(void) scores
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene: 
											   [Scores scene]]];
}


-(void) highScores: (id)sender {
	GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper showLeaderboard];
}

-(void) toFacebook: (id) sender {
	      
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Applause-Code/146720288720113?v=wall"]];
}

-(void) toTwitter: (id) sender {
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/#!/ApplauseCode"]];
}

-(void) options: (id) sender 
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene: [OptionsMenu scene]]];
}

-(void) onScoresSubmitted:(bool)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}

-(void) onScoresReceived:(NSArray*)scores
{
	CCLOG(@"onScoresReceived: %@", [scores description]);
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper showAchievements];
}

-(void) onAchievementReported:(GKAchievement*)achievement
{
	CCLOG(@"onAchievementReported: %@", achievement);
}

-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
	CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
}

-(void) onResetAchievements:(bool)success
{
	CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}

-(void) onLeaderboardViewDismissed
{
	CCLOG(@"onLeaderboardViewDismissed");
	
	//GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	//[gkHelper retrieveTopTenAllTimeGlobalScores];
}

-(void) onAchievementsViewDismissed
{
	CCLOG(@"onAchievementsViewDismissed");
}

-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
	CCLOG(@"receivedMatchmakingActivity: %i", activity);
}

-(void) onMatchFound:(GKMatch*)match
{
	CCLOG(@"onMatchFound: %@", match);
}

-(void) onPlayersAddedToMatch:(bool)success
{
	CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}

-(void) onMatchmakingViewDismissed
{
	CCLOG(@"onMatchmakingViewDismissed");
}
-(void) onMatchmakingViewError
{
	CCLOG(@"onMatchmakingViewError");
}

-(void) onPlayerConnected:(NSString*)playerID
{
	CCLOG(@"onPlayerConnected: %@", playerID);
}

-(void) onPlayerDisconnected:(NSString*)playerID
{
	CCLOG(@"onPlayerDisconnected: %@", playerID);
}

-(void) onStartMatch
{
	CCLOG(@"onStartMatch");
}

-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
	CCLOG(@"onReceivedData: %@ fromPlayer: %@", data, playerID);
}

-(void) dealloc
{
	[super dealloc];
}

@end
