//
//  ExpensesViewController.h
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Month.h"
#import "Expense.h"

@interface ExpensesViewController : UIViewController < UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate >
{
    NSDate  *m_curDate;
    Month   *m_curMonth;
    NSArray     *m_curExpenses;
    
    IBOutlet UILabel        *lblDayName;
    IBOutlet UIButton       *btnCurrency;
    IBOutlet UITextField    *txtBudget;
    
    IBOutlet UIScrollView   *scrvDays;
    
    IBOutlet UILabel        *lblMonthSpentMark;
    IBOutlet UILabel        *lblBalanceMark;
    IBOutlet UILabel        *lblMonthSpent;
    IBOutlet UILabel        *lblBalance;
    IBOutlet UILabel        *lblDaySpent;
    
    IBOutlet UITableView    *tblExpenses;
    
    int     m_nSelectedIndex;
    
    UIPickerView    *currencyPicker;
    UIActionSheet   *dataSheet;
    UIPopoverController *popoverController;
    
    UITableView     *tblCurrentySymbol;
    int             m_nSelectedCurrencyIndex;
    
    NSArray         *aryCurrencySymbol;
}

- (void)setCurDate:(NSDate*)date;
- (NSDate*)curDate;

- (void)updateDayName;
- (void)makeDayButtons;
- (void)updateMoneyPresentation;
- (void)updateCurrency;

- (void)finishCurrencyPicker;
- (void)calcelCurrencyPicker;
#pragma mark - Button Actions

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnReport:(id)sender;
- (IBAction)onBtnCurrency:(id)sender;
- (IBAction)onBtnAdd:(id)sender;

- (void)onBtnDay:(id)sender;

- (IBAction)onBtnEdit:(id)sender;
- (IBAction)onBtnDelete:(id)sender;
@end
