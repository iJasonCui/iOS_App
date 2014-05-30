//
//  Example.m
//  HelpfulUtilities
//
//  Created by P. Mark Anderson on 8/9/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//


#import "Example.h"

static Example *sharedInstance;


@implementation Example

@synthesize title, controllerClass;
////
@synthesize window=_window;
@synthesize tabBarController;

- (id)initWithTitle:(NSString *)newTitle 

     controllerClass:(NSString *)newControllerClass {
  self = [super init];
  if(nil != self) {
    self.title = newTitle;
    self.controllerClass = newControllerClass;
  }
    ////---------
    if (sharedInstance) {
        NSLog(@"Error: You are creating a second AppController");
    }
    [super init];
    sharedInstance = self;
    /////-------
    
  return self;
}

////
+ (Example *)sharedAppController
{
    return sharedInstance;
}



- (void) dealloc { 
  self.title = nil;
  self.controllerClass = nil;
  [super dealloc];
    
    ////
    [_window release];
    [tabBarController release];
}

@end
