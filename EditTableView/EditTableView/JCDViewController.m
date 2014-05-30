//
//  JCDViewController.m
//  EditTableView
//
//  Created by Jason Cui on 1/24/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController

@synthesize tableView;

-(IBAction)editData:(id)sender
{
    if (self.editing){
        //NSLog(@"Tapped Edit Data");
        [super setEditing:NO animated:NO];
        [tableView setEditing:NO animated:NO];
        [tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"US States";
    
    myData = [[NSMutableArray alloc] initWithObjects:
              @"California",
              @"New York",
              @"Illinoi",
              @"Florida",
              nil];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc ]
                                   initWithTitle:@"Edit"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(editData:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    // Configure the cell.
    cell.textLabel.text =[myData objectAtIndex:indexPath.row];
    //cell.imageView.image = [UIImage imageNamed:[imagethumbs objectAtIndex:indexPath.row]];
    //cell.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
    
    UIColor *selectedColor = [UIColor grayColor];
    UIView *myBackgroundColor = [[UIView alloc] init];
    [myBackgroundColor setBackgroundColor:selectedColor];
    
    [cell setSelectedBackgroundView:myBackgroundColor];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I did select row at the index path!");
    NSLog(@"Row %d", indexPath.row);
    NSLog([myData objectAtIndex:indexPath.row]);
    
    /*
    //NSString *selectedImage = [[NSString alloc] init];
    //NSString *selectedSound = [[NSString alloc] init];
    
    //switch (indexPath.row)
    //{
        case 0:
            selectedImage = @"songbird.jpg";
            //      selectedSound = @"birds";
            break;
        case 1:
            selectedImage = @"WindChimes.jpg";
            //      selectedSound = @"windchimes";
            break;
        case 2:
            selectedImage = @"Rain.jpg";
            //      selectedSound = @"rain";
            break;
        case 3:
            selectedImage = @"OceanWave.jpg";
            //      selectedSound = @"ocean";
            break;
        case 4:
            selectedImage = @"Whale.jpg";
            //      selectedSound = @"whales";
            break;
        default:
            break;
    }
    
    DetailViewController *detailScreen = [[DetailViewController alloc]
                                          initWithNibName:@"DetailViewController" bundle: [NSBundle mainBundle] ];
    
    detailScreen.imageName = selectedImage;
    detailScreen.soundName = [soundTitles objectAtIndex:indexPath.row];
    
    NSLog(@"selectedImage");
    NSLog(selectedImage);
    
    //detailScreen.
    
    [self.navigationController pushViewController:detailScreen animated:YES];
    */
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing == NO || !indexPath ) {
        return UITableViewCellEditingStyleNone;
    }
    if (self.editing && indexPath.row == [[myData count]]){
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
    
    /*
    SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == [controller countOfList]-1) {
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
    */
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /*
        SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
        [controller removeObjectFromListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         */
        [myData removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        
        
    }
}

#pragma mark -
#pragma mark ROW recording

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) // Don't move the first row
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    /*
    NSString *stringToMove = [self.reorderingRows objectAtIndex:sourceIndexPath.row];
    [self.reorderingRows removeObjectAtIndex:sourceIndexPath.row];
    [self.reorderingRows insertObject:stringToMove atIndex:destinationIndexPath.row];
     */
    NSString *item = [myData objectAtIndex:fromIndexPath.row];
    [myData removeObject:item];
    [myData insertObject:item atIndex:toIndexPath.row];
}

@end
