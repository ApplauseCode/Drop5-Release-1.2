//
//  Congrats.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 1/30/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "LevelScene.h"
#import "MenuScene.h"

@interface Congrats : CCLayer 
{
	GameState* gs;
	NSString *text3;
}

+(id) scene;
-(void) setWorldLabel;

@end
