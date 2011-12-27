//
//  About.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/3/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "About.h"
#import "OptionsMenu.h"


@implementation About

+(id) scene
{
	CCScene* scene = [CCScene node];
	About* layer = [About node];
	[scene addChild: layer z:0];
	return scene;
}

-(id) init
{
	
	if ((self = [super init]))
	{
		gs = [GameState sharedState];
		CCSprite *bg = [CCSprite spriteWithFile:@"daylightBG_2000_bot.jpg"];
		bg.position = ccp(gs.size.width / 2,gs.size.height / 2);
		bg.opacity = 150;
		CCMoveBy *moveBG = [CCMoveBy actionWithDuration:40 position:ccp(0, 525)];
		CCEaseIn  *rampBG = [CCEaseIn actionWithAction: moveBG rate: 1.5];
		[bg runAction:rampBG];
		[self addChild: bg];
		CCSprite *credits = [CCSprite spriteWithFile:@"credits_text.png"];
		credits.position = ccp(gs.size.width / 2, -20);
		CCMoveBy *move = [CCMoveBy actionWithDuration:20 position:ccp(0,525)];
		CCEaseIn  *ramp = [CCEaseIn actionWithAction: move rate: 1.5];
		CCDelayTime *delay = [CCDelayTime actionWithDuration:2];
		CCCallFunc *menu = [CCCallFunc actionWithTarget:self selector:@selector(mainMenu)];
		CCSequence *seq = [CCSequence actions:ramp,delay,menu,nil];
		[credits runAction: seq];
		[self addChild:credits];
		CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_buttonP2.png"
															  target: self selector:@selector(mainMenu)];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(25,455);
		[self addChild:backMenu z:1];		
	}
	return self;
}

-(void) mainMenu
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
											   [OptionsMenu scene]]];
}

-(void) dealloc
{
	[super dealloc];
}

@end
