//
//  Congrats.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 1/30/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "Congrats.h"


@implementation Congrats

+(id) scene
{
	CCScene* scene = [CCScene node];
	Congrats* layer = [Congrats node];
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
		CCSprite *congrats = [CCSprite spriteWithFile:@"congrats.png"];
		congrats.position = ccp(gs.size.width/2 + 10, 375);
		[congrats runAction:[CCRotateBy actionWithDuration:0 angle:-3]];
		[self addChild:congrats];		
		NSString *text2 = @"You have reached";
		[self setWorldLabel];
		if (gs.level > gs.maxLevel) text2 = @"You have UNLOCKED";
		if (gs.level > 8) {
			text2 = [NSString stringWithFormat: @"YOU BEAT ALL OF"];
			text3 = [NSString stringWithFormat: @"THE DROP WORLDS"];
		}
		CCLabelTTF *label2 = [CCLabelTTF labelWithString: text2 fontName:@"Stencil Regular.ttf" fontSize: 30];
		[label2 setColor:ccYELLOW];
		[self addChild:label2];
		[label2 setPosition:ccp(gs.size.width / 2, gs.size.height /2 + 10)];
		CCLabelTTF *label3 = [CCLabelTTF labelWithString: text3 fontName:@"Stencil Regular.ttf" fontSize: 30];
		[label3 setColor:ccYELLOW];
		[self addChild:label3];
		[label3 setPosition:ccp(gs.size.width / 2, gs.size.height /2 - 20)];
		[CCMenuItemFont setFontSize:50];
		[CCMenuItemFont setFontName:@"Stencil Regular.ttf"];
		CCMenuItemFont  *start = [CCMenuItemFont itemFromString:@"Continue" target:self selector:@selector(loading:)];
		[start setColor: ccWHITE];
		start.position = ccp(gs.size.width / 2, gs.size.height /2  - 140);
		[start setTag:1];
		CCMenu *menu = [CCMenu menuWithItems:start, nil];
		menu.position = ccp(0, 0);
		[self addChild : menu z:1];
		CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button.png"
															  target: self selector:@selector(loading:)];
		[back setTag:2];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(30,450);
		[self addChild:backMenu z:1];		
		if (gs.musicOn) 
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menuLoop.caf" loop:YES];
	}
	return self;
}
-(void) setWorldLabel
{
	switch (gs.level) {
		case 2:
			text3 = [NSString stringWithString: @"Mojave"];
			break;
		case 3:
			text3 = [NSString stringWithString: @"Crevasse"];
			break;
		case 4:
			text3 = [NSString stringWithString: @"Factory"];
			break;
		case 5:
			text3 = [NSString stringWithString: @"Metropolis Dusk"];
			break;
		case 6:
			text3 = [NSString stringWithString: @"Mojave Dusk"];
			break;
		case 7:
			text3 = [NSString stringWithString: @"Crevasse Dusk"];
			break;
		case 8:
			text3 = [NSString stringWithString: @"Factory Dusk"];
			break;
		default:
			break;
	}
}

-(void) loading: (id) sender
{
	CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Stencil Regular.ttf" fontSize:20];
	loading.position = ccp(gs.size.width/2, gs.size.height / 2 - 55);
	[loading setColor:ccWHITE]; 
	[self addChild:loading];
	int button = [sender tag];
	switch (button) {
		case 1:
			[self schedule:@selector(startGame:) interval:0.01];
			break;
		case 2:
			[self schedule:@selector(mainMenu) interval:0.01];
			break;
		default:
			break;
	}
}


-(void)startGame: (id)sender {
	[self unschedule:@selector(startGame:)];
	int pLevel = 1 + ((gs.level - 1) % 4);
	NSString *level = [NSString stringWithFormat:@"Level%d.plist",pLevel];
	bool isNight = (gs.level > 4);
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: 
											   [LevelScene sceneWithName: level night:isNight]]];
	if (gs.level > 8) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
												   [Menu scene]]];

	}
}

-(void) mainMenu
{
	[self unschedule:@selector(mainMenu)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
											   [Menu scene]]];
}

-(void) dealloc
{
	[super dealloc];
}

@end
