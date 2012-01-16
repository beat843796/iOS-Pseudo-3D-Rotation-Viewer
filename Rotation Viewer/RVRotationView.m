//
//  RVRotationView.m
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVRotationView.h"
#import "PSFileManager.h"

#define DEFAULT_DRAG_SENSITIVITY 0.15
#define DRAGTIME_CUTOFF 0.2
#define SWIPETIME_CUTOFF 0.05
#define DEFULAT_ANIMATIONSPEED 1
#define ANIMATION_FRAMERATE 0.03

@interface RVRotationView (private) {
@private
    
}

-(void)displayImage;
-(void)decellerateAnimation;
-(void)invokeDeceleration;
-(void)checkForValidAnimationPosition;
-(void)invokeRotationAnimation;
-(void)doAnimation;

@end

@implementation RVRotationView

@synthesize delegate;

@synthesize imageView;
@synthesize imagePaths;
@synthesize dragSensitivity;
@synthesize decelerateAnimation;
@synthesize animationSpeed;
@synthesize isAnimating;
@synthesize animationDirection;

#pragma mark -
#pragma mark Initialization

-(id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        dragSenitivity = DEFAULT_DRAG_SENSITIVITY; // default
        decelerateAnimation = YES; // default to no
        animationSpeed = DEFULAT_ANIMATIONSPEED;
        isAnimating = NO;
        animationDirection = RVRotationViewDirectionRight; // default to right
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        [imageView release];
        
    }
    return self;
}

-(void)dealloc
{
    [imagePaths release];
    
    if ([decelerationTimer isValid]) {
        [decelerationTimer invalidate];
        decelerationTimer = nil;
    }
    
    [super dealloc];
}

#pragma mark -
#pragma mark View Code

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    imageView.frame = self.bounds;
}

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    imageView.frame = self.bounds;
}

#pragma mark -
#pragma mark Public Methods

// Rotate one frame left

-(void)rotateLeft
{
    
    animationPosition++;
    
    [self checkForValidAnimationPosition];
    [self displayImage];
    
}

// rotate one frame right

-(void)rotateRight
{
    animationPosition--;
    
    [self checkForValidAnimationPosition];
    [self displayImage];
}

// animate rotation left



-(void)startRotationAnimationWithDirection:(RVRotationViewDirection)direction
{
    
    if (isAnimating) {
        return;
    }
    
    animationDirection = direction;
    
    [self invokeRotationAnimation];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(rotationViewDidStartAnimating:)]) {
        [delegate rotationViewDidStartAnimating:self];
    }
    
}

-(void)stopRotationAnimation
{
    if ([animationTimer isValid]) {
        [animationTimer invalidate];
        animationTimer = nil;
    }
    
    isAnimating = NO;
    
    if (delegate != nil && [delegate respondsToSelector:@selector(rotationViewDidStopAnimating:)]) {
        [delegate rotationViewDidStopAnimating:self];
    }
    
}

-(NSInteger)numberOfImages
{
    if (imagePaths != nil) {
        return [imagePaths count];
    }else {
        return 0;
    }
}

-(void)displayImageWithPosition:(NSInteger)imagePosition
{
    if (imagePosition < [imagePaths count]) {
        
        animationPosition = imagePosition;
        [self displayImage];
        
    }
    
    NSLog(@"Error: imagePosition out of Range. Valid Range: 0-%i",[imagePaths count]);
}

/*
 
 Loads all filenames inside animationDirectory into imagePaths array.
 Images must be ordered. (i1,i2,i3,i4,...,in => frame 0 degrees, frame 5 degrees, frame 10 degrees...)
 
 Just the filenames are loaded, not the images!
 
 */

-(void)loadAnimationFromDirectory:(NSString *)animationDirectory
{
    // Reset animation position because its assumed that new file is loaded.
    
    animationPosition = 0; 
    
    // load image names
    
    NSFileManager *fileman = [[NSFileManager alloc] init];
    
    NSArray *directoryContent = [fileman contentsOfDirectoryAtPath:animationDirectory error:nil];
    self.imagePaths = [[[NSMutableArray alloc] initWithCapacity:[directoryContent count]] autorelease];
    
    for (NSString *image in directoryContent) {
        
        [imagePaths addObject:[animationDirectory stringByAppendingPathComponent:image]];
        
    }
    
    [fileman release];
    
    if (imagePaths != nil && [imagePaths count] > 0) {
        
        [self displayImageWithPosition:animationPosition];
        
    }
    
}

#pragma mark -
#pragma mark - Touch Logic

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // Cancel Rotation Animation if active
    
    if ([animationTimer isValid]) {
        [self stopRotationAnimation];
    }
    
    // Cancel active deceleration animation when user touches screen
    
    cancelDeceleration = YES;
    
    if (decelerationTimer != nil) {
        if ([decelerationTimer isValid]) {
            [decelerationTimer invalidate];
            decelerationTimer = nil;
        }
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    touchStart = touchPoint;
    swipeStartPoint = touchPoint;
    
   // dragStartTime = [[NSDate date] timeIntervalSince1970];
    swipeStartTime = [[NSDate date] timeIntervalSince1970];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    
    // Calculate drag distance. This distance is used to calculate the position
    // for the next image to be displayed. If the drag distance is high we have
    // to skip some images to provide a more realistic rotation. Dragdistance is
    // multiplied with dragSensitivity (should be > 0 and <= 1).
    
    dragDistance = abs(touchPoint.x-touchStart.x);
    
    dragDistance*=dragSenitivity;
    
    // set default value if dragDistance is invalid
    
    if (dragDistance == 0) {
        dragDistance = 1;
    }

    // detect right swipe/drag
    
    if (touchPoint.x > touchStart.x) {
        animationDirection = 1;
        animationPosition+=dragDistance;
        
        
    // etect left swipe/drag
        
    }else if(touchPoint.x < touchStart.x) {
        animationDirection = -1;
        animationPosition-=dragDistance;
    }
    
   
    [self checkForValidAnimationPosition];
    

    [self displayImage];
    

    // Update values for calculations
    
    touchStart = touchPoint;
    swipeEndTime = [[NSDate date] timeIntervalSince1970];
    
    // If the time between 2 touch samples is bigger than the dragTimeCutoff the actual
    // touchpoint will be set as new swipe start point. Needed to detect swipes inside a 
    // touchesBegan -> touchesEnded cycle
    
    if (swipeEndTime-swipeStartTime > DRAGTIME_CUTOFF) {
        
        // Set new swipeStartPoint if actual swipe has canceled
        
        swipeStartPoint = touchPoint;
    }
    
    swipeStartTime = swipeEndTime;
    
      
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    NSInteger swipeDistance = abs(swipeStartPoint.x-touchPoint.x);

    NSTimeInterval touchEndTime = [[NSDate date] timeIntervalSince1970];
    

    
    // Detect if user finalized swipe or stopped swipe with finger down
    // on screen.
    
    if (touchEndTime-swipeEndTime < SWIPETIME_CUTOFF) {

        cancelDeceleration = NO;
        
        
        NSInteger framecount = 50;
        
        if ((float)swipeDistance/(touchEndTime-swipeStartTime) > 1500) {
            framecount = 100;
        }
        
        decelerationSteps = framecount;
        numberOfAnimationSteps = framecount;
        
        // Use last 'frameGap' wich is stored in dragDistance
        
        startFrameGap = dragDistance;
        actualframeGap = startFrameGap;
        
        
        
        if (decelerateAnimation) {
            
            if (delegate != nil && [delegate respondsToSelector:@selector(rotationViewDidStartDecelerating:)]) {
                [delegate rotationViewDidStartDecelerating:self];
            }
            
            [self invokeDeceleration];
        }

    }
    
}

#pragma mark -
#pragma mark Animation Timers

-(void)invokeDeceleration
{
    
    
    
    if (decelerationSteps <= 0 || cancelDeceleration) {
        cancelDeceleration = YES;
        decelerationTimer = nil;
        
        
        
        return;
    }
    
    // Fire timer to display new frame
    
    decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_FRAMERATE target:self selector:@selector(decellerateAnimation) userInfo:nil repeats:NO];
    
}


#pragma mark -
#pragma mark Private Methods

// Private Methods

-(void)invokeRotationAnimation
{
    
    // Cancel deceleration animation if active
    
    if ([decelerationTimer isValid]) {
        [decelerationTimer invalidate];
        decelerationTimer = nil;
    }
    
    isAnimating = YES;
    
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_FRAMERATE target:self selector:@selector(doAnimation) userInfo:nil repeats:NO];
}

-(void)displayImage
{
    imageView.image = [UIImage imageWithContentsOfFile:[imagePaths objectAtIndex:animationPosition]];
}

-(void)decellerateAnimation
{
    
    decelerationSteps--;
    
    animationPosition+=1*animationDirection*actualframeGap;
    
    
    [self checkForValidAnimationPosition];
    
    [self displayImage];
    
    // Calculate frame gap. (linear interpolation with formula: startFrameGap * (1 - remainingSteps/totalSteps )
    
    if (decelerationSteps!= 0) {
        actualframeGap = (NSInteger)(startFrameGap*(1-((float)numberOfAnimationSteps-(float)decelerationSteps)/(float)numberOfAnimationSteps));
        
    }
    
    // Stop animation if frameGap reaches 1 because
    // animation is over (interpolation finished)
    
    if (actualframeGap < 1) {
        
        cancelDeceleration = YES;
        
        if (decelerationTimer != nil) {
            if ([decelerationTimer isValid]) {
                [decelerationTimer invalidate];
                decelerationTimer = nil;
            }
        }
        
        if (delegate != nil && [delegate respondsToSelector:@selector(rotationViewDidStopDecelerating:)]) {
            [delegate rotationViewDidStopDecelerating:self];
        }
        
    }
    
    [self invokeDeceleration];
    
    
}

-(void)doAnimation
{
    
    animationPosition+=1*animationDirection*animationSpeed;
    
    [self checkForValidAnimationPosition];
    
    [self displayImage];
    
    [self invokeRotationAnimation];
}

-(void)checkForValidAnimationPosition
{
    if (animationPosition < 0) {
        
        animationPosition = ([imagePaths count]-1);
    }else if (animationPosition > ([imagePaths count]-1)) {
        
        animationPosition = 0;
    }
}

@end
