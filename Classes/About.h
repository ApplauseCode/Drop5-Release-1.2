//
//  About.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/3/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@interface About : CCLayer {
	GameState *gs;
}

+(id) scene;

@end
