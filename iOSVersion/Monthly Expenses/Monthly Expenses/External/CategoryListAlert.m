//
//  CategoryList.m
//  medication
//
//  Created by Steve Jobs on 12-11-25.
//  Copyright (c) 2012年 Apple inc. All rights reserved.
//

//
//  UIAlertTableView.m
//  UIAlertTableView
//
// Copyright 2010 partiql Ltd, Switzerland.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "CategoryListAlert.h"
#import "DBManager.h"

#define kTablePadding 8.0f

@implementation CategoryListAlert

@synthesize dataSource;
@synthesize tableDelegate;
@synthesize tableHeight;
@synthesize tableView;
@synthesize aryCategory;

- (void)show{
    [self prepare];
    [super show];
    
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - tableExtHeight/2 - 10, self.frame.size.width, self.frame.size.height + tableExtHeight + 20)];
    
    // We get the lowest non-control view (i.e. Labels) so we can place the table view just below
    UIView *lowestView;
    int i = 0;
    while (![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]]) {
        lowestView = [self.subviews objectAtIndex:i];
        i++;
    }
    
    CGFloat tableWidth = 262.0f;
    
    tableView.frame = CGRectMake(11.0f, lowestView.frame.origin.y + lowestView.frame.size.height + 2 * kTablePadding, tableWidth, tableHeight);
    //btnDelete.frame = CGRectMake(0, 0, 30, 40);
    
    for (UIView *sv in self.subviews) {
        // Move all Controls down
        if ([sv isKindOfClass:[UIControl class]]) {
            sv.frame = CGRectMake(sv.frame.origin.x, sv.frame.origin.y + tableExtHeight, sv.frame.size.width, sv.frame.size.height);
        }
    }
    
    btnDelete.frame = CGRectMake(220, 7, 40, 40);
}

- (void)dealloc
{
    [aryCategory release];
    [tableView release];
    
    [super dealloc];
}

- (void)prepare {
    
    aryCategory = [[[DBManager sharedManager] categories] retain];
    
    if (tableHeight == 0) {
        tableHeight = 150.0f;
    }
    
    tableExtHeight = tableHeight + 2 * kTablePadding;
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;      
    
    [self insertSubview:tableView atIndex:0];
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    //btnDelete.frame = CGRectMake(220, 10, 40, 40);
    [btnDelete setImage:[UIImage imageNamed:@"detMedTrash.png"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(onEditTable:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btnDelete];
    
    [self setNeedsLayout];
}

-(IBAction)onEditTable:(id)sender
{
    if ([tableView isEditing])
    {
        [tableView setEditing:NO animated:YES];
    }
    else
    {
        [tableView setEditing:YES animated:YES];
    }
}

#pragma mark - UITableViewDeletage

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryCategory count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    // Make cell unselectable
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString *category = [aryCategory objectAtIndex:indexPath.row];
	cell.textLabel.text = category;		
    
    return cell;
}

- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//	if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //Delete Category
//        Category *category = [[aryCategory objectAtIndex:indexPath.row] retain];
//        if ([[DBManager sharedManager] deleteCategoryWithID:[category ctgrID]])
//        {
//            [aryCategory release];
//            aryCategory = [[[DBManager sharedManager] categoryWithID:-1] retain];
//            [tableView1 reloadData];
//        }
//        [category release];
//	}
//	else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//	}   
}
@end