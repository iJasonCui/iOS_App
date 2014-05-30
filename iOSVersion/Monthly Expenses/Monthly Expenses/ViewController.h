//
//  ViewController.h
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kal.h"
#import "Month.h"

@interface ViewController : UIViewController < KalViewDelegate >
{
    KalLogic        *logic;
    KalView         *kalView;
    NSDate          *selectedDate;
    Month           *m_curMonth;
    
    IBOutlet UILabel    *lblBudget;
    IBOutlet UILabel    *lblSpent;
    IBOutlet UILabel    *lblBalance;

    
}

- (void)setSelectedDate:(NSDate*)date;
- (NSDate*)selectedDate;

- (void)updateMoneyPresentation;
@end
