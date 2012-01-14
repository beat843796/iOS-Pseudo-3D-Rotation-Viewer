//
//  RVRotationViewerController.m
//  Rotation Viewer
//
//  Created by Clemens Hammerl on 13.01.12.
//  Copyright (c) 2012 appingo. All rights reserved.
//

#import "RVRotationViewerController.h"


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
