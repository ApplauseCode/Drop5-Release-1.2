//
//  ObstacleManager.h
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuScene.h"
#import "Obstacle.h"
#import "PowerUp.h"
#import "Man.h"
#import "GameState.h"

#define kNumberOfThings 10

@interface ObstacleManager : CCNode 
{
	GameState* gs;
	Man* fallingMan;
	CCArray* things;
	float obstacleTargetDistance, powerupTargetDistance;
	int numberOfSmallObstacles, numberOfLargeObstacles, numberOfPowerUps;
}

@property (assign, nonatomic) int numberOfSmallObstacles, numberOfLargeObstacles, numberOfPowerUps;

-(void) addThing:(GameObject *)thing;

@end
