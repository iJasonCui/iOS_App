//
//  options3.m
//  iTennis
//
//  Created by Reza Pekan on 10-07-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "options3.h"
#import "easy3.h"
#import "medium3.h"
#import "hard3.h"

@implementation options3

- (IBAction)infoButtonPressed1:(id)sender;
{
	easy3 *second = [[easy3 alloc] initWithNibName:nil bundle:nil];
	
	second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:second animated:YES];
	
	[second release];
}


- (IBAction)infoButtonPressed2:(id)sender;
{
	medium3 *second = [[medium3 alloc] initWithNibName:nil bundle:nil];
	
	second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:second animated:YES];
	
	[second release];
}

- (IBAction)infoButtonPressed3:(id)sender;
{
	hard3 *second = [[hard3 alloc] initWithNibName:nil bundle:nil];
	
	second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:second animated:YES];
	
	[second release];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)done {
	[self dismissModalViewControllerAnimated:YES];
}

@end
