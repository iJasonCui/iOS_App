//
//  JCDViewController.m
//  myActionSheet
//
//  Created by Jason Cui on 1/21/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController

-(IBAction)showActionSheet:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                    initWithTitle:@"Hello world!"
                                    delegate:self
                                    cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Destructive"
                                    otherButtonTitles:@"Button1", @"Button2", nil
                                    ];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Destructive clicked");
            break;
        case 1:
            NSLog(@"Button1 clicked");
            break;
        case 2:
            NSLog(@"Button2 clicked");
            break;
        case 3:
            NSLog(@"Cancel button clicked");
            break;
        default:
            break;
    }
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
