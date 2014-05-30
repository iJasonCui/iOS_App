//
//  List.h
//  ToDoApp
//
//  Created by Pavel Palancica on 4/7/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem;

@interface List : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *listItems;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addListItemsObject:(ListItem *)value;
- (void)removeListItemsObject:(ListItem *)value;
- (void)addListItems:(NSSet *)values;
- (void)removeListItems:(NSSet *)values;

@end
