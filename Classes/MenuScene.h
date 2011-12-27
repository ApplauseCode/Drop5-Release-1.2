//
//  MenuScene.h
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "GameKitHelper.h"
#import "SimpleAudioEngine.h"

@interface Menu : CCLayer <GameKitHelperProtocol>
{
	GameState *gs;
	float posX, posY;
	CCMenuItemImage *parachute;
	CCMenu *paraMenu;
	bool leaving;
}

+(id) scene;

@end