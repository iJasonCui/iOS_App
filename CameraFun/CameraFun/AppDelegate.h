//
//  AppDelegate.h
//  CameraFun
//
//  Created by Hoa Chen on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrintPhotoViewController;

//@interface AppDelegate : UIResponder <UIApplicationDelegate>
@interface AppDelegate : NSObject <UIApplicationDelegate>{
    UIWindow *window;
    PrintPhotoViewController *viewController;
}


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet PrintPhotoViewController *viewController;


@end
