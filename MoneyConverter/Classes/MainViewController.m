//
//  MainViewController.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainViewController.h"
#import "RootViewController.h"
#import "MainView.h"

@implementation MainViewController
@synthesize rootController;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	}
	return self;
}



 - (void)viewDidLoad {
	 MainView *m = (MainView *)[self view];
	 [m didLoad];
	 [m release];
	 }



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return YES;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];  
}


- (void)dealloc {
	
	 
	[[self view] release];
	[super dealloc];

}


@end
