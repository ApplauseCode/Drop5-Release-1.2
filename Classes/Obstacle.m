//
//  Obstacle.m
//  Drop3
//
//  Created by Jeffrey Rosenbluth on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Obstacle.h"
#define DEBUG_ON 0

@implementation Obstacle

@synthesize rect;

+(id) obstacleWithName:(NSString *)name dict: (NSDictionary *) _dict left: (bool) _left
{
	return [[[self alloc] initWithName: name dict: _dict left: _left] autorelease];
}

-(id) initWithName: (NSString *) name dict: (NSDictionary *) _dict left: (bool) _left
{
	float xCoord;
	bool flipped = [[_dict objectForKey:@"flipped"] boolValue];
	if (_left) {
		xCoord = [[_dict objectForKey:@"xCoordLeft"] floatValue];
	}
	else {
		xCoord = [[_dict objectForKey:@"xCoordRight"] floatValue];
		flipped = !flipped;
	}
	float _wAdj = [[_dict objectForKey:@"wAdjust"] floatValue];
	float _hAdj = [[_dict objectForKey:@"hAdjust"] floatValue];
	if ((self = [super initWithName: name xCoord: xCoord flipped: flipped])) {
		wAdj = _wAdj;
		hAdj = _hAdj;
		[self scheduleUpdate];
	}
	return self;
}

-(bool) objectHitRect: (CGRect) aRect
{
	if (CGRectIntersectsRect(rect, aRect)) {
		return YES;
	}
	else {
		return NO;
	}

}

#if DEBUG_ON
-(void) draw
{
	CGPoint vertices[4]={
		ccp(rect.origin.x,rect.origin.y),ccp(rect.origin.x + rect.size.width,rect.origin.y),
		ccp(rect.origin.x + rect.size.width,rect.origin.y +rect.size.height),ccp(rect.origin.x,rect.origin.y + rect.size.height),
	};
	glLineWidth( 2.0f );
	glColor4ub(255,0,0,255);
	ccDrawPoly(vertices, 4, YES);
	glColor4ub(0,0,0,255);
}
#endif
-(void) update: (ccTime) delta
{	
	[super update: delta];
	if (active) {
		rect = CGRectInset([gameSprite boundingBox], wAdj, hAdj);
	}
}

-(void) dealloc
{
	[super dealloc];
}

@end
