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
    
    rotationView = [[RVRotationView alloc] initWithFrame:CGRectZero];
    
    self.view = rotationView;
    
    [rotationView loadAnimationFromDirectory:self.imageDirectory];
    
    
    rotateLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotateLeftButton addTarget:self action:@selector(pressedRotateLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [rotateLeftButton setTitle:@"<<" forState:UIControlStateNormal];
    rotateLeftButton.frame = CGRectMake(10, 10, 60, 40);
    [self.view addSubview:rotateLeftButton];
    
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton addTarget:self action:@selector(pressedStartButton) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"Play" forState:UIControlStateNormal];
    startButton.frame = CGRectMake(80, 10, 60, 40);
    [self.view addSubview:startButton];
    
    stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopButton addTarget:self action:@selector(pressedEndButton) forControlEvents:UIControlEventTouchUpInside];
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    stopButton.frame = CGRectMake(150, 10, 60, 40);
    [self.view addSubview:stopButton];
    
    rotateRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotateRightButton addTarget:self action:@selector(pressedRotateRightButton) forControlEvents:UIControlEventTouchUpInside];
    [rotateRightButton setTitle:@">>" forState:UIControlStateNormal];
    rotateRightButton.frame = CGRectMake(220, 10, 60, 40);
    [self.view addSubview:rotateRightButton];
    
    rotationSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 55, 270, 30)];
    [rotationSpeedSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    rotationSpeedSlider.minimumValue = 1;
    rotationSpeedSlider.maximumValue = 30;
    rotationSpeedSlider.value = 15;
    [self.view addSubview:rotationSpeedSlider];
    [rotationSpeedSlider release];
    
    
}

-(void)pressedStartButton
{
    NSLog(@"Pressed Start");
}

-(void)pressedEndButton
{
    NSLog(@"Pressed End");
}

-(void)pressedRotateLeftButton
{
    NSLog(@"Pressed Rotate Left");
}

-(void)pressedRotateRightButton
{
    NSLog(@"Pressed Rotate Right");
}

-(void)sliderValueChanged:(id)sender
{
    NSLog(@"Slider Value %i",(int)((UISlider *)sender).value);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
