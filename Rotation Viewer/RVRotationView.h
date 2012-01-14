//
//  RVRotationView.h
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RVRotationView : UIView {
    
    UIImageView *imageView;
    
    NSMutableArray *imagePaths;
    
    @private
    NSInteger animationPosition;
    CGPoint touchStart;
    CGPoint dragStart;
   
    NSInteger dragDistance;
    
    float dragSenitivity;
    
    NSTimeInterval dragEndTime;
    NSTimeInterval dragStartTime;
    NSTimeInterval swipeStartTime;
    
    NSInteger animationDirection; // 1 = right, -1 = left
    NSInteger numberOfAnimationSteps;
    
    float startFrameGap;
    float actualframeGap;
    
    
    BOOL cancelDeceleration;
    
    NSInteger decelerationSteps;
    NSTimer *decelerationTimer;
    
}

@property (nonatomic, retain) NSArray *imagePaths;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, assign) float dragSensitivity;

-(void)loadAnimationFromDirectory:(NSString *)animationDirectory;

-(NSInteger)numberOfImages;
-(void)displayImageWithPosition:(NSInteger)imagePosition

@end
