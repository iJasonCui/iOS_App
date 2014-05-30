//
//  Options.m
//  iTennis
//
//  Created by Reza Pekan on 10-07-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Options.h"
#import "options1.h"
#import "options2.h"
#import "options3.h"
#import "options4.h"


@implementation Options


- (IBAction)infoButtonPressed:(id)sender;
{
	options1 *second = [[options1 alloc] initWithNibName:nil bundle:nil];
	
	second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:second animated:YES];
	
	[second release];
}

- (IBAction)infoButtonPressed1:(id)sender;
{
	options2 *second = [[options2 alloc] initWithNibName:nil bundle:nil];
	
	second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:second animated:YES];
	
	[second release];
}


- (IBAction)infoButtonPressed2:(id)sender;
{
	options3 *second = [[options3 alloc] initWithNibName:nil bundle:nil];
	
	second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:second animated:YES];
	
	[second release];
}

- (IBAction)infoButtonPressed3:(id)sender;
{
	options4 *second = [[options4 alloc] initWithNibName:nil bundle:nil];
	
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

-(IBAction)alertMe {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Themes Section" message:@"Hello and welcome to the Themes Section, you can choose which layout you want to play with, and from there you can choose to play in Easy, Medium, Hard mode! " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}


@end
