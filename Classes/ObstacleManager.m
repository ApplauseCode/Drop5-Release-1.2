//
//  ObstacleManager.m
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ObstacleManager.h"


@implementation ObstacleManager
@synthesize numberOfSmallObstacles, numberOfLargeObstacles, numberOfPowerUps;


-(id) init {
	if ((self = [super init])) {
		gs = [GameState sharedState];
		obstacleTargetDistance = 500;
		powerupTargetDistance = 4000;
		fallingMan = [Man fallingManWithName:@"mc_01.png"];		
		[self addChild: fallingMan z:3 tag:1];
		things = [[CCArray alloc] initWithCapacity: kNumberOfThings];
		[self scheduleUpdate];
	}
	return self;
}

-(void) addThing: (GameObject *) thing {
	[things addObject:thing];
	[self addChild:thing];

}

-(void) spawnPowerUp {
	int spawn = arc4random() % 4;
	int puIndex = numberOfLargeObstacles + numberOfSmallObstacles + 1;
	PowerUp *pu;
	if (spawn == 0) {
		pu =[things objectAtIndex:puIndex];
		pu.active = YES;
		pu.visible = YES;
	}
	if (spawn == 1 && gs.health < 6) {
		pu = [things objectAtIndex:(puIndex + 1)];
		pu.active = YES;
		pu.visible = YES;
	}
	if (spawn == 2) {
		pu = [things objectAtIndex:(puIndex + 2)];
		pu.active = YES;
		pu.visible = YES;
	}
	
}

-(void) spawnObstacle {
	int obstacleType = arc4random() % 4;
	int choice, secondChoice;
	Obstacle* obs;
	switch (obstacleType) {
		case 0:
			choice = arc4random() % (numberOfLargeObstacles + 2);
			if (choice < numberOfLargeObstacles) {
				obs = [things objectAtIndex: (choice + numberOfSmallObstacles)];
				obs.active = YES;
			}
			else {
				obs = [things objectAtIndex:numberOfLargeObstacles + numberOfSmallObstacles];
				obs.active = YES;
			}
			break;
		case 1:
			choice = arc4random() % numberOfSmallObstacles / 2;
			secondChoice = arc4random() % (numberOfSmallObstacles / 2) + numberOfSmallObstacles / 2;
			obs = [things objectAtIndex: choice];
			obs.active = YES;
			obs = [things objectAtIndex: secondChoice];
			obs.active = YES;
			break;
		default:
			choice = arc4random() % numberOfSmallObstacles;
			obs = [things objectAtIndex: choice];
			obs.active = YES;
			break;
	}
}

-(void) collisionDetector {
	id thing;
	int i;
	bool manActing = (fallingMan.crashing || fallingMan.dancing || fallingMan.hammering || fallingMan.glowing);
	for (i = 0; i < numberOfLargeObstacles + numberOfSmallObstacles + 1; i++) {
		thing = [things objectAtIndex:i];
		if ([thing active] && !manActing && [thing objectHitRect:fallingMan.manRect]) {
			gs.health--;
			gs.parachuteChanged = -1;
			[fallingMan ripParachute];
			[fallingMan bounce];
			[fallingMan crashAnim];	
		}
		if ([thing active] && fallingMan.hammering && ![thing vibrating] && [thing objectHitRect:fallingMan.manRect]) {
			[thing hammerHit];
		}
		/*if ([thing active] && fallingMan.dancing && ![thing vibrating] && [thing objectHitRect:fallingMan.manRect]) {
			[thing danceHit];
		}*/
	}
	thing = [things objectAtIndex:numberOfLargeObstacles + numberOfSmallObstacles + 1];
	if ([thing active] && !manActing && [thing objectHitRect:fallingMan.manRect]) {
		[fallingMan danceAnim];
		[thing setVisible:NO];
	}
	thing = [things objectAtIndex:numberOfLargeObstacles + numberOfSmallObstacles + 3];
	if ([thing active] && !fallingMan.glowing && [thing objectHitRect:fallingMan.manRect]) {
		gs.health++;
		[fallingMan glow];
		gs.parachuteChanged = 1;
		[thing setVisible:NO];

	}
	thing = [things objectAtIndex:numberOfLargeObstacles + numberOfSmallObstacles + 2];
	if ([thing active] && !manActing && [thing objectHitRect:fallingMan.manRect]) {
		[fallingMan jackHammerAnim];
		[thing setVisible:NO];

	}
}

-(void) update: (ccTime) delta
{
	if (gs.health > 0) [self collisionDetector];
	static float distance = 0.0f;
	distance += delta * gs.gameSpeed;
	if (distance > obstacleTargetDistance) {
		[self spawnObstacle];
		obstacleTargetDistance = distance + 150 + (arc4random() % 250);
	}
	if (distance > powerupTargetDistance) {
		[self spawnPowerUp];
		powerupTargetDistance = distance + 4000 + (arc4random() % 2000);
	} 
}


-(void) dealloc
{
	[things release];
	things = nil;
	[super dealloc];
}

@end
