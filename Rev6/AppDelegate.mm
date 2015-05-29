//
//  AppDelegate.m
//  Rev6
//
//  Created by Bryce Redd on 1/11/12.
//  Copyright Itv 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "MainMenu.h"
#import "Lootsie.h"

@interface AppDelegate () <LootsieDelegate>

@end

@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //viewController.wantsFullScreenLayout = YES;
	
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
	
    NSLog(@"AppDelegate: Window: %@", NSStringFromCGRect(window.bounds));
    
    
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
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
    NSLog(@"AppDelegate: applicationDidFinishLaunching: kGameAutorotationUIViewController");
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
    //[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#else
    NSLog(@"AppDelegate: applicationDidFinishLaunching: rotation other");
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	//[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
    
    // Lootsie fix
    [window setRootViewController:viewController];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene:[MainMenu instance]];

	ServiceCallback initCallback = ^(BOOL success, id result, NSString* error, NSInteger statusCode) {
		if (success) {
			NSLog(@"AppDelegate: Lootsie initialized with success");
		} else {
			NSLog(@"AppDelegate: Lootsie failed to initialize, error: %@", error);
		}
	};

	NSString *appKey = @"65356DA3B2AE759182C8ACB278CB7DF6666C45ED6A5CDDA7267EFC214E8F3F31";

	[[Lootsie sharedInstance] initWithAppKeyCallback:appKey callback:initCallback];



	// Start-up Achievement
	ServiceCallback achievementReachedCallback = ^(BOOL success, id result, NSString* errorMessage, NSInteger statusCode) {
		if (success) {
			NSLog(@"AppDelegate: Lootsie Achievement Reached!");
		} else {
			NSLog(@"AppDelegate: Lootsie Achievement Reached Failed with error: %@", errorMessage);
		}
	};

	[[Lootsie sharedInstance] achievementReachedWithIdLocationCallback:@"applaunch" location:@"default" callback:achievementReachedCallback];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
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

+ (NSString *) documentDir {
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [documentPaths objectAtIndex:0];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

- (void)achievementReachedBarExpanded {
	[[CCDirector sharedDirector] pause];
}

- (void)achievementReachedBarClosed {
	[[CCDirector sharedDirector] resume];
}

@end
