//
//  Scores.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/23/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "SimpleAudioEngine.h"
#import "MenuScene.h"


@interface Scores : CCLayer 
{
	GameState* gs;
}

+(id) scene;

@end

