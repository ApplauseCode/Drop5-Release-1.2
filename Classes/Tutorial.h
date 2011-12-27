//
//  Tutorial.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/21/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "SimpleAudioEngine.h"

@interface Tutorial : CCLayer 
{
	GameState *gs;
	CCMenuItemImage *prev, *next;
	CCLayer *screen1, *screen2, *screen3;
	int screenNumber;
}

+(id) scene;
-(void) showScreen1;
-(void) showScreen2;
-(void) showScreen3;
-(void) changeScreen: (id) sender;

@end
