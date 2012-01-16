//
//  RVRotationViewDelegate.h
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 16.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RVRotationView.h"

@class RVRotationView;
@protocol RVRotationViewDelegate <NSObject>

@optional

-(void)rotationViewDidStartDecelerating:(RVRotationView *)rotationView;
-(void)rotationViewDidStopDecelerating:(RVRotationView *)rotationView;

-(void)rotationViewDidStartAnimating:(RVRotationView *)rotationView;
-(void)rotationViewDidStopAnimating:(RVRotationView *)rotationView;

@end
