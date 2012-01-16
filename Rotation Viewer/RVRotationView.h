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
    
    BOOL decelerateAnimation;
    float dragSenitivity;
    
    @private
    
    NSInteger animationPosition;            // actual frame position
    
    CGPoint touchStart;                     // point where touch starts
    CGPoint swipeStartPoint;                // point where drag starts
   
    NSInteger dragDistance;                 // distance of the drag
    
    NSInteger animationDirection;           // 1 = right, -1 = left
    NSInteger numberOfAnimationSteps;       // animation steps used for deceleration animmation (animation frame count)
    NSInteger decelerationSteps;

    NSTimeInterval swipeEndTime;             // timestamp of drag end
   // NSTimeInterval dragStartTime;           // timestamp of drag start
    NSTimeInterval swipeStartTime;          // timestamp of swipe start
    
    float startFrameGap;                    // used for deceleration animation. 
    float actualframeGap;                   // used for deceleration animation.
    
    BOOL cancelDeceleration;                // used to abort the deceleration animation
    
    NSTimer *decelerationTimer;             // timer that fires for displaying the next deceleration animation image
    
}

@property (nonatomic, retain) NSArray *imagePaths;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, assign) float dragSensitivity;
@property (nonatomic, assign) BOOL decelerateAnimation;

-(void)loadAnimationFromDirectory:(NSString *)animationDirectory; // animation directory must be the root dir that contains the images

-(NSInteger)numberOfImages;
-(void)displayImageWithPosition:(NSInteger)imagePosition;


-(void)rotateLeft;
-(void)rotateRight;

-(void)animateRotationLeft;
-(void)animateRotationRight;


@end
