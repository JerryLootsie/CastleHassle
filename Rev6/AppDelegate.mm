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

@implementation AppDelegate

@synthesize window;


/**
 Singleton instance
 */
+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        //_sharedObject = [[self alloc] init];
        _sharedObject = [self alloc];
        
        NSLog(@"AppDelegate: singleton created!");
    });
    return _sharedObject;
}


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

- (id) init
{
    NSLog(@"AppDelegate: init");
    
    return self;
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    
    self = [[AppDelegate sharedInstance] init];
    
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
    
    // bug fix
    // http://stackoverflow.com/questions/10160995/cocos2d-opengl-error-0x0502-in-eaglview-swapbuffers
    // https://developer.apple.com/library/ios/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/WorkingwithOpenGLESContexts/WorkingwithOpenGLESContexts.html
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (context == nil) {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSLog(@"AppDelegate: EAGLContext initWithAPI: kEAGLRenderingAPIOpenGLES2 successful!");
    } else {
        NSLog(@"AppDelegate: EAGLContext initWithAPI: kEAGLRenderingAPIOpenGLES3 successful!");
    }
    //[EAGLContext setCurrentContext:context]; // causes crash!
    
    
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
    

    

    
    // Override point for customization after application launch.
    ServiceCallback initCallback = ^(BOOL success, id result, NSString* error, NSInteger statusCode) {
        if (success) {
            NSLog(@"AppDelegate: initCallback success: %@", error);
            

//            [[Lootsie sharedInstance] achievementReachedWithId:@"castlehit"];
        } else {
            NSLog(@"AppDelegate: initCallback failure: %@", error);
        }
    };
    
//    [[Lootsie sharedInstance] setLogLevel:verbose];
    
    [[Lootsie sharedInstance] initWithAppKeyCallback:@"65356DA3B2AE759182C8ACB278CB7DF6666C45ED6A5CDDA7267EFC214E8F3F31" callback:initCallback];
    
   	Lootsie *lootsie = [Lootsie sharedInstance];
   	lootsie->getControllerBlock = ^UIViewController* (void){
        // Change these example lines: get your viewcontroller instead.
        //        id<UIApplicationDelegate> delegate =[UIApplication sharedApplication].delegate;
        //        UIViewController * controller = [delegate window].rootViewController;
        //       	NSLog(@"AppDelegate: overridden Lootsie getController: %@", controller.class);
        //       	return controller; // You will return your viewcontroller here.
        
        UIViewController * controller = [[AppDelegate sharedInstance] getRootViewController];
        NSLog(@"AppDelegate: overridden Lootsie getController: %@", controller.class);
        return controller;
    };
    
    // one time achievement
    [[Lootsie sharedInstance] setDelegate:self];
    [[Lootsie sharedInstance] setNotificationConfiguration:notify_to_rewardsPage];
    [[Lootsie sharedInstance] achievementReachedWithId:@"applaunch"];
    

	
    // Run the intro Scene
    [[CCDirector sharedDirector] runWithScene:[MainMenu instance]];
}

-(UIViewController*) getRootViewController {
    return viewController;
}

// Lootsie delegate method.  This is called when an achievement (Lootsie pop!) is expanded (Lootsie roll!).
- (void) achievementReachedBarExpanded
{
    NSLog(@"AppDelegate: AppDelegate callback: Achievement reached and the Lootsie Pop has been expanded into a Lootsie Roll because the user tapped it!");
    
	//[[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
    //[self pauseSchedulerAndActions];
}

// Lootsie delegate method.  This is called when an achievement page has been closed.
- (void) achievementReachedBarClosed
{
    NSLog(@"AppDelegate: AppDelegate callback: Achievement page has been closed");
    
	//[[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    //[self resumeSchedulerAndActions];
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

@end
