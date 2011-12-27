//
//  Skyscraper.h
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@interface Skyscraper : CCNode 
{
	CCSprite *skyscrapers;
	float skyPosX;
	GameState *gs;
}

+(id) skyscraperWithPng:(NSString *)png;
-(id) initWithPng: (NSString *)png;
-(void) setOpacity: (int) opacity;
@end
