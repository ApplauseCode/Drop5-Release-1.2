//
//  PowerUp.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "GameObject.h"

@interface PowerUp : GameObject 
{
	float wAdj, hAdj;
	CGRect rect;
}

@property (assign, nonatomic) CGRect rect;

+(id) powerUpWithName:(NSString *)name dict: (NSDictionary *) _dict;
-(id) initWithName: (NSString *) name dict: (NSDictionary *) _dict;
-(bool) objectHitRect: (CGRect) aRect;

@end
