//
//  Level_Menu.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 1/22/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "Level_Menu.h"


@implementation Level_Menu

+(id) scene
{
	CCScene *scene = [CCScene node];
	Level_Menu *layer = [Level_Menu node];
	[scene addChild:layer z:0];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		gs = [GameState sharedState];
		levelIs = 1;
		levelLabel = [CCLabelTTF labelWithString:@"Metropolis" fontName:@"Stencil Regular.ttf" fontSize:35];
		[levelLabel setColor: ccYELLOW];
        [self addChild:levelLabel z:1];
        levelLabel.position = ccp(gs.size.width / 2,425);
		
		oldBG=[CCSprite spriteWithFile:@"level_preview_1_window.jpg"];
		oldBG.position = ccp(gs.size.width /2, gs.size.height / 2);
		[oldBG setScale:.8f];
		[self addChild : oldBG z:0];
		[CCMenuItemFont setFontName:@"Stencil Regular.ttf"];
		
		prev = [CCMenuItemImage itemFromNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(prevLevel:)];
		[prev setColor:ccWHITE];
		[prev setTag:0];
				
		[CCMenuItemFont setFontSize:35];
		play = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(playGame:)];
		[play setColor:ccWHITE];
		
		next = [CCMenuItemImage itemFromNormalImage:@"forward.png" selectedImage:@"forward.png" target:self selector:@selector(prevLevel:)];
		[next setColor:ccWHITE];
		[next setTag:1];
				
		CCMenu *menu = [CCMenu menuWithItems:prev , play, next, nil];
		[menu alignItemsHorizontallyWithPadding:20];
		menu.position = ccp(gs.size.width /2, 55);
		[self addChild : menu z:1];
		
		CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button2P.png"
															  target: self selector:@selector(mainMenu)];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(25,455);
		[self addChild:backMenu z:1];
		
		locked1 = [CCLabelTTF labelWithString:@"To UNLOCK reach the" fontName:@"Arial Rounded MT Bold" fontSize:16];
		locked1.color = ccRED;
		locked1.position = ccp(gs.size.width / 2, gs.size.height / 2 + 10);
		locked2 = [CCLabelTTF labelWithString:@"end of the previous world." fontName:@"Arial Rounded MT Bold" fontSize:16];
		locked2.color = ccRED;
		locked2.position = ccp(gs.size.width / 2, gs.size.height / 2 - 12);
		locked1.visible = NO;
		locked2.visible = NO;
		[self addChild:locked1 z:2];
		[self addChild:locked2 z:2];
		
	}
	return self;
}

-(void) prevLevel: (id) sender
{
	if ([sender tag] == 1) {
		levelIs = (levelIs + 2);
		if (levelIs == 9) levelIs = 1;
		if (levelIs == 10) levelIs = 2;
	}
	[self removeChild:levelLabel cleanup:YES];
	switch (levelIs) {
		case 3:
			newBG = [CCSprite spriteWithFile:@"level_preview_2_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Mojave" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
		case 4:
			newBG = [CCSprite spriteWithFile:@"level_preview_3_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Crevasse" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
		case 5:
			newBG = [CCSprite spriteWithFile:@"level_preview_4_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Factory" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
		case 6:
			newBG = [CCSprite spriteWithFile:@"level_preview_5_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Metropolis Dusk" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
		case 7:
			newBG = [CCSprite spriteWithFile:@"level_preview_6_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Mojave Dusk" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
		case 8:
			newBG = [CCSprite spriteWithFile:@"level_preview_7_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Crevasse Dusk" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;	
		case 1:
			newBG = [CCSprite spriteWithFile:@"level_preview_8_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Factory Dusk" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
		case 2:
			newBG = [CCSprite spriteWithFile:@"level_preview_1_window.jpg"];
			newBG.position = ccp(gs.size.width /2, gs.size.height / 2);
			[newBG setScale:.8f];
			levelLabel = [CCLabelTTF labelWithString:@"Metropolis" fontName:@"Stencil Regular.ttf" fontSize: 35];
			break;
	}
	[self addChild:levelLabel z:0];
	[levelLabel setColor: ccYELLOW];
	levelLabel.position = ccp(gs.size.width / 2,425);
	[self addChild:newBG z:-1];
	id switchLevel = [CCFadeOut actionWithDuration:1.0];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(removeBG)];
	[oldBG runAction:[CCSequence actions: switchLevel, actionCallFunc, nil]];
	levelIs--;
	if (levelIs == 0) levelIs = 8;
	
	if (levelIs <= gs.maxLevel) {
		[play setIsEnabled:YES];
		[newBG setColor:ccWHITE];
		locked1.visible = NO;
		locked2.visible = NO;
	}
	else {
		[play setIsEnabled:NO];
		[newBG setColor:ccGRAY];
		locked1.visible = YES;
		locked2.visible = YES;
	}
	
}


-(void) removeBG
{
	[self removeChild:oldBG cleanup:YES];
	oldBG = newBG;
	[self reorderChild: oldBG z:0];
	[self reorderChild: levelLabel z:1];
	[prev setIsEnabled:YES];
	[next setIsEnabled:YES];
}

-(void)playGame: (id)sender 
{
	gs.health = 3;
	gs.parachuteChanged = 0;
	gs.score = 0;
	gs.accelX = 0.0;
	gs.level = levelIs;
	gs.startLevel = levelIs;
	gs.dead = NO;
	CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Stencil Regular.ttf" fontSize:22];
	loading.position = ccp(gs.size.width/2, gs.size.height/2);
	[loading setColor:ccBLACK]; 
	[self addChild:loading];
	[self schedule:@selector(change) interval:0.01];

}

-(void) change
{
	[self unschedule:@selector(change)];
	int pLevel = 1 + ((levelIs - 1) % 4);
	NSString* level = [NSString stringWithFormat:@"Level%d.plist",pLevel];
	bool isNight = (levelIs > 4);	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene: 
											   [LevelScene sceneWithName: level night:isNight]]];
}

-(void) mainMenu
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
											   [Menu scene]]];
}

-(void) dealloc
{
	[super dealloc];
}
		
@end
