//
//  Man.h
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import	"MenuScene.h"
#import "TryAgain.h"
#import "SimpleAudioEngine.h"

@interface Man : CCNode {

	GameState *gs;
	CCSprite *fallingManSprite;
	CGRect manRect;
	float manPosX, bounceTime;
	bool didBounce;
	bool crashing, dancing, hammering, glowing;
}

@property (assign, nonatomic) CGRect manRect;
@property (assign, nonatomic) bool crashing, dancing, hammering, glowing;
//@property (readwrite,retain) CCParticleSystem *emitter;

+(id) fallingManWithName:(NSString *)name;
-(id) initWithName: (NSString *)name;
-(void) danceAnim;
-(void) jackHammerAnim;
-(void) crashAnim;
-(void) bounce;
-(void) ripParachute;
-(void) glow;
-(void) die;

@end

