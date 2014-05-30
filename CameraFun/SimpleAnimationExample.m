
#import "SimpleAnimationExample.h"
#import <QuartzCore/QuartzCore.h>

@implementation SimpleAnimationExample

@synthesize viewToAnimate = viewToAnimate_;
@synthesize performAnimationButton = performAnimationButton_;
@synthesize directionControl = directionControl_;

@synthesize uiViewToAnimate = uiViewToAnimate_;
@synthesize uiTextViewToAnimate = uiTextViewToAnimate_;


+ (NSString *)displayName {
  return @"";
}

#pragma mark init and dealloc



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title = [[self class] displayName];
	}
	return self;
}

- (void)dealloc {
  self.viewToAnimate = nil;
  self.performAnimationButton = nil;
  self.directionControl = nil;
  [super dealloc];
}

- (void)setHasDirectionControl:(BOOL)hasDirection {
  if(hasDirection && (self.directionControl.superview == nil)) {
    [self.view insertSubview:self.directionControl belowSubview:self.viewToAnimate];
  } else if(!hasDirection && self.directionControl.superview != nil){
    [self.directionControl removeFromSuperview];
  }
}

- (BOOL)hasDirectionControl {
  return (self.directionControl.superview != nil);
}

#pragma mark Load and unload the view

- (void)loadView {
	
	//this is the checkered background that you see
  self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Checkers.png"]];;
  
	//this is the image box that moves in ant out
  self.viewToAnimate = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewBackground.png"]] autorelease];
  self.viewToAnimate.opaque = NO;
  self.viewToAnimate.backgroundColor = [UIColor clearColor];
  self.viewToAnimate.frame = CGRectMake(20., 10., 280., 280.);
  
	
	//this is the "Run Animation" button programatically
  self.performAnimationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.performAnimationButton.frame = CGRectMake(10., 356., 300., 44.);
  [self.performAnimationButton setTitle:@"Run Animation" forState:UIControlStateNormal];
  [self.performAnimationButton addTarget:self action:@selector(performAnimation:) forControlEvents:UIControlEventTouchUpInside];
  
	
	//this is the segmented controll programatically
  NSArray *directionItems = [NSArray arrayWithObjects:@"T", @"R", @"B", @"L", @"TL", @"TR", @"BL", @"BR", nil];
  self.directionControl = [[[UISegmentedControl alloc] initWithItems:directionItems] autorelease];
  self.directionControl.selectedSegmentIndex = 0;
  self.directionControl.frame = CGRectMake(10., 300., 300., 44.);
  
  [self.view addSubview:self.performAnimationButton];
  [self.view addSubview:self.viewToAnimate];
	 
}


#pragma mark Event Handling

//this is what happens when you pushed the "Run Animation" button
- (void)performAnimation:(id)sender {
  NSAssert(NO, @"performAnimation: must be overridden by subclasses");
}

@end


