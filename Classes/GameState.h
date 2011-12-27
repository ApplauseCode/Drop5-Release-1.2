//
//  GameState.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameState : CCNode {
	float gameSpeed;
	float accelX;
	int health, level;
	int startLevel;
	float score;
	bool horizontalMovement, dead, paused, isPlaying;
	bool musicOn, soundOn;
	
	// 0 = unchanged, -1, +1
	int parachuteChanged;
	float skyscraperOffset; 	
	CGSize size;
	int maxLevel;
	NSString *name;
	NSMutableArray *highScores;

#if USE_BATCH_NODE
	CCSpriteBatchNode *sheet;
#endif

}

@property (assign, nonatomic) float gameSpeed;
@property (assign, nonatomic) float accelX;
@property (assign, nonatomic) int health;
@property (assign, nonatomic) int level, startLevel, maxLevel;
@property (assign, nonatomic) float score;
@property (assign, nonatomic) bool horizontalMovement,dead, paused, isPlaying;
@property (assign, nonatomic) bool musicOn, soundOn;
@property (assign, nonatomic) float skyscraperOffset;
@property (assign, nonatomic) CGSize size;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSMutableArray *highScores;
@property (assign, nonatomic) int parachuteChanged;

#if USE_BATCH_NODE
@property (retain, nonatomic) CCSpriteBatchNode *sheet;
#endif

+(GameState *) sharedState;

@end