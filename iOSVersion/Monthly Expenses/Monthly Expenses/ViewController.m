//
//  ViewController.m
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "KalDate.h"
#import "KalLogic.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "ExpensesViewController.h"

@implementation ViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"2Expenses"])
    {
        ExpensesViewController *destViewController = (ExpensesViewController*)[segue destinationViewController];
        
        [destViewController setCurDate:selectedDate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    logic = [[KalLogic alloc] initForDate:[NSDate date]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        kalView = [[KalView alloc] initWithFrame:CGRectMake(0, 0, 320, 340) delegate:self logic:logic];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        kalView = [[KalView alloc] initWithFrame:CGRectMake(0, 0, 768, 340 * kPad) delegate:self logic:logic];
    }
    
    [self.view addSubview:kalView];
    [kalView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateMoneyPresentation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    if (m_curMonth != nil)
    {
        [m_curMonth release];
        m_curMonth = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    if (m_curMonth != nil)
    {
        [m_curMonth release];
        m_curMonth = nil;
    }
    
    if (logic != nil)
    {
        [logic release];
        logic = nil;
    }
    
    if (kalView != nil)
    {
        [kalView removeFromSuperview];
        kalView = nil;
    }
    
    if (selectedDate != nil)
    {
        [selectedDate release];
        selectedDate = nil;
    }
    [super dealloc];
}


- (void)setSelectedDate:(NSDate*)date
{
    if (selectedDate != nil)
    {
        [selectedDate release];
        selectedDate = nil;
    }
    
    selectedDate = [date retain];
}

- (NSDate*)selectedDate
{
    return selectedDate;
}

// -----------------------------------------
#pragma mark - KalViewDelegate protocol
- (void)didMonthChanged
{
    [self updateMoneyPresentation];
}

- (void)didSelectDate:(KalDate *)date
{
    [self setSelectedDate:[date NSDate]];
    
   // [self performSegueWithIdentifier:@"2Expenses" sender:nil];
}

- (void)showExpenseOfDate:(KalDate *)date
{
    [self setSelectedDate:[date NSDate]];
    
    [self performSegueWithIdentifier:@"2Expenses" sender:nil];
}


- (void)showPreviousMonth
{
    [logic retreatToPreviousMonth];
    [kalView jumpToSelectedMonth];
}

- (void)showFollowingMonth
{
    [logic advanceToFollowingMonth];
    [kalView jumpToSelectedMonth];
}

- (void)showCurrentMonth
{
    [logic moveToMonthForDate:[NSDate date]];
    [kalView jumpToSelectedMonth];
}

- (void)updateMoneyPresentation
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *strMonthName = [dateFormatter stringFromDate:selectedDate];
    [dateFormatter release];
    
    if (m_curMonth != nil)
    {
        [m_curMonth release];
        m_curMonth = nil;
    }
    
    m_curMonth = [[[DBManager sharedManager] monthWidhName:strMonthName] retain];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    lblBudget.text = [NSString stringWithFormat:@"%@ %.2f", [appDelegate currencyString], [m_curMonth budget]];    
    lblSpent.text = [NSString stringWithFormat:@"%@ %.2f", [appDelegate currencyString], [m_curMonth spent]];
    lblBalance.text = [NSString stringWithFormat:@"%@ %.2f", [appDelegate currencyString], [m_curMonth balance]];
}
@end
