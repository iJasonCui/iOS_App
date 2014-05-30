//
//  DetailViewController.m
//  Currency
//
//  Created by jrk on 17.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "DetailViewController.h"
#import "Reachability.h"

@implementation DetailViewController
@synthesize objectToShowHistory;
@synthesize callingView;
@synthesize backButton;
@synthesize chartImageView;
 

NSString *getLastCachedImageFilenameForObject (ForexDataObject *objectToShowHistory, NSTimeInterval intvl)
{

	
	
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:-intvl];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat: @"_d_M_Y"];
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
	

	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
		return filename;
	else
	{	
		intvl += secondsPerDay;
		
		if (intvl > 24*60*60*5)
			return [NSString string];
		
		return getLastCachedImageFilenameForObject(objectToShowHistory,intvl);
		
	}
	
}
- (void) loadChart
{
	
	
	
	NSDate	*today = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];

	[formatter setDateFormat: @"_d_M_Y"];	
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
	
 	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
	{
		 		
		NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
 		
		[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
		
		
		return;
	}
	
	
	[[Reachability sharedReachability] setHostName:@"ichart.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
	
	if (internetConnectionStatus == NotReachable)
	{	
 		
		NSString *filename = getLastCachedImageFilenameForObject(objectToShowHistory, 0);
 		if (filename && ![filename isEqualToString:[NSString string]])
		{	
			NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
			[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
			return;
		}
		else
		{	
			NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><h2>You're offline!<p>There was also<p> no cached chart found!<p> Please connect<p>to the internet!</h2></center></body></html>",filename];
			[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];

			return;
		}
		
		return;
	}
	else
	{
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ichart.finance.yahoo.com/3m?%@%@=x",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]]]];
 		NSData *d = UIImagePNGRepresentation(img);
		
		
		NSDate *today = [NSDate date];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
 		[formatter setDateFormat: @"_d_M_Y"];
		filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
		
 		[d writeToFile:filename atomically: NO];
		
		 
	}
	
 	
	NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
 	
	[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
	
	
	
}
 - (void)viewDidLoad 
{
    [super viewDidLoad];
	[[self navigationItem] setRightBarButtonItem:[self backButton] animated: NO];
	
	[chartImageView setOpaque: NO];
	[chartImageView setBackgroundColor: [UIColor clearColor]];
	[chartImageView setAlpha: 1.0f];
	[chartImageView setScalesPageToFit: YES];
	[chartImageView setDetectsPhoneNumbers: NO];
	[self loadChart];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);

 	return YES;
}

- (void) handleOrientationDidChange: (NSNotification *) notification
{
	

	 
}

- (void)viewWillAppear:(BOOL)animated
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handleOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
	
	[[self view] setNeedsDisplay];
	 
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		
	
		NSLog(@"will appear! %i", [[UIDevice currentDevice] orientation]);
 		CGRect r = [[[self view] superview] frame];
		[[self view] setFrame: CGRectMake(0, 0, 480, 320)];
		[[self view] setNeedsDisplay];
	
		r = [chartImageView frame];
		
		 
	}

 	[self setTitle: [NSString stringWithFormat:@"Chart: %@/%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]];
	

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];  
}


- (void)dealloc {
     [super dealloc];
}

- (IBAction) goBack: (id) sender
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver: self];
	
	CGRect r = [[self view] frame];
	
	NSLog(@"%f,%f,%f,%f",r.origin.x,r.origin.y,r.size.width,r.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: [[self view] superview] cache:YES];
	
	 
	[UIView commitAnimations];

	[[self view] removeFromSuperview];
	
	[self release];
	
}


@end
