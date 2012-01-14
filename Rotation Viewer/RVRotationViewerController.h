//
//  RVRotationViewerController.h
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 appingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVRotationView.h"
@interface RVRotationViewerController : UIViewController {
    
    NSString *imageDirectory;
    
    @private
    RVRotationView *rotationView;
    
}

@property (nonatomic, retain) NSString *imageDirectory;

-(id)initWithImageDirecotry:(NSString *)directoryName;

-(void)reloadImages;




@end
