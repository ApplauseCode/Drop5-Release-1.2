//
//  Drop5AppDelegate.h
//  Drop5
//
//  Created by Reed Rosenbluth on 1/20/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"

@class RootViewController;

@interface Drop5AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

-(void) preLoadSounds;
-(void) preLoadTextures;

@end
