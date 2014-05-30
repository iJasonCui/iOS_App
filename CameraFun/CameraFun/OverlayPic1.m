//
//  OverlayPic1.m
//  CameraFun
//
//  Created by Hoa Chen on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
 
#import "OverlayPic1.h"
#import "Example.h"
#import "RootViewController.h"

#ifdef BTL_INCLUDE_IMAGE_SHARING
#import "BTLImageShareController.h"
#endif

// horizontal onSwipe
#define HORIZ_SWIPE_DRAG_MIN 180
#define VERT_SWIPE_DRAG_MAX 100

// vertical onSwipe
#define HORIZ_SWIPE_DRAG_MAX 100
#define VERT_SWIPE_DRAG_MIN 250

#define OVERLAY_ALPHA 0.90f
#define BINOCS_TAG 99
#define BINOCS_BUTTON_TAG 100

@implementation OverlayPic1

@synthesize camera, cameraMode, overlayView, overlayLabel, startTouchPosition;

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)loadView { 
  	self.navigationController.navigationBarHidden = NO;
 	[UIApplication sharedApplication].statusBarHidden = NO;
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.overlayView.opaque = NO;
    self.overlayView.alpha = OVERLAY_ALPHA;
    
	UIImageView *binocs = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"obama.png"]] autorelease];
    
	binocs.tag = BINOCS_TAG;
    [self.overlayView addSubview:binocs]; 
    self.view = self.overlayView;
    
    self.navigationController.toolbarHidden = NO;
    
    //changing color of toolbar
    //UIToolbar *tb = self.navigationController.toolbar; tb.tintColor = [UIColor clearColor];
    
    // button inside toolbar at bottom 
    UIBarButtonItem *binocsButton;
    binocsButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Take Picture!"
                                                      style: UIBarButtonItemStyleBordered
                                                     target: self
                                                     action: @selector( gotoCamera: ) ];
    self.toolbarItems = [ NSArray arrayWithObject: binocsButton ];
    [ binocsButton release ];
    
}

//this skips go strait to camera
/*- (void) viewDidAppear:(BOOL)animated { 
 [self initCamera];
 [self startCamera];
 self.overlayLabel.text = @"Tap to take a picture.";	
 
 UIButton *binocsButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
 binocsButton.tag = BINOCS_BUTTON_TAG;
 [binocsButton setTitle:@"Binocs" forState:UIControlStateNormal];
 binocsButton.backgroundColor = [UIColor clearColor];
 binocsButton.frame = CGRectMake(10, 426, 100, 44);
 [binocsButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
 [self.overlayView addSubview:binocsButton];	
 }*/


- (void)gotoCamera:(id)sender {
    [self initCamera];
    [self startCamera];
    
}

- (void) initCamera {  
    if ([BTLFullScreenCameraController isAvailable]) {  
        
        NSLog(@"Initializing camera.");
        BTLFullScreenCameraController *tmpCamera = [[BTLFullScreenCameraController alloc] init];
        [tmpCamera.view setBackgroundColor:[UIColor blueColor]];
        [tmpCamera setCameraOverlayView:self.overlayView];
		tmpCamera.overlayController = self;
        
        
        
        
#ifdef BTL_INCLUDE_IMAGE_SHARING
		BTLImageShareController *shareController = [[BTLImageShareController alloc] init];
		shareController.delegate = self;
		[self.view addSubview:shareController.view];
		tmpCamera.shareController = shareController;		
#endif
        
        self.camera = tmpCamera;
        [tmpCamera release];
    } else {
        NSLog(@"Camera not available.");
    }
}

- (void)startCamera {
    [self.camera displayModalWithController:self animated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // if landscape, put in camera mode
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft: 
        case UIInterfaceOrientationLandscapeRight: 
            [self toggleAugmentedReality];
        default:
            
            break;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)toggleAugmentedReality {
    if ([BTLFullScreenCameraController isAvailable]) {  
        self.cameraMode = !self.cameraMode;
        if (self.cameraMode == YES) {
            NSLog(@"Setting view to camera");
            if (!self.camera) { [self initCamera]; }
            
            [self startCamera];
            
        } else {
            NSLog(@"Setting view to overlay");
            [self.camera dismissModalViewControllerAnimated:YES];
            self.camera = nil;
        }    
        
        [self.overlayView becomeFirstResponder];
    } else {
        NSLog(@"Unable to activate camera");
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
}

#pragma mark 
#pragma mark Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];
	self.startTouchPosition = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 1) {
		[self onSingleTap:touch];
	} else if ([touch tapCount] == 2) {
		[self onDoubleTap:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.view];
    
	// If the onSwipe tracks correctly.
	if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		if (startTouchPosition.x < currentTouchPosition.x) {
			[self onSwipeRight];
		} else {
			[self onSwipeLeft];
		}
		self.startTouchPosition = currentTouchPosition;
        
	} else if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= VERT_SWIPE_DRAG_MIN &&
               fabsf(startTouchPosition.x - currentTouchPosition.x) <= HORIZ_SWIPE_DRAG_MAX)
    {
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		if (startTouchPosition.y < currentTouchPosition.y) {
			[self onSwipeDown];
		} else {
			[self onSwipeUp];
		}
		self.startTouchPosition = currentTouchPosition;  
        
    } else {
		// Process a non-swipe event.
	}
}

-(void)onSingleTap:(UITouch*)touch {
	NSLog(@"onSingleTap");
	[camera takePicture];
}

-(void)onDoubleTap:(UITouch*)touch {
	NSLog(@"onDoubleTap");
}

- (void)onSwipeUp {
	NSLog(@"onSwipeUp");
}

- (void)onSwipeDown {
	NSLog(@"onSwipeDown");
}

- (void)onSwipeLeft {
	NSLog(@"onSwipeLeft");
}

- (void)onSwipeRight {
	NSLog(@"onSwipeRight");
}


- (void)thumbnailTapped:(id)sender {
	self.view.alpha = 1.0f;
	UIButton *binocsButton = (UIButton*)[self.view viewWithTag:BINOCS_BUTTON_TAG];
	binocsButton.hidden = YES;
}

- (void)previewClosed:(id)sender {
	self.view.alpha = OVERLAY_ALPHA;
	UIButton *binocsButton = (UIButton*)[self.view viewWithTag:BINOCS_BUTTON_TAG];
	binocsButton.hidden = NO;
}

- (void)cameraWillTakePicture:(id)sender {
	UIButton *binocsButton = (UIButton*)[self.view viewWithTag:BINOCS_BUTTON_TAG];
	binocsButton.hidden = YES;
	self.overlayLabel.hidden = YES;
}

- (void)cameraDidTakePicture:(id)sender {
	UIButton *binocsButton = (UIButton*)[self.view viewWithTag:BINOCS_BUTTON_TAG];
	binocsButton.hidden = NO;
	self.overlayLabel.hidden = NO;
}

- (void)dealloc {
    [overlayView release];
    [overlayLabel release];
    [camera release];
    [super dealloc];
}
@end
