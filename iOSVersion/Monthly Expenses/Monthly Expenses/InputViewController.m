//
//  InputViewController.m
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "InputViewController.h"
#import "CategoryListAlert.h"
#import "DBManager.h"
#import "Month.h"
#import "AppDelegate.h"

@implementation InputViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [swtPaid setOnText:@"YES"];
    [swtPaid setOffText:@"NO"];
    
    [txtExpenseName setText:[m_expense name]];
    [txtPrice setText:[NSString stringWithFormat:@"%.2f", [m_expense price]]];
    [txtCategory setText:[m_expense category]];
    
    if ([m_expense type] == EXPENSE_TYPE_NORMAL)
    {
        lblPaid.hidden = YES;
        swtPaid.hidden = YES;
        
        [btnNormal setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
        [btnBill setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        lblPaid.hidden = NO;
        swtPaid.hidden = NO;
        
        [btnBill setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
        [btnNormal setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
        
    }
    [swtPaid setOn:[m_expense paid]];
    
    if ([m_expense paymentMode] == PAYMENT_MODE_CASH)
    {
        lblCheckNumber.hidden = YES;
        txtCheckNumber.hidden = YES;
        
        [btnCash setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
        [btnCheck setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        lblCheckNumber.hidden = NO;
        txtCheckNumber.hidden = NO;
        
        [btnCheck setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
        [btnCash setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
            
    }
    
    [txtCheckNumber setText:[m_expense chequeNumber]];
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


- (void)setExpense:(Expense*)expense
{
    if (m_expense != nil)
    {
        [m_expense release];
        m_expense = nil;
    }
    
    m_expense = [expense retain];
    
}

- (Expense*)expense
{
    return m_expense;
}

#pragma mark - Button Actions
- (IBAction)onBtnCategoryList:(id)sender
{
    CategoryListAlert *alert = [[CategoryListAlert alloc] initWithTitle:@"Select Category"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Select", nil];
    
    alert.tableHeight = 160;
    [alert show];
    [alert release];
}

- (IBAction)onBtnNormal:(id)sender
{
    [m_expense setType:EXPENSE_TYPE_NORMAL];   
    
    lblPaid.hidden = YES;
    swtPaid.hidden = YES;
    
    [btnNormal setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
    [btnBill setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
}

- (IBAction)onBtnBill:(id)sender
{
    [m_expense setType:EXPENSE_TYPE_BILL];
    
    lblPaid.hidden = NO;
    swtPaid.hidden = NO;
    
    [btnBill setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
    [btnNormal setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
}

- (IBAction)onBtnCash:(id)sender
{
    [m_expense setPaymentMode:PAYMENT_MODE_CASH];
    
    lblCheckNumber.hidden = YES;
    txtCheckNumber.hidden = YES;
    
    
    [btnCash setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
    [btnCheck setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
}

- (IBAction)onBtnCheck:(id)sender
{
    [m_expense setPaymentMode:PAYMENT_MODE_CHEQUE];
    
    lblCheckNumber.hidden = NO;
    txtCheckNumber.hidden = NO;
    
    [btnCheck setImage:[UIImage imageNamed:@"optionSelected.png"] forState:UIControlStateNormal];
    [btnCash setImage:[UIImage imageNamed:@"optionUnselected.png"] forState:UIControlStateNormal];
}

- (IBAction)onSwitchPaid:(id)sender
{
    [m_expense setPaid:[swtPaid isOn]];
}

- (IBAction)onBtnDone:(id)sender
{
    //Name Validate
    if ([[txtExpenseName text] length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item name is blank" message:@"Please provide item name." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    [m_expense setName:[txtExpenseName text]];
    
    //Priece Validate
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *price = [formatter numberFromString:[txtPrice text]];
    [formatter release];
    
    if ( price == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Price entered is not numeric" message:@"Please enter numeric value in price." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
    
    if ([price floatValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Price entered is zero" message:@"Price must be greater than zero" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    NSString *strMonth = [[m_expense date] substringToIndex:7];
    Month *month = [[DBManager sharedManager] monthWidhName:strMonth];
    
    if ([price floatValue] > [month balance])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Price exceeds remaining balance" message:@"Price exceeds remaining balance" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        [self onBtnCancel:nil];
        return;
    }
    [m_expense setPrice:[price floatValue]];
    
    NSString *str = [txtCategory text];
    
    if ([str length] > 0)
        [[DBManager sharedManager] insertCategory:str];
    
    [m_expense setCategory:str];
    
    if ([m_expense paymentMode] == PAYMENT_MODE_CHEQUE)
    {
        //Cheque Number Validate
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *chequeno = [formatter numberFromString:[txtCheckNumber text]];
        [formatter release];
        
        if ([[txtCheckNumber text] length] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cheque number is blank" message:@"Please provide Cheque number." delegate:nil cancelButtonTitle:@"Please provide Cheque number." otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return;
            
        }
        
        if (chequeno == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cheque number entered is not numeric" message:@"Please enter numeric value in Cheque number." delegate:nil cancelButtonTitle:@"Cheque number entered is not numeric" otherButtonTitles:nil];
            
            
            [alert show];
            [alert release];
            return;
        }
        
        if ([[txtCheckNumber text] length] < 4)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cheque number entered has less than 4 digits" message:@"Cheque number must have at least 4 digits" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return;
        }
        
        [m_expense setChequeNumber:[txtCheckNumber text]];
    }
    
    
    /////////////////////////////
    if ([m_expense expenseID] == -1)
    {
        [[DBManager sharedManager] insertExpense:m_expense];
    }
    else
    {
        [[DBManager sharedManager] updateExpense:m_expense withID:[m_expense expenseID]];
    }
    
    [month setSpent:([month spent] + [m_expense price])];
    [[DBManager sharedManager] updateMonth:month withID:[month monthID]];
    
    if ([m_expense type] == EXPENSE_TYPE_BILL)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (![m_expense paid])
            [appDelegate regNotif:m_expense];
        else
            [appDelegate deleteNotif:[m_expense expenseID]];
        
    }
    
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)onBtnCancel:(id)sender
{
    if ([m_expense price] != 0)
    {
        NSString *strMonth = [[m_expense date] substringToIndex:7];
        Month *month = [[DBManager sharedManager] monthWidhName:strMonth];
        
        [month setSpent:[month spent] + [m_expense price]];
        [[DBManager sharedManager] updateMonth:month withID:[month monthID]];
    }
    
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)   //cancel
    {
        
    }
    else                    //select
    {
        CategoryListAlert *alert = (CategoryListAlert*)alertView;
        NSIndexPath *indexpath = [alert.tableView indexPathForSelectedRow];
        if (indexpath != nil)
        {
            UITableViewCell *cell = [alert.tableView cellForRowAtIndexPath:indexpath];
            txtCategory.text = cell.textLabel.text;
        }
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtCheckNumber)
    {
        [UIView beginAnimations: @"moveup" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.2f];
        self.view.frame = CGRectOffset(self.view.frame, 0, -180);
        [UIView commitAnimations];
    }
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txtCheckNumber)
    {
        [UIView beginAnimations: @"moveup" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.2f];
        self.view.frame = CGRectOffset(self.view.frame, 0, 180);
        [UIView commitAnimations];
    }
    
    return YES;
}
@end
