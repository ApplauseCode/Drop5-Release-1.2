//
//  Scores.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/23/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "Scores.h"


@implementation Scores

+(id) scene
{
	CCScene* scene = [CCScene node];
	Scores* layer = [Scores node];
	[scene addChild: layer z:0];
	return scene;
}

-(id) init
{
	
	if ((self = [super init]))
	{		
		gs = [GameState sharedState];
		CCSprite *bg=[CCSprite spriteWithFile:@"blueBG.jpg"];
		bg.position = ccp(gs.size.width /2, gs.size.height /2);
		bg.opacity = 200;
		[self addChild : bg z:-1];
		CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button2P.png"
			target: self selector:@selector(mainMenu:)];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(25,455);
		[self addChild:backMenu z:1];
		CCSprite *hsBanner = [CCSprite spriteWithFile:@"high_scores.png"];
		hsBanner.position=ccp(gs.size.width / 2, 400);
		[self addChild:hsBanner];
		hsBanner.scale = 1.3;
		int i,n;
		n = [gs.highScores count];
		NSDictionary *tempScore;
		NSString *tempString;
		for (i=0; i<n; i++) {
			tempString = [NSString stringWithFormat:@"%i.",i+1];
			CCLabelTTF *num = [CCLabelTTF labelWithString:tempString dimensions:CGSizeMake(30, 27) alignment:CCTextAlignmentRight fontName:@"Arial Rounded MT Bold" fontSize:18]; 
			num.anchorPoint = ccp(0,0);
			num.color = ccYELLOW;
			num.position = ccp(20,300-i*27);
			[self addChild: num];
			tempScore = [gs.highScores objectAtIndex:i];
			tempString = [NSString stringWithFormat:@"%@", [tempScore objectForKey:@"name"]];
			CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:tempString dimensions:CGSizeMake(220, 27) alignment:CCTextAlignmentLeft fontName:@"Arial Rounded MT Bold" fontSize:18]; 
			nameLabel.anchorPoint = ccp(0,0);
			nameLabel.color = ccYELLOW;
			nameLabel.position = ccp(55,300-i*27);
			[self addChild: nameLabel];
			int scoreValue = [[tempScore objectForKey:@"gameScore"] intValue];
			if (scoreValue)
				tempString = [NSString stringWithFormat:@"%i", scoreValue];
			else tempString = @"";
			CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:tempString dimensions:CGSizeMake(100, 27) alignment:CCTextAlignmentRight fontName:@"Arial Rounded MT Bold" fontSize:18]; 
			scoreLabel.anchorPoint = ccp(0,0);
			scoreLabel.color = ccYELLOW;
			scoreLabel.position = ccp(205,300-i*27);
			[self addChild: scoreLabel];
		}
	}
	return self;
}

-(void) mainMenu: (id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
											   [Menu scene]]];
}

-(void) dealloc
{

	[super dealloc];
}

@end


