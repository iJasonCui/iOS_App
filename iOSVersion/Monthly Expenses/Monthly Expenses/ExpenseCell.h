//
//  ExpenseCell.h
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseCell : UITableViewCell
{

}

@property (nonatomic, assign) IBOutlet UILabel          *lblName;
@property (nonatomic, assign) IBOutlet UILabel          *lblCheckNumber;
@property (nonatomic, assign) IBOutlet UIButton         *btnEdit;
@property (nonatomic, assign) IBOutlet UIButton         *btnDelete;

@property (nonatomic, assign) IBOutlet UILabel          *lblPrice;
@property (nonatomic, assign) IBOutlet UIImageView      *imgView;
@end
