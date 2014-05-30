//
//  ViewController.m
//  ToDoApp
//
//  Created by Pavel Palancica on 3/25/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import "ListsViewController.h"

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "AddNewListViewController.h"
#import "EditExistingListViewController.h"

#import "List.h"

#define kNoNameTitle @"Untitled"


@interface ListsViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNewListBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *toDoListsTableView;

@property (nonatomic) NSUInteger selectedRow;

- (void)createAndAddLeftBarButton;
- (void)createAndAddRightBarButton;

- (void)showSettings;
- (void)addNewList;
- (void)showForEditingListAtIndex:(NSInteger)index;

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;

- (void)deleteList:(NSUInteger)index;

@end


@implementation ListsViewController

@synthesize selectedRow = _selectedRow;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;

#pragma mark -
#pragma mark - Private methods

- (void)createAndAddLeftBarButton
{
    NSLog(@"%s", __FUNCTION__);
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    settingsButton.frame = CGRectMake(0, 0, 35, 30);
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings.png"]
                              forState:UIControlStateNormal];
    [settingsButton addTarget:self
                       action:@selector(showSettings)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.leftBarButtonItem = self.settingsBarButtonItem;
}

- (void)createAndAddRightBarButton
{
    NSLog(@"%s", __FUNCTION__);
    
    UIButton *addNewListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addNewListButton.frame = CGRectMake(0, 0, 35, 30);
    [addNewListButton setBackgroundImage:[UIImage imageNamed:@"add-new-list.png"] forState:UIControlStateNormal];
    [addNewListButton addTarget:self
                         action:@selector(addNewList)
               forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addNewListBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addNewListButton];
    
    self.navigationItem.rightBarButtonItem = addNewListBarButtonItem;
}

- (void)showSettings
{
    NSLog(@"%s", __FUNCTION__);
    
    [self performSegueWithIdentifier:@"ShowSettings" sender:self];
}

- (void)addNewList
{
    NSLog(@"%s", __FUNCTION__);
    
    [self performSegueWithIdentifier:@"AddNewList" sender:self];
}

- (void)showForEditingListAtIndex:(NSInteger)index;
{
    NSLog(@"%s", __FUNCTION__);
    
    [self performSegueWithIdentifier:@"EditExistingList" sender:self];
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure List object's name
//    NSString *name;
//    
//    if ([list.name isEqualToString:@""] || [list.name length] == 0) {
//        name = kNoNameTitle;
//    } else {
//        name = list.name;
//    }
//    
//    cell.textLabel.text = name;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", list.name];
    
    NSUInteger listSize = [list.listItems count];
    
    if (listSize > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d items", listSize];
    } else {
        cell.detailTextLabel.text = @"";
    }
}

- (void)deleteList:(NSUInteger)index
{
    NSLog(@"%s", __FUNCTION__);

    [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]]];
    
    NSError *error = nil;
    
    if ([self.managedObjectContext save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}


#pragma mark -
#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"ShowSettings"])
    {
        NSLog(@"Segue named ShowSettings loaded!!!");
    }
    else if ([[segue identifier] isEqualToString:@"AddNewList"])
    {
        NSLog(@"Segue named AddNewList loaded!!!");
    }
    else if ([[segue identifier] isEqualToString:@"EditExistingList"])
    {
        List *list = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
        
        ((EditExistingListViewController *) segue.destinationViewController).list = list;
        
        NSLog(@"Segue named EditExistingList loaded!!!");
    }
}

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.managedObjectContext = [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
    self.managedObjectModel = [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectModel];
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = NSLocalizedString(@"Lists", @"Lists");
    
    // The "Settings" button
    [self createAndAddLeftBarButton];
    
    // The "Add New List" button
    [self createAndAddRightBarButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.toDoListsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDataSource methods

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%s", __FUNCTION__);
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)   tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate methods

- (void)            tableView:(UITableView *)tableView
      didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedRow = indexPath.row;
    
    [self showForEditingListAtIndex:indexPath.row];
}

// Override to support editing the table view.
- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [self deleteList:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark -
#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    NSLog(@"%s", __FUNCTION__);
    
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Lists"];
    
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return __fetchedResultsController;
}

#pragma mark -
#pragma mark - NSFetchedResultsControllerDelegate methods

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.toDoListsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.toDoListsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                               withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.toDoListsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                               withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.toDoListsTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.toDoListsTableView endUpdates];
}

@end
