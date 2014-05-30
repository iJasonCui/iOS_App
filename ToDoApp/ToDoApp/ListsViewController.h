//
//  ViewController.h
//  ToDoApp
//
//  Created by Pavel Palancica on 3/25/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSManagedObjectModel *managedObjectModel;

@end
