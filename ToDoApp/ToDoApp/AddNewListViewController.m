//
//  AddNewListViewController.m
//  ToDoApp
//
//  Created by Pavel Palancica on 3/25/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import "AddNewListViewController.h"

#import "AppDelegate.h"

#import "ListItem.h"


@interface AddNewListViewController ()

@property (nonatomic) BOOL isEditing;
@property (nonatomic) NSUInteger indexForDeletion;
@property (nonatomic) NSUInteger firstResponderTextFieldTag;

@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITableView *listItemsTableView;

@property (strong, nonatomic) NSMutableArray *listItemsArray;

- (IBAction)cancelAddingNewList:(id)sender;
- (IBAction)saveNewList:(id)sender;

- (IBAction)addNewItemButtonTap:(id)sender;

- (void)createNewListWithName:(NSString *)name;

- (void)createAndAddRightDoneBarButton;
- (void)createAndAddRightSaveBarButton;

- (void)saveNewListAndListItems;
- (void)doneEditing;

@end


@implementation AddNewListViewController

@synthesize isEditing = _isEditing;
@synthesize indexForDeletion = _indexForDeletion;
@synthesize firstResponderTextFieldTag = _firstResponderTextFieldTag;

@synthesize titleTextField = _titleTextField;
@synthesize listItemsTableView = _listItemsTableView;

@synthesize list = _list;
@synthesize listItemsArray = _listItemsArray;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;

- (NSMutableArray *)listItemsArray
{
    if (!_listItemsArray) {
        _listItemsArray = [[NSMutableArray alloc] init];
    }
    
    return _listItemsArray;
}

#pragma mark -
#pragma mark - Private methods

- (void)doneEditing
{
    NSLog(@"%s", __FUNCTION__);
    
    self.isEditing = NO;
    
    if ([self.titleTextField isFirstResponder])
    {
        [self.titleTextField resignFirstResponder];
    }
    else
    {
        UITextField *selectedTextField = ((UITextField *) [self.view viewWithTag:self.firstResponderTextFieldTag]);
        
        [selectedTextField resignFirstResponder];
        
        NSString *selectedListName = selectedTextField.text;
        
        selectedListName = [selectedListName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if ([selectedListName isEqualToString:@""])
        {
            [self.listItemsArray removeObjectAtIndex:(self.firstResponderTextFieldTag - 10000)];
            [self.listItemsTableView reloadData];
        }
    }
    
    [self createAndAddRightSaveBarButton];
}

- (void)saveNewListAndListItems
{
    NSLog(@"%s", __FUNCTION__);
    
    NSString *newListName = self.titleTextField.text;
    
    newListName = [newListName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([newListName isEqualToString:@""])
    {
        newListName = @"New List";
    }
    
    self.list = [NSEntityDescription insertNewObjectForEntityForName:@"List"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [self.list setName:newListName];
    
    for (NSString *listItemName in self.listItemsArray)
    {
        ListItem *newListItem = [NSEntityDescription insertNewObjectForEntityForName:@"ListItem" inManagedObjectContext:self.managedObjectContext];
        
        newListItem.name = listItemName;

        [self.list addListItemsObject:newListItem];
        newListItem.list = self.list;
    }
    
    // Save everything
    
    NSError *error = nil;
    
    if ([self.list.managedObjectContext save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createAndAddRightDoneBarButton
{
    NSLog(@"%s", __FUNCTION__);
    
    UIBarButtonItem *doneBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self
                                                      action:@selector(doneEditing)];
        
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
}

- (void)createAndAddRightSaveBarButton
{
    NSLog(@"%s", __FUNCTION__);
    
    UIBarButtonItem *doneBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(saveNewListAndListItems)];
    
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
}


- (void)viewDidLoad
{
    self.managedObjectContext = [(AppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
    self.managedObjectModel = [(AppDelegate *) [UIApplication sharedApplication].delegate managedObjectModel];
    
    [self createAndAddRightDoneBarButton];
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    // The editable "Title"
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
    self.titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.titleTextField.delegate = self;
    self.titleTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	[self.titleTextField setTextAlignment:NSTextAlignmentCenter];
	[self.titleTextField setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
	[self.titleTextField setTextColor:[UIColor whiteColor]];
    self.titleTextField.returnKeyType = UIReturnKeyNext;
    
    self.titleTextField.text = NSLocalizedString(@"New List", @"New List");
	self.navigationItem.titleView = self.titleTextField;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.titleTextField selectAll:self.titleTextField];
    [self.titleTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddingNewList:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNewList:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self saveNewListAndListItems];
}

- (IBAction)addNewItemButtonTap:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self createAndAddRightSaveBarButton];
    
    [self.listItemsArray addObject:@"New List Item"];
    [self.listItemsTableView reloadData];
    
    UITableViewCell *tableViewCell = [self.listItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:([self.listItemsArray count] - 1) inSection:0]];
    
    [((UITextField *) [tableViewCell viewWithTag:(10000 + [self.listItemsArray count] - 1)]) becomeFirstResponder];
}

- (void)createNewListWithName:(NSString *)name
{
    NSLog(@"%s", __FUNCTION__);
    
    self.list = [NSEntityDescription insertNewObjectForEntityForName:@"List"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [self.list setName:name];
    
    NSLog(@"self.list = %@", self.list);
    
    NSError *error = nil;
    
    if ([self.list.managedObjectContext save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)setTheCorrespondingFirstResponder
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUInteger offSet = 0;
        
    if (self.indexForDeletion < (self.firstResponderTextFieldTag - 10000))
    {
        offSet = -1;
    }
    
    UITableViewCell *tableViewCell = [self.listItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:(self.firstResponderTextFieldTag - 10000 + offSet) inSection:0]];
    
    [((UITextField *) [tableViewCell viewWithTag:self.firstResponderTextFieldTag + offSet]) becomeFirstResponder];
}

#pragma mark -
#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.firstResponderTextFieldTag != 0 && self.firstResponderTextFieldTag != textField.tag)
    {        
        NSUInteger editingCellTextFieldIndex = self.firstResponderTextFieldTag - 10000;
        
        UITableViewCell *editingTextFieldTableViewCell = [self.listItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:editingCellTextFieldIndex inSection:0]];
        
        UITextField *previousEditingTextField = ((UITextField *) [editingTextFieldTableViewCell viewWithTag:(10000 + editingCellTextFieldIndex)]);
        
        if ([previousEditingTextField.text isEqualToString:@""])
        {
            NSLog(@"hehehe");

            [previousEditingTextField resignFirstResponder];
            [self createAndAddRightSaveBarButton];
            
            self.indexForDeletion = self.firstResponderTextFieldTag - 10000;
            
            [self.listItemsArray removeObjectAtIndex:self.indexForDeletion];
            
//            [self.listItemsTableView performSelectorOnMainThread:@selector(reloadData)
//                                                      withObject:nil
//                                                   waitUntilDone:YES];            
            [self.listItemsTableView reloadData];
            
            self.firstResponderTextFieldTag = textField.tag;
            
            [NSTimer scheduledTimerWithTimeInterval:0.0f
                                             target:self
                                           selector:@selector(setTheCorrespondingFirstResponder)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
    
    if (textField == self.titleTextField)
    {
        [self.titleTextField selectAll:self.titleTextField];
        [self.titleTextField becomeFirstResponder];
    }
    
    self.firstResponderTextFieldTag = textField.tag;
    
    [self createAndAddRightDoneBarButton];
    
    self.isEditing = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%s", __FUNCTION__);
    
    BOOL result = NO;
    
    NSString *newListItemName;
    
    // Editing the List name/title
    if ([self.titleTextField isFirstResponder])
    {
        if ([self.listItemsArray count] == 0)
        {
            newListItemName = @"New List Item";
            
            [self.listItemsArray addObject:newListItemName];
            [self.listItemsTableView reloadData];
        }
        
        UITableViewCell *firstTableViewCell = [self.listItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        
        [((UITextField *) [firstTableViewCell viewWithTag:10000]) becomeFirstResponder];
    }
    // Editing a ListItem name
    else //if (textField.tag < (10000 + [self.listItemsArray count] - 1))
    {
        NSString *currentListName = textField.text;
        
        currentListName = [currentListName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (textField.tag < (10000 + [self.listItemsArray count] - 1))
        {
            if (![currentListName isEqualToString:@""])
            {
                UITableViewCell *firstTableViewCell = [self.listItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:(textField.tag - 10000 + 1) inSection:0]];
                
                [((UITextField *) [firstTableViewCell viewWithTag:(textField.tag + 1)]) becomeFirstResponder];
            }
        }
        else
        {
            if (![currentListName isEqualToString:@""])
            {
                newListItemName = @"";
                
                [self.listItemsArray addObject:newListItemName];
                [self.listItemsTableView reloadData];
                
                UITableViewCell *tableViewCell = [self.listItemsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:([self.listItemsArray count] - 1) inSection:0]];
                
                [((UITextField *) [tableViewCell viewWithTag:10000 + [self.listItemsArray count] - 1]) becomeFirstResponder];
            }
        }
    }
    
    return result;
}

// return NO to not change text
- (BOOL)                textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string
{
    NSLog(@"%s", __FUNCTION__);
    
    NSString *currentListName = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    currentListName = [currentListName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (textField != self.titleTextField && ![currentListName isEqualToString:@""])
    {
        NSUInteger editingTextFieldIndex = self.firstResponderTextFieldTag - 10000;
        
        NSString *editingListItemName = [self.listItemsArray objectAtIndex:editingTextFieldIndex];
        
        editingListItemName = currentListName;
        
        [self.listItemsArray replaceObjectAtIndex:editingTextFieldIndex withObject:editingListItemName];
    }
    
    return YES;
}


#pragma mark -
#pragma mark - UITableViewDataSource methods

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%s", __FUNCTION__);
    
    return 1;
}

- (NSInteger)   tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s", __FUNCTION__);

    return [self.listItemsArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITextField *listItemNameTextField;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        listItemNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, IS_IPAD ? 650 : 250, 30)];
        listItemNameTextField.backgroundColor = [UIColor clearColor];
        listItemNameTextField.textColor = [UIColor darkGrayColor];
//        listItemNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        listItemNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        listItemNameTextField.returnKeyType = UIReturnKeyNext;
        listItemNameTextField.placeholder = @"New List Item";
        listItemNameTextField.delegate = self;
        listItemNameTextField.tag = 10000 + indexPath.row;
        
        [cell addSubview:listItemNameTextField];
    }
    else
    {
        listItemNameTextField = (UITextField *) [cell viewWithTag:10000 + indexPath.row];
    }
    
    NSString *listItemName = [self.listItemsArray objectAtIndex:indexPath.row];
        
    if ([listItemName isEqualToString:@"New List Item"])
    {
        listItemNameTextField.text = @"";
    }
    else
    {
        listItemNameTextField.text = listItemName;
    }
    
    return cell;
}

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)        tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    return !self.isEditing;
}

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)        tableView:(UITableView *)tableView
       commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.listItemsArray removeObjectAtIndex:indexPath.row];
        [self.listItemsTableView reloadData];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate methods

- (void)            tableView:(UITableView *)tableView
      didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
