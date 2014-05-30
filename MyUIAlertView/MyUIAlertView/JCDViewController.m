//
//  JCDViewController.m
//  MyUIAlertView
//
//  Created by Jason Cui on 1/21/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end


@implementation JCDViewController

-(IBAction)showHelloMessage:(id)sender{
    
    UIAlertView *message = [[UIAlertView alloc]
                            initWithTitle:@"Hello World!"
                            message:@"Do you like today's weather?"
                            delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:@"Yes",@"No",nil];
    
    [message show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTile = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(buttonTile);
    
    switch(buttonIndex) {
        case 0:
            NSLog(@"Cancel button is clicked");
            break;
        case 1:
            NSLog(@"Yes button is clicked");
            break;
        case 2:
            NSLog(@"No button is clicked");
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
