//
//  ExpenseCell.m
//  Monthly Expenses
//
//  Created by Jinxing Li on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ExpenseCell.h"

@implementation ExpenseCell

@synthesize lblName, lblCheckNumber, btnEdit, btnDelete, lblPrice, imgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
