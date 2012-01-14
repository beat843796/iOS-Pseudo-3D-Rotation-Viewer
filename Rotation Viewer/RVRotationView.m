//
//  RVRotationView.m
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVRotationView.h"
#import "PSFileManager.h"

@interface RVRotationView (private) {
@private
    
}

-(void)displayImage;

-(void)decellerateAnimation;
-(void)invokeDeceleration;

@end

@implementation RVRotationView

@synthesize imageView;
@synthesize  imagePaths;
@synthesize dragSensitivity;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        dragSenitivity = 0.15; // default
        
        self.backgroundColor = [UIColor grayColor];
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        [imageView release];
        
    }
    return self;
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    imageView.frame = self.bounds;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    cancelDeceleration = YES;
    
    if (decelerationTimer != nil) {
        if ([decelerationTimer isValid]) {
            [decelerationTimer invalidate];
            decelerationTimer = nil;
        }
    }
    
    
    NSLog(@"touches began");
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    touchStart = touchPoint;
    dragStart = touchPoint;
    
    dragStartTime = [[NSDate date] timeIntervalSince1970];
    swipeStartTime = [[NSDate date] timeIntervalSince1970];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    
    dragDistance = abs(touchPoint.x-touchStart.x);
    
    dragDistance*=dragSenitivity;
    
    if (dragDistance == 0) {
        dragDistance = 1;
    }
    
    NSLog(@"%i",dragDistance);
    
    if (touchPoint.x > touchStart.x) {
        animationDirection = 1;
        animationPosition+=dragDistance;
        
    }else if(touchPoint.x < touchStart.x) {
        animationDirection = -1;
        animationPosition-=dragDistance;
    }
    
   
    if (animationPosition < 0) {

        animationPosition = ([imagePaths count]-1);
    }else if (animationPosition > ([imagePaths count]-1)) {

        animationPosition = 0;
    }
    

    [self displayImage];
    
    
    
    touchStart = touchPoint;
    
    dragEndTime = [[NSDate date] timeIntervalSince1970];
    
    if (dragEndTime-dragStartTime>0.2) {
        
        NSLog(@"Reset drag!!!!!");
        swipeStartTime= [[NSDate date] timeIntervalSince1970];
        dragStart = touchPoint;
    }
    
    dragStartTime = dragEndTime;
    
      
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches ended");
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    NSInteger swipeDistance = abs(dragStart.x-touchPoint.x);
    
    NSLog(@"dragDistance: %i",swipeDistance);
    
    NSTimeInterval touchEndTime = [[NSDate date] timeIntervalSince1970];
    
    
    NSLog(@"Swipe Duration %f", touchEndTime-swipeStartTime);
    
    NSLog(@"Velocity: %.1f", (float)swipeDistance/(touchEndTime-swipeStartTime));
    
    
    if (touchEndTime-dragEndTime < 0.05f) {
        NSLog(@"decellerate");
        cancelDeceleration = NO;
        
        
        NSInteger speed = 50;
        
        
        if ((float)swipeDistance/(touchEndTime-swipeStartTime) > 1500) {
            speed = 100;
        }
        
        
        
               
        //decelerationSteps = dragDistance*0.5f;
        decelerationSteps = speed;
        numberOfAnimationSteps = speed;
        startFrameGap = dragDistance;
        actualframeGap = startFrameGap;
        [self invokeDeceleration];
        
        NSLog(@"StartGap: %f  ActualGap: %f NumberOfAnimationSteps: %i",startFrameGap,actualframeGap,numberOfAnimationSteps);
        
    }
    
}

-(void)invokeDeceleration
{
    
    if (decelerationSteps <= 0 || cancelDeceleration) {
        cancelDeceleration = YES;
        decelerationTimer = nil;
        return;
        NSLog(@"End of animation");
    }
    
    decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(decellerateAnimation) userInfo:nil repeats:NO];
    
}



-(void)decellerateAnimation
{
    
    //NSLog(@"Started deceleration ");
    
    decelerationSteps--;
    
              
    animationPosition+=1*animationDirection*actualframeGap;
        

        if (animationPosition < 0) {
            
            animationPosition = ([imagePaths count]-1);
        }else if (animationPosition > ([imagePaths count]-1)) {
            
            animationPosition = 0;
        }
        
        
        [self displayImage];

    if (decelerationSteps!= 0) {
        actualframeGap = (NSInteger)(startFrameGap*(1-((float)numberOfAnimationSteps-(float)decelerationSteps)/(float)numberOfAnimationSteps));
        
    }
    
    
    
    if (actualframeGap < 1) {
        cancelDeceleration = YES;
        
        if (decelerationTimer != nil) {
            if ([decelerationTimer isValid]) {
                [decelerationTimer invalidate];
                decelerationTimer = nil;
            }
        }
    }
    //NSLog(@">>> %i",animationPosition);
    //NSLog(@"Ended frame");
    
    [self invokeDeceleration];
    
    
}

-(void)loadAnimationFromDirectory:(NSString *)animationDirectory
{
    
    NSFileManager *fileman = [[NSFileManager alloc] init];
    
    
    NSArray *directoryContent = [fileman contentsOfDirectoryAtPath:animationDirectory error:nil];
    self.imagePaths = [[NSMutableArray alloc] initWithCapacity:[directoryContent count]];
    
    for (NSString *image in directoryContent) {
        
        [imagePaths addObject:[animationDirectory stringByAppendingPathComponent:image]];
        
    }
    NSLog(@"Images:\n%@",imagePaths);
    [fileman release];
    
    if (imagePaths != nil && [imagePaths count] > 0) {
        
        imageView.image = [UIImage imageWithContentsOfFile:[imagePaths objectAtIndex:0]];
        animationPosition = 0;
    }
    
}

-(void)dealloc
{
    [imagePaths release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Private Methods

// Private Methods

-(void)displayImage
{
    //NSLog(@"Displaying Image %i",animationPosition);
    imageView.image = [UIImage imageWithContentsOfFile:[imagePaths objectAtIndex:animationPosition]];
    
}











@end
