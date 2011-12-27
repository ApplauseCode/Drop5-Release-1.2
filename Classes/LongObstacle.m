//
//  LongObstacle.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 1/7/11.
//  Copyright 2011 Applause. All rights reserved.
//

#import "LongObstacle.h"


@implementation LongObstacle

+(id) longObstacleWithName:(NSString *)name dict: (NSDictionary *) _dict
{
	return [[[self alloc] initWithName: name dict: _dict] autorelease];
}

-(id) initWithName: (NSString *) name dict: (NSDictionary *) _dict
{
	if ((self = [super initWithName:name dict: _dict left:YES]))
	{
		right = [[_dict objectForKey:@"right"] floatValue];
		left = [[_dict objectForKey:@"left"] floatValue];
	}
	return self;
}

-(bool) objectHitRect: (CGRect) aRect
{
	leftRect = CGRectOffset(rect, left, 0);
	rightRect = CGRectOffset(rect, right, 0);
	if (CGRectIntersectsRect(rightRect, aRect) || CGRectIntersectsRect(leftRect, aRect)) {
		return YES;
	}
	else {
		return NO;
	}
	
}

/*-(void) draw
{
	CGPoint vertices[4]={
		ccp(leftRect.origin.x,leftRect.origin.y),ccp(leftRect.origin.x + leftRect.size.width,leftRect.origin.y),
		ccp(leftRect.origin.x + leftRect.size.width,leftRect.origin.y +leftRect.size.height),ccp(leftRect.origin.x,leftRect.origin.y + leftRect.size.height),
	};
	glLineWidth( 2.0f );
	glColor4ub(255,0,0,255);
	ccDrawPoly(vertices, 4, YES);
	CGPoint vertices2[4]={
		ccp(rightRect.origin.x,rightRect.origin.y),ccp(rightRect.origin.x + rightRect.size.width,rightRect.origin.y),
		ccp(rightRect.origin.x + rightRect.size.width,rightRect.origin.y +rightRect.size.height),ccp(rightRect.origin.x,rightRect.origin.y + rightRect.size.height),
	};
	ccDrawPoly(vertices2, 4, YES);
	glColor4ub(0,0,0,255);

}*/

@end
