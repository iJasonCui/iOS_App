//
//  ForexAppDelegate.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "ForexAppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "MainView.h"

@implementation ForexAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
		
	
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	MainViewController *mvc = [rootViewController mainViewController];
	MainView *mv = (MainView *)[mvc view];
	
	[mv saveCalcList];
	[mv release];
	
	[rootViewController release];

	}

- (void)dealloc 
{
		
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
