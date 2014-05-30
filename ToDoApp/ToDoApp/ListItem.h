//
//  ListItem.h
//  ToDoApp
//
//  Created by Pavel Palancica on 4/7/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) List *list;

@end
