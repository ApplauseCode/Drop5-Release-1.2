//
//  TryAgain.m
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/14/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import "TryAgain.h"
#import	"LevelScene.h"

@implementation TryAgain

+(id) scene
{
	CCScene* scene = [CCScene node];
	TryAgain* layer = [TryAgain node];
	[scene addChild: layer z:0];
	return scene;
}

-(id) init
{
	
	if ((self = [super init]))
	{		
		gs = [GameState sharedState];
		CCSprite *bg=[CCSprite spriteWithFile:@"retry.jpg"];
		bg.position = ccp(gs.size.width /2, gs.size.height /2);
		[self addChild : bg z:-1];
		CCSprite *gameOver = [CCSprite spriteWithFile:@"game_over.png"];
		gameOver.position = ccp(gs.size.width/2 + 10, 375);
		[gameOver runAction:[CCRotateBy actionWithDuration:0 angle:-3]];
		[self addChild:gameOver];
		CCSprite *tap = [CCSprite spriteWithFile:@"taptochange.png"];
		tap.position = ccp(gs.size.width/2  -45, 250);
		tap.scale = 1.25;
		[self addChild:tap];
		[CCMenuItemFont setFontSize:50];
		[CCMenuItemFont setFontName:@"Stencil Regular.ttf"];
		CCMenuItemFont  *playAgain = [CCMenuItemFont itemFromString:@"Again" target:self selector:@selector(loading:)];
		[playAgain setColor: ccWHITE];
		[playAgain setTag:1];
		playAgain.position = ccp(gs.size.width/2, gs.size.height /2  - 150);
		CCMenu *menu = [CCMenu menuWithItems:playAgain, nil];
		menu.position = ccp(0, 0);
		[self addChild : menu z:1];
		back = [CCMenuItemImage itemFromNormalImage:@"back_button.png" selectedImage:@"back_button2P.png"
															  target: self selector:@selector(loading:)];
		[back setTag:2];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(25,455);
		[self addChild:backMenu z:1];
		
		if (gs.musicOn)
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menuLoop.caf" loop:YES];
		
		NSString *text = [NSString stringWithFormat:@"You have dropped %i'", (int) gs.score];
		CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString: text fontName:@"Arial Rounded MT Bold" fontSize: 18];
		[scoreLabel setAnchorPoint:ccp(0,0)];
		scoreLabel.position = ccp(20, 165);
		[scoreLabel setColor:ccYELLOW];
		[self addChild:scoreLabel];
		
		int hs = [[[gs.highScores objectAtIndex:0] objectForKey:@"gameScore"] intValue]; 
		if (gs.score > hs) hs = (int) gs.score;
		text = [NSString stringWithFormat:@"The longest fall was %i'", (int) hs];
		CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString: text fontName:@"Arial Rounded MT Bold" fontSize: 18];
		[highScoreLabel setAnchorPoint:ccp(0,0)];
		highScoreLabel.position = ccp(20, 135);
		[highScoreLabel setColor:ccYELLOW];
		[self addChild:highScoreLabel];
		
	}
	return self;
}

#pragma mark UILabel, UISwitch & UITextField creation
- (UITextField *)newTextField
{
	UITextField *returnTextField = [[UITextField alloc] initWithFrame:CGRectZero];
	
	returnTextField.borderStyle = UITextBorderStyleNone;
	returnTextField.textColor = [UIColor whiteColor];
	returnTextField.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
	returnTextField.text = gs.name;
	returnTextField.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0f];
	
	returnTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	returnTextField.textAlignment = UITextAlignmentLeft;
	
	returnTextField.keyboardType = UIKeyboardTypeDefault;
	returnTextField.returnKeyType = UIReturnKeyDone;
	//returnTextField.clearsOnBeginEditing = YES;
	
	//returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	returnTextField.delegate = self;
	return [returnTextField autorelease];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//textField.clearsOnBeginEditing = YES;
	textField.placeholder = @"enter your name";
	[back setIsEnabled:NO];
	[[CCTouchDispatcher sharedDispatcher] setDispatchEvents: NO];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
	[[CCTouchDispatcher sharedDispatcher] setDispatchEvents: YES];
	[back setIsEnabled:YES];
}
#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
	gs.name = tf.text;
	[tf resignFirstResponder];
	//[nameField_ removeFromSuperview];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:gs.name forKey:@"nameKey"];
	return NO;
}

-(void) loading: (id) sender
{
	[nameField_ removeFromSuperview];
	[self addScore:(int) gs.score forName:gs.name];	
	CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Stencil Regular.ttf" fontSize:20];
	loading.position = ccp(gs.size.width/2, gs.size.height / 2 - 15);
	[loading setColor:ccWHITE]; 
	[self addChild:loading];
	int button = [sender tag];
	switch (button) {
		case 1:
			[self schedule:@selector(play) interval:0.01];
			break;
		case 2:
			[self schedule:@selector(changeToMenu) interval:0.01];
			break;
		default:
			break;
	}
}

-(void) play
{
	[self unschedule:@selector(play)];
	int pLevel = 1 + ((gs.startLevel - 1) % 4);
	NSString* level = [NSString stringWithFormat:@"Level%d.plist",pLevel];
	bool isNight = (gs.startLevel > 4);	
	gs.level = gs.startLevel;
	gs.health = 3;
	gs.parachuteChanged = 0;
	gs.score = 0;
	gs.accelX = 0.0;
	gs.dead = NO;
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene: 
											   [LevelScene sceneWithName: level night:isNight]]];
}

-(void) changeToMenu
{
	[self unschedule:@selector(changeToMenu)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene: 
											   [Menu scene]]];
}

-(void) addScore: (float) score forName: (NSString *) name;
{
	NSDictionary *currentHighScore = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", [NSNumber numberWithInt:(int) score], @"gameScore", nil];
	[gs.highScores addObject:currentHighScore];
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"gameScore"
												  ascending:NO] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray = [gs.highScores sortedArrayUsingDescriptors:sortDescriptors];	
	[gs.highScores setArray:sortedArray];
	[gs.highScores removeLastObject];
}
-(void) onExit
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:gs.highScores forKey:@"scoreKey"];
	[super onExit];
}

-(void) onEnterTransitionDidFinish
{
	nameField_ = [self newTextField];
	CGRect frame = CGRectMake(40.0f, 240, 240, 25);
	nameField_.frame = frame;
	[[[CCDirector sharedDirector] openGLView] addSubview: nameField_];
	[nameField_ becomeFirstResponder];
	[nameField_ resignFirstResponder];		
}
-(void) dealloc
{
	[super dealloc];
}

@end
