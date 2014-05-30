//
//  RootViewController.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "MainView.h"


@implementation RootViewController


@synthesize mainViewController;
 

- (void)viewDidLoad {
	whichViewActive = 0;
	
	UIApplication *app = [UIApplication sharedApplication];
	[app setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	
	MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = viewController;
	[viewController release];
	
	[mainViewController setRootController: self];
	
	

	[self.view addSubview: mainViewController.view];
	
	
}






	
	
	


extern BOOL mayRotate;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return mayRotate;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; 
}


- (void)dealloc 
{
		
	
	
 	[mainViewController release];
 	[super dealloc];
}


@end
