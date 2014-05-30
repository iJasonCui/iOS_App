//
//  DBManager.h
//  Medication4
//
//  Created by huyingan on 12/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>
#include "Expense.h"
#include "Month.h"

@interface DBManager : NSObject
{
    sqlite3 *       m_DB;
}

+ (DBManager *)sharedManager;
- (BOOL)openDB;
- (void)closeDB;
- (BOOL)isExistDB;
- (BOOL)createDB;

#pragma mark - Expense Menagement
- (BOOL)insertExpense:(Expense *)aExpense;
- (BOOL)updateExpense:(Expense *)aExpense withID:(int)expenseID;
- (BOOL)deleteExpenseWithID:(int)expenseID;

- (NSArray*)expenseWithID:(int)expenseID;
- (NSArray*)expenseWithDate:(NSString*)date;
- (NSArray*)expenseWithCategory:(NSString*)category;
- (NSArray*)expenseWithMonth:(NSString*)month;
- (NSArray*)expenseWithCategoryonMonth:(NSString*)month;

- (int)expenseCountWithDate:(NSString*)date;


#pragma mark - Month Management
- (BOOL)insertMonth:(Month*)aMonth;
- (BOOL)updateMonth:(Month*)aMonth withID:(int)monthID;
- (BOOL)deleteMonthWithID:(int)monthID;

- (NSArray*)monthWithID:(int)monthID;
- (Month*)monthWidhName:(NSString*)name;

#pragma mark - Category Management
- (BOOL)insertCategory:(NSString*)category;
- (BOOL)deleteCategory:(NSString*)category;
- (NSArray*)categories;

@end
