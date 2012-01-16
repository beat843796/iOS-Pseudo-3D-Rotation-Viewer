//
//  RVRotationViewerController.h
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 appingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVRotationView.h"
#import "RVRotationViewDelegate.h"

@interface RVRotationViewerController : UIViewController <RVRotationViewDelegate>{
    
    NSString *imageDirectory;
    
    @private
    RVRotationView *rotationView;
    
    UIButton *rotateLeftButton;
    UIButton *rotateRightButton;
    UIButton *startButton;
    UIButton *stopButton;
    UISlider *rotationSpeedSlider;
   
}

@property (nonatomic, retain) NSString *imageDirectory;

-(id)initWithImageDirecotry:(NSString *)directoryName;

-(void)reloadImages;




@end
