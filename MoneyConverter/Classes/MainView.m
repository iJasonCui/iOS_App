//
//  MainView.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainView.h"
#import "ForexAppDelegate.h"
#import "ForexDataObject.h"
#import "CurrencyDataObject.h"
#import "AtomTableViewCell.h"
#import "AddCell.h"
#import "Reachability.h"
#import "DetailViewController.h"

BOOL mayRotate = YES;

@implementation MainView

@synthesize lastUpdated;
@synthesize calcList, currencyList;

- (IBAction) calc: (id) sender
{
		
	[tableView reloadData];
	
}

- (IBAction) updateExchangeRates: (id) sender
{
//	UIApplication *app = [UIApplication sharedApplication];
//	[app setNetworkActivityIndicatorVisible:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSLog(@"testing yahoo");
	[[Reachability sharedReachability] setHostName:@"download.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];

	NSLog(@"testing flux");
	[[Reachability sharedReachability] setHostName:@"www.fluxforge.com"];
	NetworkStatus internetConnectionStatus2 = [[Reachability sharedReachability] remoteHostStatus];



	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

	
	
	if (internetConnectionStatus == NotReachable || internetConnectionStatus2 == NotReachable)
	{	
		
		NSString *formattedDateString = nil;
		if (lastUpdated != nil)
			formattedDateString = [dateFormatter stringFromDate:lastUpdated];
		else
			formattedDateString = @"No update yet!";
			
		[lastUpdatedLabel setText: [NSString stringWithFormat:@"[No Network] Last update: %@", formattedDateString]];
	}
	else
	{
		
			NSURL *listUrl = [NSURL URLWithString:@"http://www.fluxforge.com/services/english_currency_list.txt"];
  
        
        NSError* error = nil;
        NSString* theList = [NSString stringWithContentsOfURL:listUrl encoding:NSASCIIStringEncoding error:&error];
        if( theList )
        {
            NSLog(@"Text=%@", theList);
        }
        else 
        {
            NSLog(@"Error = %@", error);
        }

			NSArray *arr = [theList componentsSeparatedByString:@","];


        
			if (theList == nil)
			{
				BOOL bLoad = [self loadCurrencyList];
				
				if (bLoad == NO)
				{
					[self createDefaultCurrencyList];
				}
				else
				{
				}
			}
			else
			{
				currencyList = [[NSMutableArray alloc] init];
				
				int i = 0;
				for (i = 0; i < [arr count]; i+=2)
				{
					CurrencyDataObject *cdo = [[CurrencyDataObject alloc] init];
					[cdo setCurrencyCode: [arr objectAtIndex: i]];
					[cdo setCurrencyDescription:[arr objectAtIndex: i+1]];
					[currencyList addObject:cdo];
					[cdo release];
				}
				[self saveCurrencyList];
			}
		[pickerView reloadAllComponents];
			
		
		for (ForexDataObject *fdo in calcList)
		{
			[fdo updateExchangeRate];	
		}
	
		[self setLastUpdated:[NSDate date]];

		NSString *formattedDateString = [dateFormatter stringFromDate:lastUpdated];
		[lastUpdatedLabel setText: [NSString stringWithFormat:@"Last update: %@", formattedDateString]];
		
		[self saveCalcList];
		[tableView reloadData];
		

	}
	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (IBAction) toggleEdit: (id) sender
{
	
	if ([tableView isEditing] == YES)
	{
		

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];		
		CGRect rect = mainBar.frame;
		rect.origin.x = 0;
		mainBar.frame = rect;		
		rect = editBar.frame;
		if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
			rect.origin.x = -480;
		else
			rect.origin.x = -320;
		

		editBar.frame = rect;

		[UIView commitAnimations];

		

		[tableView setEditing:NO animated:YES];	
		
		


	}
	else
	{

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];

		CGRect rect = mainBar.frame;

		if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
			rect.origin.x = 480;
		else
			rect.origin.x = 320;
		

		mainBar.frame = rect;

		rect = editBar.frame;

		rect.origin.x = 0;
		editBar.frame = rect;

		[UIView commitAnimations];


		[tableView setEditing:YES animated:YES];		
		
		


		
	}

}

- (IBAction) addViewReturnSave: (id) sender
{
	
    
	NSInteger from_code_index = [pickerView selectedRowInComponent: 0];

	NSInteger to_code_index = [pickerView selectedRowInComponent: 1];
 
	ForexDataObject *fdo = [[ForexDataObject alloc] init];

	[fdo setFromCurrencyCode: [[currencyList objectAtIndex: from_code_index] currencyCode]];

	[fdo setToCurrencyCode: [[currencyList objectAtIndex: to_code_index] currencyCode]];

	
	[calcList addObject: fdo];

	[self updateExchangeRates: self];

	BOOL b = [self saveCalcList];

	if (b == NO)
	{
	}
	
	
	
	[tableView reloadData];

	
    mayRotate = YES;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];	
	[addView removeFromSuperview];
	[UIView commitAnimations];
	
	[fdo release];
	
}

- (IBAction) addViewReturnCancel: (id) sender
{
	
	mayRotate = YES;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];	
	[addView removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction) addCellToTableView: (id) sender
{
	mayRotate = NO;
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		mayRotate = YES;
		UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"No space on screen!" message:@"Please turn your device to portrait mode!" delegate: nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
		
		[a show];
		
		
		return;
	}


	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];	

	
	
	[self addSubview: addView];	

	
	if (addView != nil)
	{
		[addViewLabel1 setText: [[currencyList objectAtIndex:[pickerView selectedRowInComponent:0]] currencyDescription]];
		[addViewLabel2 setText: [[currencyList objectAtIndex:[pickerView selectedRowInComponent:1]] currencyDescription]];	
	}
	
	[UIView commitAnimations];
	

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

			return ([calcList count]+1);
	
	if ([tableView isEditing])
	{	
		return ([calcList count]+1);
		
	}
	else
		return [calcList count];

}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([tableView isEditing])
	{
		if ([indexPath row] == ([calcList count]))
			return UITableViewCellEditingStyleInsert;
		else
			return UITableViewCellEditingStyleDelete;
	}

	if ([indexPath row] == ([calcList count]))
		return UITableViewCellEditingStyleInsert;
	else
		return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{

        
		[calcList removeObjectAtIndex:[indexPath row]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

		BOOL b = [self saveCalcList];
		if (b == NO)
		{

		}
		

	}
	else if (editingStyle == UITableViewCellEditingStyleInsert)
	{

		[self addCellToTableView:self];
	}


}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	static NSString *MyIdentifier = @"MyIdentifier";
	static NSString *addIdentifier = @"addIdentifier";
	
	
	if ([indexPath row] == ([calcList count]))
	{	

		

		AddCell *cell = (AddCell*)[tableView dequeueReusableCellWithIdentifier:addIdentifier];

		
		if (cell == nil) 
		{

			
			cell = (AddCell*)[[[NSBundle mainBundle] loadNibNamed:@"AddCell" owner:self options: nil] objectAtIndex:0];
			
			UIImageView *iv = [[[UIImageView alloc] initWithImage: cellBackgroundImage] autorelease];
			[cell setBackgroundView:iv];
			
			[[cell cellText] setText:@"Add new ..."];
			
			[[cell cellText] release];
			
		}
		
		return cell;
		
		
		return cell;
	}
	
	
	

	AtomTableViewCell *cell = (AtomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) 
	{
		cell = (AtomTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"AtomCell" owner:self options: nil] objectAtIndex:0];

		UIImageView *iv = [[[UIImageView alloc] initWithImage: cellBackgroundImage] autorelease];
		[cell setBackgroundView:iv];
		
	}

	
	

	ForexDataObject *fdo = [calcList objectAtIndex:indexPath.row];
	double finput = [[inputField text] doubleValue];


	if ([[fdo exchangeRate1] compare: [NSDecimalNumber zero]] == NSOrderedDescending &&
		[[fdo exchangeRate2] compare: [NSDecimalNumber zero]] == NSOrderedDescending)
	{
		NSString *sinput = [NSString stringWithFormat:@"%f",finput];
		NSDecimalNumber *decinput = [NSDecimalNumber decimalNumberWithString: sinput];
		
		NSDecimalNumber *ex1 = [decinput decimalNumberByMultiplyingBy: [fdo exchangeRate1]];
		NSDecimalNumber *ex2 = [decinput decimalNumberByMultiplyingBy: [fdo exchangeRate2]];
		

	
		NSString *format = nil;
		if (finput >= 10.0)
			format = @"%.2f %@ = %.2F %@";
		else
			format = @"%.2f %@ = %.4F %@";
	
		NSString *zeile1_text = [[NSString stringWithFormat:format,finput, [fdo fromCurrencyCode],[ex1 doubleValue],[fdo toCurrencyCode]] autorelease];
		NSString *zeile2_text = [[NSString stringWithFormat:format,finput, [fdo toCurrencyCode],[ex2 doubleValue],[fdo fromCurrencyCode]] autorelease];	
	
		[zeile1_text retain];
		[zeile2_text retain];
		
		[cell setText1: zeile1_text];
		[cell setText2: zeile2_text];			
	}
	else
	{
		[cell setText1:@"Your are offline!"];
		[cell setText2:@"Conversion not possible."];	
	}
	
    
	return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([indexPath row] == [calcList count])
	{	
		

		
		[self addCellToTableView: self];
		return;
	}
	
	

	DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle: nil];
	[dvc setCallingView: self];
	[dvc setObjectToShowHistory: [calcList objectAtIndex:indexPath.row]];
	[dvc viewWillAppear: YES];	


	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: [self superview] cache:YES];
	
	[[self superview] addSubview: [dvc view]];

	[UIView commitAnimations];
	

	
}




- (BOOL) loadCalcList
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"calclist.dat"];
	
	
	
	NSMutableArray *newCalcList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
	
	
	NSString *filename_lastUpdate = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"updated.dat"];

	
	NSDate *newLastUpdated = (NSDate *)[NSKeyedUnarchiver unarchiveObjectWithFile:filename_lastUpdate];
	
	if (newLastUpdated != nil)
	{

		[self setLastUpdated: newLastUpdated];

        
	}
	
	if (newCalcList == nil)
	{	
		return NO;
	}	
	else
	{

		
		[self setCalcList: newCalcList];
		

        
		return YES;
	}
}

- (BOOL) saveCurrencyList
{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	

	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"currencylist.dat"];

	
	BOOL b = [NSKeyedArchiver archiveRootObject:currencyList toFile:filename];
	

	return b;
}

- (BOOL) loadCurrencyList
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	

	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"currencylist.dat"];
	
	
    
	
	NSMutableArray *newCurrencyList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];

	
	
	if (newCurrencyList == nil)
	{	
		return NO;
	}	
	else
	{
		
		[self setCurrencyList: newCurrencyList];
	
		
		return YES;
	}
}

- (BOOL) saveCalcList
{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	

	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"calclist.dat"];

	
	BOOL b = [NSKeyedArchiver archiveRootObject:calcList toFile:filename];
	
	
	NSString *filename_lastUpdate = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"updated.dat"];

    
	BOOL c = [NSKeyedArchiver archiveRootObject:lastUpdated toFile:filename_lastUpdate];
	
	
	return (b && c);
}


- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == inputField)
    {

        [inputField resignFirstResponder];
    }
    return NO;
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {

	}
	return self;
}

- (void) createDefaultCurrencyList
{
	currencyList = [[NSMutableArray alloc] init];

	CurrencyDataObject *cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"EUR"];
	[cdo setCurrencyDescription:@"Euro"];
	[currencyList addObject:cdo];
	[cdo release];
	
	cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"GBP"];
	[cdo setCurrencyDescription:@"British Pound"];
	[currencyList addObject:cdo];
	[cdo release];
	
	cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"JPY"];
	[cdo setCurrencyDescription:@"Japanese Yen"];
	[currencyList addObject:cdo];
	[cdo release];

	cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"USD"];
	[cdo setCurrencyDescription:@"US Dollar"];
	[currencyList addObject:cdo];
	[cdo release];	
}

- (void) createDefaultCalcList
{
	calcList = [[NSMutableArray alloc] init];
	
	ForexDataObject *fdo = [[ForexDataObject alloc] init];
	[fdo setFromCurrencyCode:@"USD"];
	[fdo setToCurrencyCode:@"EUR"];

	[calcList addObject:fdo];
	[fdo release];
	
	fdo = [[ForexDataObject alloc] init];
	[fdo setFromCurrencyCode:@"USD"];
	[fdo setToCurrencyCode:@"GBP"];

	[calcList addObject:fdo];
	[fdo release];
	
}




- (id)initWithCoder:(NSCoder *)coder 
{

	if (self = [super initWithCoder:coder]) 
	{

		cellBackgroundImage = [UIImage imageNamed:@"cell_1.png"];
		[cellBackgroundImage retain];
		
		BOOL bLoad = [self loadCalcList];
		
		if (bLoad == NO)
		{

			[self createDefaultCalcList];
			
		}
		else
		{	
			
		}

		bLoad = [self loadCurrencyList];
		
		if (bLoad == NO)
		{

			[self createDefaultCurrencyList];
		}
		
		
        
		[[Reachability sharedReachability] setHostName:@"www.fluxforge.com"];
		NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
		
		if (internetConnectionStatus == NotReachable)
		{	

		}


	}
	
	return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [currencyList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{	
	return [[currencyList objectAtIndex:row] currencyCode];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0)
		[addViewLabel1 setText: [[currencyList objectAtIndex:row] currencyDescription]];
	else
		[addViewLabel2 setText: [[currencyList objectAtIndex:row] currencyDescription]];
}

- (void)drawRect:(CGRect)rect {

}

- (void) didLoad
{


    
	[self insertSubview:editBar belowSubview:mainBar];
	CGRect rect = editBar.frame;
	rect.origin.x = -320;
	editBar.frame = rect;
	
	
	[tableView setBackgroundColor:[UIColor clearColor]];
	[lastUpdatedLabel setText: @"Updating ..."];
	

    
	[NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(updateExchangeRates:) userInfo:nil repeats:NO];
	
}

- (void)dealloc 
{

	
	[calcList release];
	[currencyList release];
	[super dealloc];
}


@end
