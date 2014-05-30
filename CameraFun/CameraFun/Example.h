//
//  Example.h
//  ExampleEditor
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//


@interface Example : NSObject {
  NSString *title;
  NSString *controllerClass;
    
    ////
    UITabBarController *tabBarController;

}

////// Class methods for convenience
+ (Example *)sharedAppController;




- (id)initWithTitle:(NSString *)newTitle 
            controllerClass:(NSString *)newControllerClass;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *controllerClass;

//////// *** Properties
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;


@end