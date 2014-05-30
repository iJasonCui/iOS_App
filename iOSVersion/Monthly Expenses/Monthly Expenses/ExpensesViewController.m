//
//  ExpensesViewController.m
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ExpensesViewController.h"
#import "NSDateAdditions.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "InputViewController.h"
#import "ExpenseCell.h"

@implementation ExpensesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Expenses2Input"])
    {
        InputViewController *destViewController = (InputViewController*)[segue destinationViewController];
        
        if (m_nSelectedIndex != -1)
        {
            Expense *expense = [[m_curExpenses objectAtIndex:m_nSelectedIndex] retain];
            [destViewController setExpense:expense];
            [expense release];
            
            [m_curMonth setSpent:([m_curMonth spent] - [expense price])];
            [[DBManager sharedManager] updateMonth:m_curMonth withID:[m_curMonth monthID]];
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDayName = [dateFormatter stringFromDate:m_curDate];
            [dateFormatter release];
            
            Expense *expense = [[Expense alloc] init];
            [expense setDate:strDayName];
            [destViewController setExpense:expense];
            [expense release];
        }
    }
}

- (void)dealloc
{
    if (tblCurrentySymbol != nil)
    {
        [tblCurrentySymbol release];
        tblCurrentySymbol = nil;
    }
    
    if (popoverController != nil)
    {
        [popoverController release];
        popoverController = nil;
    }
    
    if (aryCurrencySymbol != nil)
    {
        [aryCurrencySymbol release];
        aryCurrencySymbol = nil;
    }
    
    if (dataSheet != nil)
    {
        [dataSheet release];
        dataSheet = nil;
    }
    
    if (currencyPicker != nil)
    {
        [currencyPicker release];
        currencyPicker = nil;
    }
    
    if (m_curExpenses != nil)
    {
        [m_curExpenses release];
        m_curExpenses = nil;
    }
    
    if (m_curDate != nil)
    {
        [m_curDate release];
        m_curDate = nil;
    }
    
    if (m_curMonth != nil)
    {
        [m_curMonth release];
        m_curMonth = nil;
    }
    
    for (UIButton *btn in [scrvDays subviews])
    {
        [btn removeFromSuperview];
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *currencyCodes = [NSLocale ISOCurrencyCodes];
    NSMutableArray *currencySymbols = [[NSMutableArray alloc] init];
    
    for (NSString *str in currencyCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:[NSDictionary dictionaryWithObject: str forKey: NSLocaleCurrencyCode]];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
        NSString *symbol = [locale objectForKey:NSLocaleCurrencySymbol];
        
        NSLocale *currentLocale = [NSLocale currentLocale];
        NSString *displayName = [currentLocale displayNameForKey:NSLocaleCurrencySymbol value:symbol];
        
        
        NSString *strCurCode = [currentLocale objectForKey:NSLocaleCurrencyCode];
        if ([strCurCode isEqualToString:str])
            displayName = [currentLocale objectForKey:NSLocaleCurrencySymbol];
        
        if (displayName == nil || [displayName length] == 0)
            displayName = symbol;
        
        
        [currencySymbols addObject:displayName];
        [locale release];
    }
    
    aryCurrencySymbol = [currencySymbols retain];
    [currencySymbols release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self makeDayButtons];
    [self updateDayName];
    [self updateMoneyPresentation];
    [self updateCurrency];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setCurDate:(NSDate*)date
{
    if (m_curDate != nil)
    {
        [m_curDate release];
        m_curDate = nil;
    }
    
    m_curDate = [date retain];
    
    if (m_curExpenses)
    {
        [m_curExpenses release];
        m_curExpenses = nil;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDayName = [dateFormatter stringFromDate:m_curDate];
    m_curExpenses = [[[DBManager sharedManager] expenseWithDate:strDayName] retain];
    
    [dateFormatter release];
    
    [self updateDayName];
    [self updateMoneyPresentation];
}

- (NSDate*)curDate
{
    return m_curDate;
}

- (void)updateDayName
{
    //Display the Full name of the date
    NSDateFormatter *dayNameFormatter = [[NSDateFormatter alloc] init];
    [dayNameFormatter setLocale:[NSLocale currentLocale]];
    [dayNameFormatter setCalendar:[NSCalendar currentCalendar]];
    [dayNameFormatter setDateFormat:@"d"];
    int date_day = [[dayNameFormatter stringFromDate:m_curDate] intValue];
    
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString *dateString = [[dayNameFormatter stringFromDate:m_curDate] stringByAppendingString:suffix];
    
    [dayNameFormatter setDateFormat:@" MMMM yyyy"];
    
	NSString *strMonth  =[dayNameFormatter stringFromDate:m_curDate];
    [dayNameFormatter release];
    
    dateString = [dateString stringByAppendingString:strMonth];
    
    [lblDayName setText:dateString];
    
    //////////////
    m_nSelectedIndex = -1;
    
    if (m_curExpenses)
    {
        [m_curExpenses release];
        m_curExpenses = nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDayName = [dateFormatter stringFromDate:m_curDate];
    m_curExpenses = [[[DBManager sharedManager] expenseWithDate:strDayName] retain];
    
    [dateFormatter release];
    
    [tblExpenses reloadData];
}

- (void)makeDayButtons
{
    //Remove existing buttons
    
    for (UIButton *btn in [scrvDays subviews])
    {
        [btn removeFromSuperview];
    }
    
    //Add New days
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:m_curDate];
    int curDay = [components day];
    
    int btnSize = 30;
    int fontSize = 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        btnSize = 60;
        fontSize = 40;
    }
    
    [scrvDays setContentSize:CGSizeMake(btnSize * [m_curDate cc_numberOfDaysInMonth], btnSize)];

    for (int i = 1; i <= [m_curDate cc_numberOfDaysInMonth]; i++)
    {
        UIButton *btnDay = [[UIButton alloc] initWithFrame:CGRectMake(btnSize * (i - 1), 0, btnSize, btnSize)];
        btnDay.tag = i;
        
        [btnDay.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        
        [btnDay setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [btnDay addTarget:self action:@selector(onBtnDay:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == curDay)
        {
            [btnDay setBackgroundImage:[UIImage imageNamed:@"Date.png"] forState:UIControlStateNormal];
            [btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [btnDay setBackgroundImage:[UIImage imageNamed:@"normalDate.png"] forState:UIControlStateNormal];   
            [btnDay setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        [scrvDays addSubview:btnDay];
        [btnDay release];
    }
    
    int offset = btnSize * (curDay - 1) - self.view.frame.size.width / 2 + btnSize / 2;
    if (offset < 0)
        offset = 0;
    
    if (offset > scrvDays.contentSize.width - scrvDays.frame.size.width)
        offset = scrvDays.contentSize.width - scrvDays.frame.size.width;
    
    [scrvDays setContentOffset:CGPointMake(offset, 0)];
    
    //Set Cur month Information & selected day Informations
    if (m_curMonth)
    {
        [m_curMonth release];
        m_curMonth = nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *strMonthName = [dateFormatter stringFromDate:m_curDate];
    
    m_curMonth = [[[DBManager sharedManager] monthWidhName:strMonthName] retain];
    if (m_curMonth == nil)
    {
        m_curMonth = [[Month alloc] initWithID:-1 withName:strMonthName withBudget:0 withSpent:0];
    }
    [dateFormatter release];
    
}

- (void)updateMoneyPresentation
{
    [txtBudget setText:[NSString stringWithFormat:@"%.2f", [m_curMonth budget]]];

    
    [lblMonthSpent setText:[NSString stringWithFormat:@"%.2f", [m_curMonth spent]]];
    [lblBalance setText:[NSString stringWithFormat:@"%.2f", [m_curMonth balance]]];
    
    float daySpent = 0;
    for (int i = 0; i < [m_curExpenses count]; i++)
    {
        Expense *expense = [m_curExpenses objectAtIndex:i];
        daySpent += [expense price];
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [lblDaySpent setText:[NSString stringWithFormat:@"%@ %.2f", [appDelegate currencyString], daySpent]];
    
}

- (void)updateCurrency
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [btnCurrency setTitle:[appDelegate currencyString] forState:UIControlStateNormal];
    [lblMonthSpentMark setText:[appDelegate currencyString]];
    [lblBalanceMark setText:[appDelegate currencyString]];
    
    float daySpent = 0;
    for (int i = 0; i < [m_curExpenses count]; i++)
    {
        Expense *expense = [m_curExpenses objectAtIndex:i];
        daySpent += [expense price];
    }
    
    [lblDaySpent setText:[NSString stringWithFormat:@"%@ %.2f", [appDelegate currencyString], daySpent]];
    
    [tblExpenses reloadData];
}

- (void)finishCurrencyPicker
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
 
    

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {   
        int selectedIndex = [currencyPicker selectedRowInComponent:0];
        
        [delegate setCurrencyString:[aryCurrencySymbol objectAtIndex:selectedIndex]];
        
        [currencyPicker release];
        currencyPicker = nil;
        [currencyPicker release];
        currencyPicker = nil;
        
//        [delegate setCurrencyString:[aryCurrencySymbol objectAtIndex:m_nSelectedCurrencyIndex]];
//        
//        [tblCurrentySymbol release];
//        tblCurrentySymbol = nil;
        
        [popoverController dismissPopoverAnimated:YES];
        [popoverController release];
        popoverController = nil;
    }
    else
    {          
        int selectedIndex = [currencyPicker selectedRowInComponent:0];
        
        [delegate setCurrencyString:[aryCurrencySymbol objectAtIndex:selectedIndex]];
        
        [currencyPicker release];
        currencyPicker = nil;
        [dataSheet dismissWithClickedButtonIndex:0 animated:YES];
        [dataSheet release];
        dataSheet = nil;
    }
    [self updateCurrency];
}

- (void)cancelCurrencyPicker
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [currencyPicker release];
        currencyPicker = nil;

//        [tblCurrentySymbol release];
//        tblCurrentySymbol = nil;
        
        [popoverController dismissPopoverAnimated:YES];
        [popoverController release];
        popoverController = nil;
    }
    else
    {
        [currencyPicker release];
        currencyPicker = nil;
        
        [dataSheet dismissWithClickedButtonIndex:0 animated:YES];
        [dataSheet release];
        dataSheet = nil;
    }
}

#pragma mark - Button Actions

- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnReport:(id)sender
{
    
}

- (IBAction)onBtnCurrency:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
        [toolBar setBarStyle:UIBarStyleBlack];
        //[toolBar sizeToFit];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(finishCurrencyPicker)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelCurrencyPicker)];
        
        [toolBar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:YES];
        [spacer release];
        [setButton release];
        [cancelButton release];
        
        UIViewController *popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 644)];
        popoverView.backgroundColor = [UIColor whiteColor];
        
        
        [popoverView addSubview:toolBar];
        [toolBar release];
        
        
//        tblCurrentySymbol = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 600) style:UITableViewStylePlain];
//        [tblCurrentySymbol setDelegate:self];
//        [tblCurrentySymbol setDataSource:self];
//        [popoverView addSubview:tblCurrentySymbol];
        
        currencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 400, 216)];
        currencyPicker.showsSelectionIndicator = YES;
        currencyPicker.delegate = self;
        currencyPicker.dataSource = self;
        [popoverView addSubview:currencyPicker];
        
        popoverContent.view = popoverView;
        
        //resize the popover view shown
        //in the current view to the view's size
        popoverContent.contentSizeForViewInPopover = CGSizeMake(400, 260);
        
        //create a popover controller
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        CGRect popoverRect = [self.view convertRect:[btnCurrency frame] 
                                           fromView:[btnCurrency superview]];
        
        
        [popoverController 
         presentPopoverFromRect:popoverRect
         inView:self.view 
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
        
        
        //release the popover content
        [popoverView release];
        [popoverContent release];

    }
    else
    {
        
        dataSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [dataSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        currencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        currencyPicker.showsSelectionIndicator = YES;
        currencyPicker.delegate = self;
        currencyPicker.dataSource = self;
        
        [dataSheet addSubview:currencyPicker];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, dataSheet.bounds.size.width, 44)];
        [toolBar setBarStyle:UIBarStyleBlack];
        [toolBar sizeToFit];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(finishCurrencyPicker)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelCurrencyPicker)];
        
        [toolBar setItems:[NSArray arrayWithObjects:spacer, cancelButton, setButton, nil] animated:YES];
        [spacer release];
        [setButton release];
        [cancelButton release];
        
        [dataSheet addSubview:toolBar];
        [toolBar release];
        
        [dataSheet showInView:self.view];
        [dataSheet setBounds:CGRectMake(0, 0, 320, 485)];
    }
    
    int i = 0;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for (i = 0; i < [aryCurrencySymbol count]; i++)
    {
        NSString *str = [aryCurrencySymbol objectAtIndex:i];
        if ([str isEqualToString:[delegate currencyString]])
            break;
    }
    [currencyPicker selectRow:i inComponent:0 animated:NO];
    
}

- (IBAction)onBtnAdd:(id)sender
{
    if ([m_curMonth budget] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Budget not set yet" message:@"Budget has not been set yet. \nPlease set budget before adding any expense" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        [txtBudget becomeFirstResponder];
    }
    else
    {
        m_nSelectedIndex = -1;
        [self performSegueWithIdentifier:@"Expenses2Input" sender:nil];
    }
}

- (void)onBtnDay:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:m_curDate];
 
    int oldDay = [components day];
    
    if (oldDay == btn.tag)
        return;
    
    UIButton *oldBtn = (UIButton*)[scrvDays viewWithTag:oldDay];
    [oldBtn setBackgroundImage:[UIImage imageNamed:@"normalDate.png"] forState:UIControlStateNormal];
    [oldBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [components setDay:btn.tag];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    [self setCurDate:newDate];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"Date.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    int offset = btn.frame.origin.x - self.view.frame.size.width / 2 + btn.frame.size.width / 2;
    
    if (offset < 0)
        offset = 0;
    
    if (offset > scrvDays.contentSize.width - scrvDays.frame.size.width)
        offset = scrvDays.contentSize.width - scrvDays.frame.size.width;
    
    [scrvDays setContentOffset:CGPointMake(offset, 0)];
}

- (IBAction)onBtnEdit:(id)sender
{
    [self performSegueWithIdentifier:@"Expenses2Input" sender:nil];
}

- (IBAction)onBtnDelete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure to delete this Expense data ?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
    [alert show];
    [alert release];
}

#pragma mark - UITextFieldDelgate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    NSString *string = [txtBudget text];
    float value = [string floatValue];
    
    if (value < [m_curMonth spent])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot set budget amount less than total expense" message:@"Budget cannot be set less than total month expense. \nPlease set Budget greater than total expense" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        [txtBudget setText:[NSString stringWithFormat:@"%.2f", [m_curMonth budget]]];
        return NO;
    }
    else{
        [m_curMonth setBudget:[string floatValue]];
        
        if ([m_curMonth monthID] == -1)
        {
            if ([m_curMonth budget] != 0)
                [[DBManager sharedManager] insertMonth:m_curMonth];
        }
        else
        {
            if ([m_curMonth budget] == 0)
            {
                [[DBManager sharedManager] deleteMonthWithID:[m_curMonth monthID]];
                [m_curMonth setMonthID:-1];
            }
            else
                [[DBManager sharedManager] updateMonth:m_curMonth withID:[m_curMonth monthID]];
        }
        
        [self updateMoneyPresentation];
        return YES;
    }
}

#pragma mark - UITableViewDelegate Methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblExpenses)
        return [m_curExpenses count];
    else
        return [aryCurrencySymbol count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblExpenses)
    {
        ExpenseCell *cell = (ExpenseCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpenseCell"];
        if (!cell)
        {
            cell = [[[ExpenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpenseCell"] autorelease];
        }
        
        Expense *expense = [m_curExpenses objectAtIndex:indexPath.row];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [cell.lblName setText:[expense name]];
        [cell.lblPrice setText:[NSString stringWithFormat:@"%@ %.2f", [appDelegate currencyString], [expense price]]];
        
        if ([expense paymentMode] == PAYMENT_MODE_CHEQUE)
        {
            cell.lblCheckNumber.hidden = NO;
            [cell.lblCheckNumber setText:[NSString stringWithFormat:@"Check No.%@", [expense chequeNumber]]];
            
        }
        else
        {
            cell.lblCheckNumber.hidden = YES;
        }
        
        if (m_nSelectedIndex == indexPath.row)
        {
            cell.btnEdit.hidden = NO;
            cell.btnDelete.hidden = NO;
            
            [cell.imgView setImage:[UIImage imageNamed:@"cellimageH.png"]];
        }
        else
        {
            cell.btnEdit.hidden = YES;
            cell.btnDelete.hidden = YES;
            
            [cell.imgView setImage:[UIImage imageNamed:@"cellimage.png"]];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
        }
        
        cell.textLabel.text = [aryCurrencySymbol objectAtIndex:indexPath.row];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:30];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblExpenses)
    {
        if (indexPath.row == m_nSelectedIndex)
            return;
        
        m_nSelectedIndex = indexPath.row;
        
        [tableView reloadData];
    }
    else
    {
        m_nSelectedCurrencyIndex = indexPath.row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblExpenses)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            return 51;
        else
            return 100;
    }
    else
        return 50;
    
}
#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)   //cancel
    {
        
    }
    else                    //select
    {
        Expense *expense = [m_curExpenses objectAtIndex:m_nSelectedIndex];
        [[DBManager sharedManager] deleteExpenseWithID:[expense expenseID]];
        
        [m_curMonth setSpent:([m_curMonth spent] - [expense price])];
        [[DBManager sharedManager] updateMonth:m_curMonth withID:[m_curMonth monthID]];
        
        m_nSelectedIndex = -1;
        
        if (m_curExpenses)
        {
            [m_curExpenses release];
            m_curExpenses = nil;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDayName = [dateFormatter stringFromDate:m_curDate];
        m_curExpenses = [[[DBManager sharedManager] expenseWithDate:strDayName] retain];
        
        [dateFormatter release];
        
        [tblExpenses reloadData];
        
        [self updateMoneyPresentation];
    }
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [aryCurrencySymbol count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [aryCurrencySymbol objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if(pickerView == quantityPicker)
//    {
//        if(component == 0)
//        {
//            [m_newMed setMedType:row];
//            [quantityPicker selectRow:0 inComponent:4 animated:YES];
//            [quantityPicker reloadComponent:4];
//        }
//    }
}
         
@end
