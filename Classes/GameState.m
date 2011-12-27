//
//  GameState.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

#define kMaxScores 10

static GameState *_sharedState = nil;

@implementation GameState

@synthesize accelX;
@synthesize gameSpeed;
@synthesize health;
@synthesize level, startLevel, maxLevel;
@synthesize score;
@synthesize horizontalMovement, dead, paused, isPlaying;
@synthesize musicOn, soundOn;
@synthesize skyscraperOffset;
@synthesize size;
@synthesize name;
@synthesize highScores;
@synthesize parachuteChanged;

#if USE_BATCH_NODE
@synthesize sheet;
#endif

+ (GameState *)sharedState{
	if (!_sharedState)
		_sharedState = [[self alloc] init];
	return _sharedState;
}

+(id)alloc
{
	NSAssert(_sharedState == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

-(id) init
{
	if( (self=[super init]) ) {	
		size = [[CCDirector sharedDirector] winSize];
		paused = NO;
		isPlaying = NO;
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		maxLevel = [prefs integerForKey:@"levelKey"];
		if (!maxLevel) maxLevel = 1;
		musicOn = [prefs boolForKey:@"musicKey"];
		soundOn = [prefs boolForKey:@"soundKey"];
		name = [prefs objectForKey:@"nameKey"];
		highScores = [[NSMutableArray alloc] initWithArray: [prefs arrayForKey:@"scoreKey"]];
		//highScores = [[prefs arrayForKey:@"scoreKey"] mutableCopy];
		if ([highScores count] == 0) {
			int i;
			NSDictionary *tempScore = [NSDictionary dictionaryWithObjectsAndKeys: @"", @"name",
				[NSNumber numberWithInt:0], @"gameScore", nil];
			for (i=0; i<kMaxScores; i++) {
				[highScores addObject:tempScore];
			}
			[tempScore release];
			tempScore = nil;
		}
					  
	}
	return self;
}

- (void) dealloc
{
	[highScores release];
	highScores = nil;
	_sharedState = nil;
	[super dealloc];
}

@end