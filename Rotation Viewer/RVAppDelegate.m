//
//  RVAppDelegate.m
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 appingo. All rights reserved.
//

#import "RVAppDelegate.h"
#import "ZipArchive.h"
#import "PSFileManager.h"

@implementation RVAppDelegate

@synthesize window = _window;
@synthesize rootViewController = rootController;

// dummy for init

-(void)createImageRootInDocDir
{
    
    // unzip animation images from bundle to doc dir to have somthing to display
    
    PSFileManager *fileman = [[PSFileManager alloc] init];
    
    NSString *docPath = [fileman getDocumentsDirectoryPath];
    
    ZipArchive *zipper = [[ZipArchive alloc] init];
    
    NSString *animationPath = [docPath stringByAppendingPathComponent:@"animation"];
    
    if (![fileman fileExistsAtPath:animationPath]) {
        [fileman createDirectoryAtPath:[docPath stringByAppendingPathComponent:@"animation"] withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"Initially created animation directory in documents directory");
    }
    
    
    [zipper UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"animation_sample" ofType:@"zip"]];
    [zipper UnzipFileTo:animationPath overWrite:YES];
    [zipper CloseZipFile2];
    
    NSLog(@"unzipped test images to %@", animationPath);
    
    [zipper release];
    [fileman release];
    
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self createImageRootInDocDir]; // create test data
    
    PSFileManager *fileman = [[PSFileManager alloc] init];
    
    NSString *docPath = [fileman getDocumentsDirectoryPath];
    
    
    NSString *animationPath = [docPath stringByAppendingPathComponent:@"animation"];

    
    rootViewController = [[RVRotationViewerController alloc] initWithImageDirecotry:animationPath];
    
    [fileman release];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [self.window addSubview:rootViewController.view];
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
