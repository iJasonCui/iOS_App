//
//  DBManager.m
//  Medication4
//
//  Created by huyingan on 12/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"

static DBManager *      _sharedManager = nil;

@implementation DBManager

- (id)init
{
    self = [super init];
    if (self)
    {
        m_DB = NULL;
    }
    
    return  self;
}

- (void)dealloc
{
    [self closeDB];
    
    [super dealloc];
}

+ (DBManager *)sharedManager
{
    if (!_sharedManager)
    {
        @synchronized(self) {
            _sharedManager = [[self alloc] init];
        }
    }
    
    return _sharedManager;
}

#pragma mark --
- (BOOL)openDB
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"expenseDB.db3"];
    
	if (sqlite3_open([dbPath UTF8String], &m_DB) != SQLITE_OK) {
		return NO;
	}
    
    return YES;
}

- (BOOL)isExistDB
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"expenseDB.db3"];
 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    
    BOOL isExist = [fileManager fileExistsAtPath:dbPath isDirectory:&isDirectory];
    
    return isExist;
}

- (void)closeDB
{
    if (m_DB)
    {
        sqlite3_close(m_DB);
        m_DB = NULL;
    }
}

- (BOOL)createDB
{
    if (![self openDB])
        return NO;
    
    // ------------ Create Expense Table  -------- -_- 
    char *sqlCreateExpenseTbl = "CREATE TABLE ExpenseTbl(expense_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \
    name VARCHAR(100), \
    date VARCHAR(100), \
    price FLOAT, \
    type INTEGER, \
    paid INTEGER, \
    paymentMode INTEGER, \
    chequeNumber  VARCHAR(100), \
    category VARCHAR(100)\
    )";
    
    if (sqlite3_exec(m_DB, sqlCreateExpenseTbl, nil,nil,nil) != SQLITE_OK)
    {
		[self closeDB];
		return NO;
	}
    
    // ------------ Create Category Table  -------- -_-
    char *sqlCreateCategoryTbl = "CREATE TABLE CategoryTbl(ctgr_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \
    ctgr_name VARCHAR(255) \
    )";
    if (sqlite3_exec(m_DB, sqlCreateCategoryTbl, nil,nil,nil) != SQLITE_OK)
    {
		[self closeDB];
		return NO;
	}
    
    
    // ------------ Create Month Table  -------- -_-
    char *sqlCreateMonthTbl = "CREATE TABLE MonthTbl(month_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \
    name VARCHAR(100), \
    budget FLOAT, \
    spent FLOAT\
    )";
    
    if (sqlite3_exec(m_DB, sqlCreateMonthTbl, nil,nil,nil) != SQLITE_OK)
    {
		[self closeDB];
		return NO;
	}
    
    [self closeDB];
    
    
    //insert 7 initial categories
    [self insertCategory:@"Electric"];
    [self insertCategory:@"Food"];
    [self insertCategory:@"Gas"];
    [self insertCategory:@"Housing"];
    [self insertCategory:@"Transportation"];
    [self insertCategory:@"Utilities"];
    [self insertCategory:@"Water"];
    
    return YES;
}

#pragma mark - Expense Management

- (BOOL)insertExpense:(Expense *)aExpense
{
    if (![self openDB])
        return NO;
    
    char *sqlInsertExpense = "INSERT INTO ExpenseTbl(name, \
    date, \
    price, \
    type, \
    paid, \
    paymentMode, \
    chequeNumber, \
    category \
    ) \
    VALUES(?,?,?,?,?,?,?,?)";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *expense_stat = NULL;
    if (sqlite3_prepare_v2(m_DB, sqlInsertExpense, -1, &expense_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(expense_stat, 1, [[aExpense name] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(expense_stat, 2, [[aExpense date] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(expense_stat, 3, [aExpense price]);
        sqlite3_bind_int(expense_stat, 4, [aExpense type]);
        sqlite3_bind_int(expense_stat, 5, [aExpense paid] ? 1 : 0);
        sqlite3_bind_int(expense_stat, 6, [aExpense paymentMode]);
        sqlite3_bind_text(expense_stat, 7, [[aExpense chequeNumber] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(expense_stat, 8, [[aExpense category] UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(expense_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
        }
    }
    sqlite3_finalize(expense_stat);
    
    if (bSuccess)
    {
        int expenseID = (int)sqlite3_last_insert_rowid(m_DB);
        [aExpense setExpenseID:expenseID];
    }
    
    [self closeDB];
    return bSuccess;
}

- (BOOL)updateExpense:(Expense *)aExpense withID:(int)expenseID
{
    if (![self openDB])
        return NO;
    
    char *sqlUpdateExpense = "UPDATE ExpenseTbl SET name=?, \
    date=?, \
    price=?, \
    type=?, \
    paid=?, \
    paymentMode=?, \
    chequeNumber=?, \
    category=? \
    WHERE expense_id=?";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *expense_stat = NULL;
    if (sqlite3_prepare_v2(m_DB, sqlUpdateExpense, -1, &expense_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(expense_stat, 1, [[aExpense name] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(expense_stat, 2, [[aExpense date] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(expense_stat, 3, [aExpense price]);
        sqlite3_bind_int(expense_stat, 4, [aExpense type]);
        sqlite3_bind_int(expense_stat, 5, [aExpense paid] ? 1 : 0);
        sqlite3_bind_int(expense_stat, 6, [aExpense paymentMode]);
        sqlite3_bind_text(expense_stat, 7, [[aExpense chequeNumber] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(expense_stat, 8, [[aExpense category] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(expense_stat, 9, expenseID);
        
        if (sqlite3_step(expense_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
        }
    }
    sqlite3_finalize(expense_stat);
    
    [self closeDB];
    return bSuccess;
}

- (BOOL)deleteExpenseWithID:(int)expenseID
{
    if (![self openDB])
        return NO;
    
    char *sqlDeleteExpense = "DELETE FROM ExpenseTbl WHERE expense_id=?";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *expense_stat;
    
    if (sqlite3_prepare_v2(m_DB, sqlDeleteExpense, -1, &expense_stat, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(expense_stat, 1, expenseID);
        
        if (sqlite3_step(expense_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
            
            //Is it deleted correctly?
        }
    }
    
    sqlite3_finalize(expense_stat);
    
    [self closeDB];
    return bSuccess;
}

- (NSArray*)expenseWithID:(int)expenseID
{  
    NSMutableArray *expenses = [[NSMutableArray alloc] init];
    
    if (![self openDB])
    {
        return [expenses autorelease];
    }
    
    char sqlGetExpense[512] = "SELECT expense_id, \
    name, \
    date, \
    price, \
    type, \
    paid, \
    paymentMode, \
    chequeNumber, \
    category \
    FROM ExpenseTbl";
    
    if (expenseID >= 0)
        strcat(sqlGetExpense, " WHERE expense_id=?");
    
    sqlite3_stmt *expense_stat;//Memory leak
    
    if(sqlite3_prepare_v2(m_DB, sqlGetExpense, -1, &expense_stat, NULL) == SQLITE_OK)
    {    
        if (expenseID >= 0)
            sqlite3_bind_int(expense_stat, 1, expenseID);
        
        while (sqlite3_step(expense_stat) == SQLITE_ROW) 
        {
            NSInteger expenseID = sqlite3_column_int(expense_stat, 0);
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 1)];
            NSString *date = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 2)];
            float price = sqlite3_column_double(expense_stat, 3);
            NSInteger type = sqlite3_column_int(expense_stat, 4);
            BOOL paid = (sqlite3_column_int(expense_stat, 5) == 1);
            NSInteger paymentMode = sqlite3_column_int(expense_stat, 6);
            NSString *chequeNumber = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 7)];
            NSString *category = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 8)];
            
            Expense *expense = [[Expense alloc] initWithExpenseID:expenseID withName:name withDate:date withPrice:price withType:type withPaid:paid withPaymentMode:paymentMode withChequeNumber:chequeNumber withCategory:category];
            
            [expenses addObject:expense];
            [expense release];
            
        }
    }
    
    sqlite3_finalize(expense_stat);
    
    [self closeDB];
    
    return [expenses autorelease];
}

- (NSArray*)expenseWithDate:(NSString*)date
{
    NSMutableArray *expenses = [[NSMutableArray alloc] init];
    
    if (![self openDB])
    {
        return [expenses autorelease];
    }
    
    char *sqlGetExpense = "SELECT expense_id, \
    name, \
    date, \
    price, \
    type, \
    paid, \
    paymentMode, \
    chequeNumber, \
    category \
    FROM ExpenseTbl \
    WHERE date=?";
    
    sqlite3_stmt *expense_stat;//Memory leak
    
    if(sqlite3_prepare_v2(m_DB, sqlGetExpense, -1, &expense_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(expense_stat, 1, [date UTF8String], -1, SQLITE_TRANSIENT);
        
        
        while (sqlite3_step(expense_stat) == SQLITE_ROW) 
        {
            NSInteger expenseID = sqlite3_column_int(expense_stat, 0);
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 1)];
            NSString *date = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 2)];
            float price = sqlite3_column_double(expense_stat, 3);
            NSInteger type = sqlite3_column_int(expense_stat, 4);
            BOOL paid = (sqlite3_column_int(expense_stat, 5) == 1);
            NSInteger paymentMode = sqlite3_column_int(expense_stat, 6);
            NSString *chequeNumber = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 7)];
            NSString *category = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 8)];
            
            Expense *expense = [[Expense alloc] initWithExpenseID:expenseID withName:name withDate:date withPrice:price withType:type withPaid:paid withPaymentMode:paymentMode withChequeNumber:chequeNumber withCategory:category];
            
            [expenses addObject:expense];
            [expense release];
            
        }
    }
    
    sqlite3_finalize(expense_stat);
    
    [self closeDB];
    
    return [expenses autorelease];

}

- (NSArray*)expenseWithCategory:(NSString*)category
{  
    NSMutableArray *expenses = [[NSMutableArray alloc] init];
    
    if (![self openDB])
    {
        return [expenses autorelease];
    }
    
    char *sqlGetExpense = "SELECT expense_id, \
    name, \
    date, \
    price, \
    type, \
    paid, \
    paymentMode, \
    chequeNumber, \
    category \
    FROM ExpenseTbl \
    WHERE category=?";
    
    sqlite3_stmt *expense_stat;//Memory leak
    
    if(sqlite3_prepare_v2(m_DB, sqlGetExpense, -1, &expense_stat, NULL) == SQLITE_OK)
    {    
        sqlite3_bind_text(expense_stat, 1, [category UTF8String], -1, SQLITE_TRANSIENT);
        
        
        while (sqlite3_step(expense_stat) == SQLITE_ROW) 
        {
            NSInteger expenseID = sqlite3_column_int(expense_stat, 0);
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 1)];
            NSString *date = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 2)];
            float price = sqlite3_column_double(expense_stat, 3);
            NSInteger type = sqlite3_column_int(expense_stat, 4);
            BOOL paid = (sqlite3_column_int(expense_stat, 5) == 1);
            NSInteger paymentMode = sqlite3_column_int(expense_stat, 6);
            NSString *chequeNumber = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 7)];
            NSString *category = [NSString stringWithUTF8String:(char*)sqlite3_column_text(expense_stat, 8)];
            
            Expense *expense = [[Expense alloc] initWithExpenseID:expenseID withName:name withDate:date withPrice:price withType:type withPaid:paid withPaymentMode:paymentMode withChequeNumber:chequeNumber withCategory:category];
            
            [expenses addObject:expense];
            [expense release];
            
        }
    }
    
    sqlite3_finalize(expense_stat);
    
    [self closeDB];
    
    return [expenses autorelease];
}

- (NSArray*)expenseWithMonth:(NSString*)month
{
    NSMutableArray *aryExpenses = [[NSMutableArray alloc] initWithArray:[self expenseWithID:-1]];
    
    for (int i = 0; i < [aryExpenses count]; i++)
    {
        Expense *expense = [aryExpenses objectAtIndex:i];
        
        NSString *subString = [[expense date] substringToIndex:7];
        if (![subString isEqualToString:month])
        {
            [aryExpenses removeObjectAtIndex:i];
            i--;
        }
    }
    
    return [aryExpenses autorelease];
}

- (NSArray*)expenseWithCategoryonMonth:(NSString*)month
{
    
    NSMutableArray *aryReturn = [[NSMutableArray alloc] init];
    
    NSArray *categorys = [[self categories] retain];
    
    for (int i = 0; i < [categorys count]; i++)
    {
        NSMutableArray *ary = [[NSMutableArray alloc] init];
        [aryReturn addObject:ary];
        [ary release];
    }
    
    NSArray *aryExpenses = [[self expenseWithID:-1] retain];
    
    for (int i = 0; i < [aryExpenses count]; i++)
    {
        Expense *expense = [aryExpenses objectAtIndex:i];
        
        NSString *subString = [[expense date] substringToIndex:7];
        if ([subString isEqualToString:month])
        {
            for (int j = 0; j < [categorys count]; j++)
            {
                NSString *category = [categorys objectAtIndex:j];
                
                if ([category isEqualToString:[expense category]])
                {
                    NSMutableArray *ary = [aryReturn objectAtIndex:j];
                    [ary addObject:expense];
                }
            }
        }
    }
    
    [aryExpenses release];
    [categorys release];
    
    return [aryReturn autorelease];
}
- (int)expenseCountWithDate:(NSString*)date
{
    int ret = 0;
    
    if (![self openDB])
    {
        return ret;
    }
    
    char *sqlGetExpense = "SELECT expense_id, \
    name, \
    date, \
    price, \
    type, \
    paid, \
    paymentMode, \
    chequeNumber, \
    category \
    FROM ExpenseTbl \
    WHERE date=?";
    
    sqlite3_stmt *expense_stat;//Memory leak
    
    if(sqlite3_prepare_v2(m_DB, sqlGetExpense, -1, &expense_stat, NULL) == SQLITE_OK)
    {    
        sqlite3_bind_text(expense_stat, 1, [date UTF8String], -1, SQLITE_TRANSIENT);
    
        while (sqlite3_step(expense_stat) == SQLITE_ROW) 
        {
            ret++;
        }
    }
    
    sqlite3_finalize(expense_stat);
    
    [self closeDB];
    
    return ret;
}

#pragma mark - Month Management
- (BOOL)insertMonth:(Month*)aMonth
{
    if (![self openDB])
        return NO;
    
    char *sqlInsertMonth = "INSERT INTO MonthTbl(name, \
    budget, \
    spent \
    ) \
    VALUES(?,?,?)";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *month_stat = NULL;
    if (sqlite3_prepare_v2(m_DB, sqlInsertMonth, -1, &month_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(month_stat, 1, [[aMonth name] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(month_stat, 2, [aMonth budget]);
        sqlite3_bind_double(month_stat, 3, [aMonth spent]);
        
        if (sqlite3_step(month_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
        }
    }
    sqlite3_finalize(month_stat);
    
    if (bSuccess)
    {
        int monthID = (int)sqlite3_last_insert_rowid(m_DB);
        [aMonth setMonthID:monthID];
    }
    
    [self closeDB];
    return bSuccess;
}

- (BOOL)updateMonth:(Month*)aMonth withID:(int)monthID
{
    if (![self openDB])
        return NO;
    
    char *sqlUpdateMonth = "UPDATE MonthTbl SET name=?, \
    budget=?, \
    spent=? \
    WHERE month_id=?";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *month_stat = NULL;
    if (sqlite3_prepare_v2(m_DB, sqlUpdateMonth, -1, &month_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(month_stat, 1, [[aMonth name] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(month_stat, 2, [aMonth budget]);
        sqlite3_bind_double(month_stat, 3, [aMonth spent]);
        sqlite3_bind_int(month_stat, 4, monthID);
        
        if (sqlite3_step(month_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
        }
    }
    sqlite3_finalize(month_stat);
    
    [self closeDB];
    return bSuccess;
}

- (BOOL)deleteMonthWithID:(int)monthID
{
    if (![self openDB])
        return NO;
    
    char *sqlDeleteMonth = "DELETE FROM MonthTbl WHERE month_id=?";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *month_stat;
    
    if (sqlite3_prepare_v2(m_DB, sqlDeleteMonth, -1, &month_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_int(month_stat, 1, monthID);
        
        if (sqlite3_step(month_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
            
            //Is it deleted correctly?
        }
    }
    
    sqlite3_finalize(month_stat);
    
    [self closeDB];
    return bSuccess;

}

- (NSArray*)monthWithID:(int)monthID
{
    NSMutableArray *months = [[NSMutableArray alloc] init];
    
    if (![self openDB])
    {
        return [months autorelease];
    }
    
    char sqlGetMonth[512] = "SELECT month_id, \
    name, \
    budget, \
    spent \
    FROM MonthTbl";
    
    if (monthID >= 0)
        strcat(sqlGetMonth, " WHERE month_id=?");
    
    sqlite3_stmt *month_stat;//Memory leak
    
    if(sqlite3_prepare_v2(m_DB, sqlGetMonth, -1, &month_stat, NULL) == SQLITE_OK)
    {
        if (monthID >= 0)
            sqlite3_bind_int(month_stat, 1, monthID);
        
        while (sqlite3_step(month_stat) == SQLITE_ROW)
        {
            NSInteger monthID = sqlite3_column_int(month_stat, 0);
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(month_stat, 1)];
            float budget = sqlite3_column_double(month_stat, 2);
            float spent = sqlite3_column_double(month_stat, 3);
            
            Month *month = [[Month alloc] initWithID:monthID withName:name withBudget:budget withSpent:spent];
            
            [months addObject:month];
            [month release];
            
        }
    }
    
    sqlite3_finalize(month_stat);
    
    [self closeDB];
    
    return [months autorelease];

}

- (Month*)monthWidhName:(NSString*)name
{
    if (![self openDB])
    {
        return nil;
    }
    
    char sqlGetMonth[512] = "SELECT month_id, \
    name, \
    budget, \
    spent \
    FROM MonthTbl \
    WHERE name=?";
    
    sqlite3_stmt *month_stat;//Memory leak
    Month *retMonth = nil;
    
    if(sqlite3_prepare_v2(m_DB, sqlGetMonth, -1, &month_stat, NULL) == SQLITE_OK)
    {
        
        sqlite3_bind_text(month_stat, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(month_stat) == SQLITE_ROW)
        {
            NSInteger monthID = sqlite3_column_int(month_stat, 0);
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(month_stat, 1)];
            float budget = sqlite3_column_double(month_stat, 2);
            float spent = sqlite3_column_double(month_stat, 3);
            
            retMonth = [[[Month alloc] initWithID:monthID withName:name withBudget:budget withSpent:spent] autorelease];
        }
    }
    
    sqlite3_finalize(month_stat);
    
    [self closeDB];
    
    return retMonth;
}


#pragma mark - Category Management
- (BOOL)insertCategory:(NSString*)category
{
    NSArray *categories = [[self categories] retain];
    if ([categories containsObject:category])
    {
        [categories release];
        return NO;
    }
    [categories release];
    
    
    if (![self openDB])
        return NO;
    
    char *sqlInsertCategory = "INSERT INTO CategoryTbl(ctgr_name) \
    VALUES(?)";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *category_stat = NULL;
    if (sqlite3_prepare_v2(m_DB, sqlInsertCategory, -1, &category_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(category_stat, 1, [category UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(category_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
        }
    }
    sqlite3_finalize(category_stat);
    
    [self closeDB];
    return bSuccess;

}

- (BOOL)deleteCategory:(NSString*)category
{
    if (![self openDB])
        return NO;
    
    char *sqlDeleteCategory = "DELETE FROM CategoryTbl WHERE ctgr_name=?";
    
    BOOL bSuccess = NO;
    sqlite3_stmt *category_stat;
    
    if (sqlite3_prepare_v2(m_DB, sqlDeleteCategory, -1, &category_stat, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(category_stat, 1, [category UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(category_stat) != SQLITE_DONE) {
            bSuccess = NO;
        } else {
            bSuccess = YES;
            
            //Is it deleted correctly?
        }
    }
    
    sqlite3_finalize(category_stat);
    
    [self closeDB];
    return bSuccess;
}

- (NSArray*)categories
{
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    if (![self openDB])
    {
        return [categories autorelease];
    }
    
    char sqlGetMonth[512] = "SELECT ctgr_id, \
    ctgr_name \
    FROM CategoryTbl";
    
    sqlite3_stmt *category_stat;//Memory leak
    
    if(sqlite3_prepare_v2(m_DB, sqlGetMonth, -1, &category_stat, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(category_stat) == SQLITE_ROW)
        {
            NSInteger categoryID = sqlite3_column_int(category_stat, 0);
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(category_stat, 1)];
            
            categoryID = categoryID;
            [categories addObject:name];
            
        }
    }
    
    sqlite3_finalize(category_stat);
    
    [self closeDB];
    
    return [categories autorelease];
}

@end
