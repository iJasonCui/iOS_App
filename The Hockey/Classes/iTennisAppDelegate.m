//
//  iTennisAppDelegate.m
//  iTennis
//
//  Created by Reza Pekan on 10-07-21.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iTennisAppDelegate.h"
#import "iTennisViewController.h"

@implementation iTennisAppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	viewController = [[SplashViewController alloc] init];
    // Override point for customization after app launch    
    [window addSubview:[viewController view]];
	
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
