//
//  RootViewController.h
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface RootViewController : UIViewController {

	MainViewController *mainViewController;
	
	int whichViewActive;
}

@property (nonatomic, retain) MainViewController *mainViewController;


@end
