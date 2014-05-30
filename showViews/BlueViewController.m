//
//  BlueViewController.m
//  showViews
//
//  Created by Jason Cui on 1/21/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "BlueViewController.h"

@interface BlueViewController ()

@end

@implementation BlueViewController

@synthesize myLable;

-(IBAction)sayHello:(id)sender{
    myLable.text = @"Hello There!";
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Blue Screen";
    NSLog(@"execute blue action");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
