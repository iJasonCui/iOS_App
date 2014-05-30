

#import "Home.h"
#import "FTAnimation.h"



@implementation Home

@synthesize textView;
@synthesize myImage;
@synthesize button;
@synthesize myView;
@synthesize viewToAnimate = viewToAnimate_;
@synthesize performAnimationButton = performAnimationButton_;
@synthesize directionControl = directionControl_;
@synthesize uiViewToAnimate = uiViewToAnimate_;
@synthesize uiTextViewToAnimate = uiTextViewToAnimate_;



- (IBAction)performAnimation {
	
	//this animates a UIImageView type
	if(self.viewToAnimate.hidden) {
		[self.viewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.viewToAnimate.superview withFade:NO duration:5 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.viewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.viewToAnimate.superview withFade:NO duration:5 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	//this animates a UIView type
	if(self.uiViewToAnimate.hidden) {
		[self.uiViewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.uiViewToAnimate.superview withFade:NO duration:5 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.uiViewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.uiViewToAnimate.superview withFade:NO duration:5 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	//this animates a UITextView type
	if(self.uiTextViewToAnimate.hidden) {
		[self.uiTextViewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.uiTextViewToAnimate.superview withFade:NO duration:5 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.uiTextViewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.uiTextViewToAnimate.superview withFade:NO duration:5 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	
}


- (void)viewDidLoad {
	
NSArray *directionItems = [NSArray arrayWithObjects:@"T", @"R", @"B", @"L", @"TL", @"TR", @"BL", @"BR", nil];
 self.directionControl = [[[UISegmentedControl alloc] initWithItems:directionItems] autorelease];
	self.directionControl.selectedSegmentIndex = 0;
 self.directionControl.frame = CGRectMake(10., 300., 300., 44.);
	
	self.directionControl.hidden = YES;
	[self.view addSubview:self.directionControl];
	[super viewDidLoad];


	UIImage *image = [UIImage imageNamed:@"down24White.png"];
	
	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
									 initWithImage:image
									 style:UIBarButtonItemStyleBordered
									 target:self
									 action:@selector(arrowUpAction)];
	

	
	self.navigationItem.rightBarButtonItem = deleteButton;
	
	[deleteButton release];
 
}

- (void) arrowUpAction
{
	//this animates a UIImageView type bring grey shade down
	if(self.viewToAnimate.hidden) {
		[self.viewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.viewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.viewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.viewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	//this animates a UIView type
	if(self.uiViewToAnimate.hidden) {
		[self.uiViewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.uiViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.uiViewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.uiViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	//this animates a UITextView type
	if(self.uiTextViewToAnimate.hidden) {
		[self.uiTextViewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.uiTextViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.uiTextViewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.uiTextViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	
	UIImage *image = [UIImage imageNamed:@"up24White.png"];
	
	// create a standard delete button with the trash icon
	UIBarButtonItem *newButton = [[UIBarButtonItem alloc]
								  //initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
								  initWithImage:image
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(arrowDownAction)];
	
	
	// place the barButton into the navigation bar
	self.navigationItem.rightBarButtonItem = newButton;
	[newButton release];
	
}

- (void) arrowDownAction
{
	//this animates a UIImageView type
	if(self.viewToAnimate.hidden) {
		[self.viewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.viewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.viewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.viewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	//this animates a UIView type lift grey shade up
	if(self.uiViewToAnimate.hidden) {
		[self.uiViewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.uiViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.uiViewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.uiViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	//this animates a UITextView type
	if(self.uiTextViewToAnimate.hidden) {
		[self.uiTextViewToAnimate backInFrom:self.directionControl.selectedSegmentIndex inView:self.uiTextViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];
	} else {
		[self.uiTextViewToAnimate backOutTo:self.directionControl.selectedSegmentIndex inView:self.uiTextViewToAnimate.superview withFade:NO duration:0.4 delegate:nil startSelector:nil stopSelector:nil];		
	}
	
	
	//UIImage *image = [UIImage imageNamed:@"downArrowWhite.png"];
	UIImage *image = [UIImage imageNamed:@"down24White.png"];
	
	// create a standard delete button with the trash icon
	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
									 //initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
									 initWithImage:image
									 style:UIBarButtonItemStyleBordered
									 target:self
									 action:@selector(arrowUpAction)];
	
	// place the barButton into the navigation bar
	self.navigationItem.rightBarButtonItem = deleteButton;
	[deleteButton release];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];

}


- (void)dealloc {
    [super dealloc];
    [textView release];
    [myImage release];
    [button release];
    [myView release];
    [viewToAnimate_ release];
    [performAnimationButton_ release];
    [directionControl_ release];
    [uiViewToAnimate_ release];
    [uiTextViewToAnimate_ release];
    [btn1 release];
	[btn2 release];
    [BarContainerView release];

}


@end
