//
//  GameObject.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@interface GameObject : CCNode 
{
	GameState *gs;
	CCSprite* gameSprite;
	bool active, vibrating, shuffling;
	float posX;
}

@property (assign, nonatomic) bool active;
@property (assign, nonatomic) bool vibrating;
//@property (assign, nonatomic) bool shuffling;

-(id) initWithName: (NSString *) name xCoord: (float) xCoord flipped: (bool) flipped;
-(void) update:(ccTime)delta;
//-(void) danceHit;
-(void) hammerHit;
-(void) spin;

@end

