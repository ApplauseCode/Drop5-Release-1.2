//
//  LongObstacle.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 1/7/11.
//  Copyright 2011 Applause. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Obstacle.h"

@interface LongObstacle : Obstacle {
	CGRect leftRect, rightRect;
	float left, right;
}

+(id) longObstacleWithName:(NSString *)name dict: (NSDictionary *) _dict;
-(id) initWithName: (NSString *) name dict: (NSDictionary *) _dict;

-(bool) objectHitRect: (CGRect) aRect;

@end
