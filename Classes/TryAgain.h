//
//  TryAgain.h
//  Drop5
//
//  Created by Jeffrey Rosenbluth on 2/14/11.
//  Copyright 2011 Applause Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
#import "SimpleAudioEngine.h"



@interface TryAgain : CCLayer <UITextFieldDelegate>
{
	GameState* gs;
	CCMenuItemImage *back;
	UITextField		*nameField_;
}

+(id) scene;
-(UITextField*) newTextField;
-(void) addScore: (float) score forName: (NSString *) name;

@end
