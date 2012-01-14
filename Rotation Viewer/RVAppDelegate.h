//
//  RVAppDelegate.h
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 appingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVRotationViewerController.h"

@interface RVAppDelegate : UIResponder <UIApplicationDelegate> {
    
    RVRotationViewerController *rootViewController;
    
}

    

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) RVRotationViewerController *rootViewController;

// dummy for init

-(void)createImageRootInDocDir;

@end
