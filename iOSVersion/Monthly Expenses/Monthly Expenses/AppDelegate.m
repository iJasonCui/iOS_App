//
//  AppDelegate.m
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    
    if (currencyString != nil)
    {
        [currencyString release];   
        currencyString = nil;
    }
    
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Database Loading;
    if (![[DBManager sharedManager] isExistDB])
    {
        if (![[DBManager sharedManager] createDB])
            exit(-1);
    }
    
    
    currencyString = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrencyString"];
    
    if (currencyString)
    {
        [currencyString retain];
    }
    else
    {
        NSLocale *currentLocale = [NSLocale currentLocale];
        currencyString = [[currentLocale objectForKey:NSLocaleCurrencySymbol] retain];
        
        [[NSUserDefaults standardUserDefaults] setObject:currencyString forKey:@"CurrencyString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UITabBarController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        
        UITabBarController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
  
//    [_mainView updateCurrency];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void)setCurrencyString:(NSString*)newCurrency
{
    [currencyString release];
    currencyString = [newCurrency retain];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:currencyString forKey:@"CurrencyString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)currencyString
{
    return currencyString;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    if (application.applicationState == UIApplicationStateActive)
    {
        NSBundle *bundle = [NSBundle mainBundle];
        NSDictionary *info = [bundle infoDictionary];
        NSString *appName = [info objectForKey:@"CFBundleDisplayName"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) regNotif:(Expense*)expense
{
        
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fireDate = [dateformatter dateFromString:[expense date]];
    [dateformatter release];
    
    localNotif.fireDate = fireDate;
    localNotif.alertBody = [NSString stringWithFormat:@"You have to pay for %@ today!", [expense name]];
    
    // Set the action button
    localNotif.alertAction = @"OK";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    // Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[expense expenseID]] forKey:@"EXPENSE_ID"];
    localNotif.userInfo = infoDict;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}

-(void)deleteNotif:(int)expenseID
{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for(int i = 0; i < [notificationArray count]; i++)
    {
        UILocalNotification *notif = [notificationArray objectAtIndex:i];
        NSDictionary *userInfo = notif.userInfo;
        NSNumber *number = [userInfo valueForKey:@"EXPENSE_ID"];
        if (expenseID == [number intValue])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notif];
            return;
    
        }
    }
}

@end
