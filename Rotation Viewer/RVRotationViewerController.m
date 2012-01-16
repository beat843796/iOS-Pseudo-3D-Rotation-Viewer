//
//  RVRotationViewerController.m
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 appingo. All rights reserved.
//

#import "RVRotationViewerController.h"


@interface RVRotationViewerController (private) 

-(void)pressedStartButton;
-(void)pressedEndButton;
-(void)pressedRotateLeftButton;
-(void)pressedRotateRightButton;
-(void)sliderValueChanged:(id)sender;
-(void)decelerationSwitchChanges:(id)sender;

@end

@implementation RVRotationViewerController
@synthesize imageDirectory;


-(id)init
{
    self = [super init];
    
    if (self) {
        
        // init code
        
        
        
    }
    
    return self;
}

-(id)initWithImageDirecotry:(NSString *)directoryName
{
    
    self = [self init];
    
    if (self) {
        
        if (directoryName != nil) {
            
            self.imageDirectory = directoryName;
            
            
            
        }else
        {
            NSLog(@"Error: Directory Name must not be nil.");
        }
        
    }
    
    return self;
}

-(void)reloadImages
{
    
    
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    rotationView = [[RVRotationView alloc] initWithFrame:self.view.bounds];
    
    rotationView.delegate = self;
    
    [rotationView loadAnimationFromDirectory:self.imageDirectory];

    self.view = rotationView;
    
    //[rotationView displayImageWithPosition:0];
    
    
    rotateLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotateLeftButton addTarget:self action:@selector(pressedRotateLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [rotateLeftButton setTitle:@"<<" forState:UIControlStateNormal];
    rotateLeftButton.frame = CGRectMake(5, 5, 50, 40);
    [self.view addSubview:rotateLeftButton];
    
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton addTarget:self action:@selector(pressedStartButton) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"Play" forState:UIControlStateNormal];
    startButton.frame = CGRectMake(60, 5, 50, 40);
    [self.view addSubview:startButton];
    
    stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopButton addTarget:self action:@selector(pressedEndButton) forControlEvents:UIControlEventTouchUpInside];
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    stopButton.frame = CGRectMake(115, 5, 50, 40);
    [self.view addSubview:stopButton];
    
    rotateRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotateRightButton addTarget:self action:@selector(pressedRotateRightButton) forControlEvents:UIControlEventTouchUpInside];
    [rotateRightButton setTitle:@">>" forState:UIControlStateNormal];
    rotateRightButton.frame = CGRectMake(170, 5, 50, 40);
    [self.view addSubview:rotateRightButton];
    
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 60, 13)];
    decLabel.textAlignment = UITextAlignmentCenter;
    decLabel.textColor = [UIColor lightGrayColor];
    decLabel.backgroundColor = [UIColor clearColor];
    decLabel.text = @"Decelerate";
    decLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:decLabel];
    [decLabel release];
    
    
    
    UISwitch *decelerationSwith = [[UISwitch alloc] initWithFrame:CGRectMake(220, 18, 76, 40)];
    [decelerationSwith addTarget:self action:@selector(decelerationSwitchChanges:) forControlEvents:UIControlEventValueChanged];
    decelerationSwith.on = YES;
    [self.view addSubview:decelerationSwith];
    [decelerationSwith release];
    
    rotationSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(5, 50, 230, 30)];
    [rotationSpeedSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    rotationSpeedSlider.minimumValue = 1;
    rotationSpeedSlider.maximumValue = 20;
    rotationSpeedSlider.value = 10;
    [self.view addSubview:rotationSpeedSlider];
    [rotationSpeedSlider release];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

-(void)decelerationSwitchChanges:(id)sender
{
    
    NSLog(@"switch changes to %i", ((UISwitch *)sender).on);
    
    rotationView.decelerateAnimation = ((UISwitch *)sender).on;
}

-(void)pressedStartButton
{
    NSLog(@"Pressed Start");
    
    [rotationView startRotationAnimationWithDirection:RVRotationViewDirectionRight];
}

-(void)pressedEndButton
{
    NSLog(@"Pressed End");
    
    [rotationView stopRotationAnimation];
}

-(void)pressedRotateLeftButton
{
    NSLog(@"Pressed Rotate Left");
    
    [rotationView rotateLeft];
    
    if (rotationView.isAnimating) {
        rotationView.animationDirection = RVRotationViewDirectionLeft;
        
    }
}

-(void)pressedRotateRightButton
{
    NSLog(@"Pressed Rotate Right");
    
    [rotationView rotateRight];
    
    if (rotationView.isAnimating) {
        rotationView.animationDirection = RVRotationViewDirectionRight;
    }
}

-(void)sliderValueChanged:(id)sender
{
    NSLog(@"Slider Value %i",(int)((UISlider *)sender).value);
    
    rotationView.animationSpeed = (int)((UISlider *)sender).value;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)rotationViewDidStartDecelerating:(RVRotationView *)rotationView
{
    NSLog(@"Rotation View did start decelerating");
}

-(void)rotationViewDidStopDecelerating:(RVRotationView *)rotationView
{
    NSLog(@"Rotation View did stop decelerating");
}

-(void)rotationViewDidStartAnimating:(RVRotationView *)rotationView
{
    NSLog(@"Rotation View did start animating");
}

-(void)rotationViewDidStopAnimating:(RVRotationView *)rotationView
{
    NSLog(@"Rotation View did stop animating");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
