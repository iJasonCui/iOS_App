//
//  Expense.m
//  Monthly Expenses
//
//  Created by Jinxing Li on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Expense.h"

@implementation Expense

- (id)init {
    self = [super init];
    if (self)
    {
        m_nExpenseID = -1;
        m_strName = [[NSString alloc] initWithString:@""];
        m_strDate = [[NSString alloc] initWithString:@""];
        m_fPrice = 0.0f;
        m_nType = EXPENSE_TYPE_NORMAL;
        m_bPaid = NO;
        m_nPaymentMode = PAYMENT_MODE_CASH;
        m_strChequeNumber = [[NSString alloc] initWithString:@""];;
        m_strCategory = [[NSString alloc] initWithString:@""];
    }
    
    return self;
}

- (id)initWithExpenseID:(int)expenseID
               withName:(NSString *)name
               withDate:(NSString *)date
              withPrice:(float)price
               withType:(EXPENSE_TYPE)type
              withPaid:(BOOL)paid
        withPaymentMode:(PAYMENT_MODE)paymentMode
       withChequeNumber:(NSString*)chequeNumber
           withCategory:(NSString*)category
{
    self = [super init];
    if (self)
    {
        m_nExpenseID = expenseID;
        m_strName = [[NSString alloc] initWithString:name ? name : @""];
        m_strDate = [[NSString alloc] initWithString:date ? date : @""];
        m_fPrice = price;
        m_nType = type;
        m_bPaid = paid;
        m_nPaymentMode = paymentMode;
        m_strChequeNumber = [[NSString alloc] initWithString:chequeNumber ? chequeNumber : @""];;
        m_strCategory = [[NSString alloc] initWithString:category ? category : @""];
    }
    
    return self;
}

- (void)dealloc
{
    [m_strName release];
    m_strName = nil;
    
    [m_strDate release];
    m_strDate = nil;
    
    [m_strChequeNumber release];
    m_strChequeNumber = nil;
    
    [m_strCategory release];
    m_strCategory = nil;
    
    [super dealloc];
}

#pragma mark Set Methods
- (void)setExpenseID:(int)expenseID
{
    m_nExpenseID = expenseID;
}

- (void)setName:(NSString*)name
{
    [m_strName release];
    m_strName = [name retain];
}

- (void)setDate:(NSString*)date
{
    [m_strDate release];
    m_strDate = [date retain];
}

- (void)setPrice:(float)price
{
    m_fPrice = price;
}

- (void)setType:(EXPENSE_TYPE)type
{
    m_nType = type;
}

- (void)setPaid:(BOOL)paid
{
    m_bPaid = paid;
}

- (void)setPaymentMode:(PAYMENT_MODE)paymentMode
{
    m_nPaymentMode = paymentMode;
}

- (void)setChequeNumber:(NSString*)chequenumber
{
    [m_strChequeNumber release];
    m_strChequeNumber = [chequenumber retain];
}

- (void)setCategory:(NSString*)category
{
    [m_strCategory release];
    
    m_strCategory = [category retain];
 
}

#pragma mark Get Methods
- (int)expenseID
{
    return m_nExpenseID;
}

- (NSString*)name
{
    return m_strName;
}

- (NSString*)date
{
    return m_strDate;
}

- (float)price
{
    return m_fPrice;
}

- (EXPENSE_TYPE)type
{
    return m_nType;
}

- (BOOL)paid
{
    return m_bPaid;
}

- (PAYMENT_MODE)paymentMode
{
    return m_nPaymentMode;
}

- (NSString*)chequeNumber
{
    return m_strChequeNumber;
}

- (NSString*)category
{
    return m_strCategory;
}

@end
