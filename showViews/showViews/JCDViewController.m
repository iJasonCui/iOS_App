//
//  JCDViewController.m
//  showViews
//
//  Created by Jason Cui on 1/21/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"
#import "PinkViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController


-(IBAction)showPinkScreen:(id)sender{
    PinkViewController *pinkScreen = [[PinkViewController alloc] init];
    //[self presentViewController:pinkScreen animated:YES completion:nil];
    
    [self.navigationController pushViewController:pinkScreen animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Blue View";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
