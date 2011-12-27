//
//  OptionsMenu.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/20/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "OptionsMenu.h"
#import	"LevelScene.h"
#import "MenuScene.h"
#import "About.h"
#import "Tutorial.h"

@implementation OptionsMenu

+(id) scene
{
	CCScene* scene = [CCScene node];
	OptionsMenu* layer = [OptionsMenu node];
	[scene addChild: layer z:0];
	return scene;
}

-(id) init
{
	
	if ((self = [super init]))
	{		
		gs = [GameState sharedState];
		CCSprite *bg=[CCSprite spriteWithFile:@"retry.jpg"];
		bg.position = ccp(gs.size.width /2, gs.size.height /2);
		[self addChild : bg z:-1];
		[CCMenuItemFont setFontSize:40];
		[CCMenuItemFont setFontName:@"Stencil Regular.ttf"];
		music = [CCMenuItemFont itemFromString:@"Music " target:self selector:@selector(musicOn)];
		if (gs.musicOn) [music setColor: ccWHITE];
			else [music setColor:ccGRAY];
		sound = [CCMenuItemFont itemFromString:@"Sound " target:self selector:@selector(soundOn)];
		if (gs.soundOn) [sound setColor: ccWHITE];
			else [sound setColor:ccGRAY];
		CCSprite *logo = [CCSprite spriteWithFile:@"logoMM.png"];
		logo.position = ccp(gs.size.width/2, 360);
		//[logo runAction:[CCRotateBy actionWithDuration:0 angle:-3]];
		[self addChild:logo];
		CCMenuItemFont  *about = [CCMenuItemFont itemFromString:@" About" target:self selector:@selector(loading:)];
		[about setColor: ccWHITE];
		[about setTag:2];
		CCMenuItemFont  *help = [CCMenuItemFont itemFromString:@" Help" target:self selector:@selector(loading:)];
		[help setColor: ccWHITE];
		[help setTag:3];
		CCMenu *menu = [CCMenu menuWithItems:music, sound, about, help, nil];
		NSNumber *columns = [NSNumber numberWithInt:2];
		[menu alignItemsInRows: columns, columns, nil];
		menu.position = ccp(gs.size.width/2, 85);
		[self addChild : menu z:1];
		CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button2P.png"
															  target: self selector:@selector(loading:)];
		[back setTag:1];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(25,455);
		[self addChild:backMenu z:1];
		
	}
	return self;
}

-(void) loading: (id) sender
{
	CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Stencil Regular.ttf" fontSize:20];
	loading.position = ccp(gs.size.width/2, gs.size.height / 2 - 15);
	[loading setColor:ccWHITE]; 
	[self addChild:loading];
	int button = [sender tag];
	switch (button) {
		case 1:
			[self schedule:@selector(changeToMenu) interval:0.01];
			break;
		case 2:
			[self schedule:@selector(changeToAbout) interval:0.01];
			break;
		case 3:
			[self schedule:@selector(changeToTutorial) interval:0.01];
			break;
		default:
			break;
	}
}

-(void) musicOn
{
		if (gs.musicOn) {
		gs.musicOn = NO;
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
		[music setColor: ccGRAY];
	}
	else {
		gs.musicOn = YES;
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menuLoop.caf" loop:YES];
		[music setColor: ccWHITE];
	}
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:gs.musicOn forKey:@"musicKey"];
}

-(void) soundOn
{
	if (gs.soundOn) {
		gs.soundOn = NO;
		[sound setColor: ccGRAY];
	}
	else {
		gs.soundOn = YES;
		[sound setColor: ccWHITE];
	}
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:gs.soundOn forKey:@"soundKey"];
}

-(void) changeToMenu
{
	[self unschedule:@selector(changeToMenu)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
											   [Menu scene]]];
}

-(void) changeToTutorial
{
	[self unschedule:@selector(changeToTutorial)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene: 
											   [Tutorial scene]]];	
}

-(void) changeToAbout
{
	[self unschedule:@selector(changeToAbout)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene: 
											   [About scene]]];
}
-(void) dealloc
{
	[super dealloc];
}

@end
