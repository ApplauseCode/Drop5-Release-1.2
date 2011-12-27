//
//  PowerUp.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PowerUp.h"


@implementation PowerUp

@synthesize rect;


+(id) powerUpWithName:(NSString *)name dict: (NSDictionary *) _dict
{
	return [[[self alloc] initWithName: name dict: _dict] autorelease];
}

-(id) initWithName: (NSString *) name dict: (NSDictionary *) _dict
{
	float xCoord = [[_dict objectForKey:@"xCoord"] floatValue];
	float _wAdj = [[_dict objectForKey:@"wAdjust"] floatValue];
	float _hAdj = [[_dict objectForKey:@"hAdjust"] floatValue];
	if ((self = [super initWithName: name xCoord: xCoord flipped: NO])) {
		wAdj = _wAdj;
		hAdj = _hAdj;
		[self spin];
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

