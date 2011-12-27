//
//  Tutorial.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/21/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "Tutorial.h"
#import "OptionsMenu.h"

@implementation Tutorial

+(id) scene
{
	CCScene* scene = [CCScene node];
	Tutorial* layer = [Tutorial node];
	[scene addChild: layer z:0];
	return scene;
}

-(id) init
{
	
	if ((self = [super init]))
	{		
		gs = [GameState sharedState];
		screenNumber = 1;
		CCSprite *bg=[CCSprite spriteWithFile:@"blueBG.jpg"];
		bg.position = ccp(gs.size.width /2, gs.size.height /2);
		bg.opacity = 175;
		[self addChild : bg z:-1];
		CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button2P.png"
															   target: self selector:@selector(mainMenu)];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(30,450);
		[self addChild:backMenu z:1];
		[self showScreen1];
		
		prev = [CCMenuItemImage itemFromNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(changeScreen:)];
		[prev setColor:ccWHITE];
		[prev setTag:0];
		[prev setIsEnabled:NO];
		prev.visible = NO;
		next = [CCMenuItemImage itemFromNormalImage:@"forward.png" selectedImage:@"forward.png" target:self selector:@selector(changeScreen:)];
		[next setColor:ccWHITE];
		[next setTag:1];
		
		CCMenu *menu = [CCMenu menuWithItems:prev, next, nil];
		[menu alignItemsHorizontallyWithPadding:20];
		menu.position = ccp(gs.size.width /2, 25);
		[self addChild : menu z:1];
		
	}
	return self;
}

-(void) changeScreen: (id) sender
{
	switch (screenNumber) {
		case 1:
			[self removeChild:screen1 cleanup:YES];
			break;
		case 2:
			[self removeChild:screen2 cleanup:YES];
			break;
		case 3:
			[self removeChild:screen3 cleanup:YES];
			break;
		default:
			break;
	}
	if ([sender tag] == 1) 
	{
		screenNumber ++;
	}
	else 
	{
		screenNumber --;
	}
	switch (screenNumber) {
		case 1:
			[self showScreen1];
			break;
		case 2:
			[self showScreen2];
			break;
		case 3:
			[self showScreen3];
			break;
		default:
			break;
	}

}
	
-(void) showScreen1
{
	screen1 = [CCLayer node];
	[self addChild:screen1];
	NSString *str = [NSString stringWithFormat:@"   You are trying to set the record for longest fall " 
					 @"by a skydiver. You must stay clear of all obstacles in your way. "
					 @"Tilt your IOS device left and right to help avoid damaging your parachute. "
					 @"If you crash into 3 obstacles your parachute is damaged beyond repair and you fall to the ground."];
	CCLabelTTF *text = [CCLabelTTF  labelWithString:str 
										 dimensions:CGSizeMake(260,270)
										  alignment:UITextAlignmentLeft
										   fontName:@"Helvetica" 
										   fontSize:18];
	text.color = ccYELLOW;
	text.position = ccp(gs.size.width/2 ,280);
	[screen1 addChild:text];
	CCSprite *man1 = [CCSprite spriteWithSpriteFrameName: @"mc_01.png"];
	man1.position = ccp (gs.size.width / 2 - 80, 105);
	[screen1 addChild:man1];
	CCSprite *man2 = [CCSprite spriteWithSpriteFrameName: @"mc_02.png"];
	man2.position = ccp (gs.size.width / 2, 105);
	[screen1 addChild:man2];
	CCSprite *man3 = [CCSprite spriteWithSpriteFrameName: @"mc_03.png"];
	man3.position = ccp (gs.size.width / 2 + 80, 105);
	[screen1 addChild:man3];
	[prev setIsEnabled: NO];
	[next setIsEnabled: YES];
	prev.visible = NO;
	next.visible = YES;
}

-(void) showScreen2
{
	screen2 = [CCLayer node];
	[self addChild:screen2];
	NSString *str = [NSString stringWithFormat:@"   There are 4 unique worlds each with a day and night version. " 
					 @"Reach the end of each world to unlock the next, "
					 @"by falling 2000 feet. "
					 @"\r\r   Avoid obstacles like this: "];
	CCLabelTTF *text = [CCLabelTTF  labelWithString:str 
										 dimensions:CGSizeMake(250,270)
										  alignment:UITextAlignmentLeft
										   fontName:@"Helvetica" 
										   fontSize:18];
	text.color = ccYELLOW;
	text.position = ccp(gs.size.width/2 ,290);
	[screen2 addChild:text];
	CCSprite *obs1 = [CCSprite spriteWithSpriteFrameName: @"flagpole_100.png"];
	obs1.flipX = YES;
	obs1.position = ccp (50, 240);
	[screen2 addChild:obs1];
	CCSprite *obs2 = [CCSprite spriteWithSpriteFrameName: @"metalpole_180.png"];
	obs2.flipX = YES;
	obs2.position = ccp (235, 230);
	[screen2 addChild:obs2];
	CCSprite *obs3 = [CCSprite spriteWithSpriteFrameName: @"clothesline_280.png"];
	obs3.position = ccp (gs.size.width/2, 70);
	[screen2 addChild:obs3];
	CCSprite *obs4 = [CCSprite spriteWithSpriteFrameName: @"balloon.png"];
	obs4.position = ccp (gs.size.width/2, 165);
	[screen2 addChild:obs4];
	[prev setIsEnabled: YES];
	[next setIsEnabled: YES];
	prev.visible = YES;
	next.visible = YES;
}

-(void) showScreen3
{
	screen3 = [CCLayer node];
	[self addChild:screen3];
	NSString *str = [NSString stringWithFormat:@"  You can also pick up powerups which will award you special powers. " 
					 @"Powerups are always spinning. "
					 @"\n\r\rDisco Fever:"];
	CCLabelTTF *text = [CCLabelTTF  labelWithString:str 
										 dimensions:CGSizeMake(250,270)
										  alignment:UITextAlignmentLeft
										   fontName:@"Helvetica" 
										   fontSize:18];
	text.color = ccYELLOW;
	text.position = ccp(gs.size.width/2 ,280);
	[screen3 addChild:text];
	CCLabelTTF *textJH = [CCLabelTTF  labelWithString:[NSString stringWithFormat:@"Jack Hammer:"] 
							 dimensions:CGSizeMake(250,30)
							  alignment:UITextAlignmentLeft
							   fontName:@"Helvetica" 
							   fontSize:18];
	textJH.color = ccYELLOW;
	textJH.position = ccp(gs.size.width/2 ,175);
	[screen3 addChild:textJH];
	CCLabelTTF *textRP = [CCLabelTTF  labelWithString:[NSString stringWithFormat:@"Free Parachute:"] 
										   dimensions:CGSizeMake(250,30)
											alignment:UITextAlignmentLeft
											 fontName:@"Helvetica" 
											 fontSize:18];
	textRP.color = ccYELLOW;
	textRP.position = ccp(gs.size.width/2 ,85);
	[screen3 addChild:textRP];
	CCSprite *pu1 = [CCSprite spriteWithSpriteFrameName: @"icon_disco.png"];
	pu1.position = ccp (gs.size.width / 2+60, 270);
	CCOrbitCamera *orbit1;
	orbit1 = [CCOrbitCamera actionWithDuration:2 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:360 angleX:0 deltaAngleX:0];
	[pu1 runAction:[CCRepeatForever actionWithAction:orbit1]];
	[screen3 addChild:pu1];
	CCSprite *pu2 = [CCSprite spriteWithSpriteFrameName: @"icon_jackhammer.png"];
	pu2.position = ccp (gs.size.width / 2+60, 175);
	CCOrbitCamera *orbit2;
	orbit2 = [CCOrbitCamera actionWithDuration:2 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:360 angleX:0 deltaAngleX:0];
	[pu2 runAction:[CCRepeatForever actionWithAction:orbit2]];
	[screen3 addChild:pu2];
	CCSprite *pu3 = [CCSprite spriteWithSpriteFrameName: @"icon_lives.png"];
	pu3.position = ccp (gs.size.width / 2+60, 85);
	CCOrbitCamera *orbit3;
	orbit3 = [CCOrbitCamera actionWithDuration:2 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:360 angleX:0 deltaAngleX:0];
	[pu3 runAction:[CCRepeatForever actionWithAction:orbit3]];
	[screen3 addChild:pu3];
	[prev setIsEnabled: YES];
	[next setIsEnabled: NO];
	next.visible = NO;
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
