//
//  Drop5AppDelegate.m
//  Drop5
//
//  Created by Reed Rosenbluth on 1/20/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "Drop5AppDelegate.h"
#import "GameConfig.h"
#import "MenuScene.h"
#import "RootViewController.h"
#import "SimpleAudioEngine.h"
#import "LevelScene.h"

@implementation Drop5AppDelegate

@synthesize window;

bool resignedActiveWhilePlaying = NO;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[glView swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	//[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];

#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	[director setDeviceOrientation: kCCDeviceOrientationPortrait];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	[self preLoadTextures];
	[self preLoadSounds];
	//GameKit Views
	//window.rootViewController = viewController;
	if ([window respondsToSelector:@selector(setRootViewController:)])
	{
		window.rootViewController = viewController;
	}
	// Run the intro Scene
	NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"musicKey", @"YES", @"soundKey", 
							  @"your name", @"nameKey", nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
	[[CCDirector sharedDirector] runWithScene: [Menu scene]];	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[UIApplication sharedApplication].idleTimerDisabled = NO;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	GameState* gs = [GameState sharedState];
	if (gs.isPlaying) {
		if (!gs.paused) {
			UIAlertView *pauseAlert = [[UIAlertView alloc]
									   initWithTitle:@"Game Paused"
									   message:nil
									   delegate:self
									   cancelButtonTitle:nil
									   otherButtonTitles:@"Resume",nil];	
			[pauseAlert show];
			[pauseAlert release];
		}	
		else {
			gs.paused = YES;
		}
	}
	else {
		[[CCDirector sharedDirector] resume];
		[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	}
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[[CCDirector sharedDirector] resume];
	[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void) preLoadTextures
{
	CCTextureCache * textureCache = [CCTextureCache sharedTextureCache];
	[textureCache addImage:@"dance_overlay.png"];
	[textureCache addImage:@"blueBG.jpg"];
	[textureCache addImage:@"retry.jpg"];
	CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[frameCache addSpriteFramesWithFile:@"z.plist"];
}

-(void) preLoadSounds
{
	SimpleAudioEngine *soundEngine = [SimpleAudioEngine sharedEngine];
	
	[soundEngine preloadEffect: @"drop_sound.caf"];
	[soundEngine preloadEffect: @"jackhammer_sound.caf"];
	[soundEngine preloadBackgroundMusic:@"moringLoop.caf"];
	[soundEngine preloadBackgroundMusic:@"dayLoop.caf"];
	[soundEngine preloadBackgroundMusic:@"nightLoop.caf"];
	[soundEngine preloadBackgroundMusic:@"Drop_Dance.caf"];
	[soundEngine setEffectsVolume:.5];
	[soundEngine setBackgroundMusicVolume:.5];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
