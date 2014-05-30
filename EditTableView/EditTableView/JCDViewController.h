//
//  JCDViewController.h
//  EditTableView
//
//  Created by Jason Cui on 1/24/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCDViewController : UIViewController
{
    NSMutableArray *myData;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(IBAction)editData:(id)sender;

@end
