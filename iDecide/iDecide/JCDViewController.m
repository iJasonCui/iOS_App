//
//  JCDViewController.m
//  iDecide
//
//  Created by Jason Cui on 1/16/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController

@synthesize decisionText;

-(IBAction)ButtonPressed:(id)sender
{
    decisionText.text = @"Go For It";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"The View did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TouchDownButton:(id)sender {
}

@end
