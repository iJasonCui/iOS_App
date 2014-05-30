//
//  InputViewController.h
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"
#import "Expense.h"

@interface InputViewController : UIViewController < UITextFieldDelegate, UIAlertViewDelegate >
{
    IBOutlet UITextField        *txtExpenseName;
    IBOutlet UITextField        *txtPrice;
    IBOutlet UITextField        *txtCategory;
    
    IBOutlet UIButton           *btnNormal;
    IBOutlet UIButton           *btnBill;

    IBOutlet UILabel            *lblPaid;
    IBOutlet DCRoundSwitch      *swtPaid;
    
    IBOutlet UIButton           *btnCash;
    IBOutlet UIButton           *btnCheck;
    
    IBOutlet UILabel            *lblCheckNumber;
    IBOutlet UITextField        *txtCheckNumber;
    
    Expense     *m_expense;
}

- (void)setExpense:(Expense*)expense;
- (Expense*)expense;

#pragma mark - Button Actions
- (IBAction)onBtnCategoryList:(id)sender;
- (IBAction)onBtnNormal:(id)sender;
- (IBAction)onBtnBill:(id)sender;
- (IBAction)onBtnCash:(id)sender;
- (IBAction)onBtnCheck:(id)sender;
- (IBAction)onSwitchPaid:(id)sender;

- (IBAction)onBtnDone:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@end
