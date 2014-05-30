//
//  Month.m
//  Montly Expenses
//
//  Created by Han XiuXuan on 2/23/13.
//
//

#import "Month.h"

@implementation Month

- (id)init {
    self = [super init];
    if (self)
    {
        m_nMonthID = -1;
        m_strName = [[NSString alloc] initWithString:@""];
        m_fBudget = 0.0f;
        m_fSpent = 0.0f;
    }
    
    return self;
}

- (id)initWithID:(int)nID
        withName:(NSString*)strName
      withBudget:(float)fBudget
       withSpent:(float)fSpent
{
    self = [super init];
    if (self)
    {
        m_nMonthID = nID;
        m_strName = [[NSString alloc] initWithString:strName];
        m_fBudget = fBudget;
        m_fSpent = fSpent;
    }
    
    return self;
}

- (void)dealloc
{
    [m_strName release];
    m_strName = nil;
    
    [super dealloc];
}
- (void)setMonthID:(int)nMonthID
{
    m_nMonthID = nMonthID;
}

- (void)setName:(NSString*)strName
{
    [m_strName release];
    m_strName = [strName retain];
}

- (void)setBudget:(float)fBudget
{
    m_fBudget = fBudget;
}

- (void)setSpent:(float)fSpent
{
    m_fSpent = fSpent;
}

- (int)monthID
{
    return m_nMonthID;
}

- (NSString*)name
{
    return m_strName;
}

- (float)budget
{
    return m_fBudget;
}

- (float)spent
{
    return m_fSpent;
}

- (float)balance
{
    return m_fBudget - m_fSpent;
}
@end
