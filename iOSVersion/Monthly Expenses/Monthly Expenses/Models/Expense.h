//
//  Expense.h
//  Monthly Expenses
//
//  Created by Jinxing Li on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum tagEXPENSE_TYPE
{
    EXPENSE_TYPE_UNKNOWN = -1,
    EXPENSE_TYPE_NORMAL = 0,
    EXPENSE_TYPE_BILL,
    
} EXPENSE_TYPE;

typedef enum tagPAYMENT_MODE
{
    PAYMENT_MODE_UNKNOWN = -1,
    PAYMENT_MODE_CASH = 0,
    PAYMENT_MODE_CHEQUE,
    
} PAYMENT_MODE;

@interface Expense : NSObject
{
    int                 m_nExpenseID;
    NSString            *m_strName;
    NSString            *m_strDate;
    float               m_fPrice;
    EXPENSE_TYPE        m_nType;
    BOOL                m_bPaid;
    PAYMENT_MODE        m_nPaymentMode;
    NSString            *m_strChequeNumber;
    NSString            *m_strCategory;
}


- (id)initWithExpenseID:(int)expenseID
               withName:(NSString *)name
               withDate:(NSString *)date
              withPrice:(float)price
               withType:(EXPENSE_TYPE)type
              withPaid:(BOOL)paid
        withPaymentMode:(PAYMENT_MODE)paymentMode
       withChequeNumber:(NSString*)chequeNumber
           withCategory:(NSString*)category;

#pragma mark Set Methods
- (void)setExpenseID:(int)expenseID;
- (void)setName:(NSString*)name;
- (void)setDate:(NSString*)date;
- (void)setPrice:(float)price;
- (void)setType:(EXPENSE_TYPE)type;
- (void)setPaid:(BOOL)paid;
- (void)setPaymentMode:(PAYMENT_MODE)paymentMode;
- (void)setChequeNumber:(NSString*)chequenumber;
- (void)setCategory:(NSString*)category;

#pragma mark Get Methods
- (int)expenseID;
- (NSString*)name;
- (NSString*)date;
- (float)price;
- (EXPENSE_TYPE)type;
- (BOOL)paid;
- (PAYMENT_MODE)paymentMode;
- (NSString*)chequeNumber;
- (NSString*)category;

@end
