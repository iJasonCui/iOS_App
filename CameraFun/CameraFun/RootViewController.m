//
//  RootViewController.m
//  CameraFun
//
//  Created by Hoa Chen on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "RootViewController.h"
#import "Example.h"
#import "OverlayPic1.h"
#import "OverlayPic2.h"
#import "OverlayPic3.h"

 

 NSString *testExampleData[][6]  = {
	{@"Barrack Obama", @"Ronald Reagan", @"Beyonce", @"OverlayPic1", @"OverlayPic2",@"OverlayPic3"},
};

@implementation RootViewController

 
- (void)viewWillAppear: (BOOL)animated { 
     self.navigationController.toolbarHidden = YES; 
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.toolbarHidden = NO;
    
   
}

-(void) loadTestData {
	// fill examplesArray with test data
	for (int i=0; i<1; i++) {
		Example *overlayPic1 = [[Example alloc] init];
		overlayPic1.title = testExampleData[i][0];
		overlayPic1.controllerClass = testExampleData[i][3];
		[examplesArray addObject: overlayPic1];
		[overlayPic1 release];
	}
    
    for (int i=0; i<1; i++) {
		Example *overlayPic2 = [[Example alloc] init];
 		overlayPic2.title = testExampleData[i][1];
 		overlayPic2.controllerClass = testExampleData[i][4];
		[examplesArray addObject: overlayPic2];
		[overlayPic2 release];
	}

    for (int i=0; i<1; i++) {
		Example *overlayPic3 = [[Example alloc] init];
 		overlayPic3.title = testExampleData[i][2];
 		overlayPic3.controllerClass = testExampleData[i][5];
		[examplesArray addObject: overlayPic3];
		[overlayPic3 release];
	}


}

- (void)viewDidLoad {
    [super viewDidLoad];
	examplesArray = [[NSMutableArray alloc] init];
	[self loadTestData];
}

 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [examplesArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
	}
    
	Example *anExample = [examplesArray objectAtIndex:indexPath.row];
	cell.textLabel.text = anExample.title;
    return cell;
    
    Example *anPoo = [examplesArray objectAtIndex:indexPath.row];
	cell.textLabel.text = anPoo.title;
    return cell;
}

//pushingViewProgramatically
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Example *example = [examplesArray objectAtIndex:indexPath.row];
    
    UIViewController *exampleController = [[NSClassFromString(example.controllerClass) alloc] init];
    
	[self.navigationController pushViewController:exampleController animated:YES];
    

}

//enables cell to push to next view
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {  
    [self performSegueWithIdentifier:@"tigger" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}
 


/*
 // Override to support row selection in the table view.
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 // Navigation logic may go here -- for example, create and push another view controller.
 // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
 // [self.navigationController pushViewController:anotherViewController animated:YES];
 // [anotherViewController release];
 }
 */


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
    [super dealloc];
}


@end


