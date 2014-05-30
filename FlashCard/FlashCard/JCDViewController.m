//
//  JCDViewController.m
//  FlashCard
//
//  Created by Jason Cui on 2013-10-21.
//  Copyright (c) 2013 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController

@synthesize helloLable;

- (IBAction)sayHello:(id)sender
{
    helloLable.text = @"Hello World";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
