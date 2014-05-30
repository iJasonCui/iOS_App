//
//  EditExistingListViewController.h
//  ToDoApp
//
//  Created by Pavel Palancica on 3/25/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "List.h"

@interface EditExistingListViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) List *list;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end
