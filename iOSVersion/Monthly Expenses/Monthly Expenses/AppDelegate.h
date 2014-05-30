//
//  AppDelegate.h
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    NSString                    *currencyString;
}
@property (strong, nonatomic) UIWindow *window;



- (void)setCurrencyString:(NSString*)newCurrency;
- (NSString*)currencyString;

-(void) regNotif:(Expense*)expense;
-(void)deleteNotif:(int)expenseID;
@end
