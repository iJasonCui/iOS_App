//
//  JCDMasterViewController.h
//  FirdstNavigation
//
//  Created by Jason Cui on 2/13/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCDDetailViewController;

@interface JCDMasterViewController : UITableViewController

@property (strong, nonatomic) JCDDetailViewController *detailViewController;

@end
