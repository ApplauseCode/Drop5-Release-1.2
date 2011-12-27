//
//  Level_Menu.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 1/22/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "LevelScene.h"

@interface Level_Menu : CCLayer {
	GameState *gs;
	CCSprite *oldBG, *newBG;
	int levelIs;
	CCMenuItemFont *play;
	CCMenuItemImage *next, *prev;
	CCLabelTTF* levelLabel;
	CCLabelTTF *locked1, *locked2;;
}

+(id) scene;

@end
