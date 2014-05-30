//
//  iTennisAppDelegate.h
//  iTennis
//
//  Created by Reza Pekan on 10-07-21.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

@class iTennisViewController;

@interface iTennisAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SplashViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iTennisViewController *viewController;

@end

