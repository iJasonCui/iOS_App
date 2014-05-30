//
//  SettingsViewController.m
//  ToDoApp
//
//  Created by Pavel Palancica on 3/25/13.
//  Copyright (c) 2013 Pavel Palancica. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()

- (IBAction)dismissSettingsViewController:(id)sender;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
    NSLog(@"%s", __FUNCTION__);
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Settings", @"Settings");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissSettingsViewController:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
