//
//  Month.h
//  Montly Expenses
//
//  Created by Han XiuXuan on 2/23/13.
//
//

#import <Foundation/Foundation.h>

@interface Month : NSObject
{
    int             m_nMonthID;
    NSString        *m_strName;
    
    float           m_fBudget;
    float           m_fSpent;
    
}

- (id)initWithID:(int)nID
        withName:(NSString*)strName
      withBudget:(float)fBudget
       withSpent:(float)fSpent;

- (void)setMonthID:(int)nMonthID;
- (void)setName:(NSString*)strName;
- (void)setBudget:(float)fBudget;
- (void)setSpent:(float)fSpent;

- (int)monthID;
- (NSString*)name;
- (float)budget;
- (float)spent;
- (float)balance;
@end
