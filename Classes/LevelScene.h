//
//  LevelScene.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 Applause. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "Skyscraper.h"
#import "Obstacle.h"
#import "LongObstacle.h"
#import "PowerUp.h"
#import "ObstacleManager.h"
#import "Level_Menu.h"
#import "Congrats.h"
#import "MenuScene.h"
#import "SimpleAudioEngine.h"
#import "TryAgain.h"

@interface LevelScene : CCLayer 
{
	GameState* gs;
	CCSprite *bg;
	Skyscraper* skyscraper;
	ObstacleManager* obstacleManager;
	CCSprite *background, *backgroundTop, *backgroundBot;
	CCArray *parachutes;
	CCLabelBMFont *scoreLabel1;
	CCLabelBMFont *scoreLabel2;
	CCMenuItemFont *cont, *back;
	CCMenu *menu;
	CCMenu *pauseMenu;
}

+(id) sceneWithName: (NSString *) name night: (bool) _night;
-(id) initWithName: (NSString *) name night: (bool) _night;
-(void) onPause;
-(void) resumePlay;

@end

