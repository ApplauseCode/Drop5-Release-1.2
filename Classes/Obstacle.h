//
//  Obstacle.h
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "GameObject.h"

@interface Obstacle : GameObject 
{
	float wAdj, hAdj;
	CGRect rect;
}

@property (assign, nonatomic) CGRect rect;

+(id) obstacleWithName:(NSString *)name dict: (NSDictionary *) _dict left: (bool) _left;
-(id) initWithName: (NSString *) name dict: (NSDictionary *) _dict left: (bool) _left;
-(bool) objectHitRect: (CGRect) aRect;

@end
