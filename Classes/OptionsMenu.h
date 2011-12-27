//
//  OptionsMenu.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/20/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "SimpleAudioEngine.h"

@interface OptionsMenu : CCLayer 
{
	GameState* gs;
	CCMenuItemFont *music, *sound;
}

+(id) scene;

@end
