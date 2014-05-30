//
//  JCDViewController.m
//  SimpleMoviePlayer
//
//  Created by Jason Cui on 1/23/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController

@synthesize moviePlayer;

-(IBAction)playMovie:(id)sender
{
    NSString *videoPath = [[NSString alloc]
    initWithString:@"http://ebookfrenzy.com/ios_book/movie/movie.mov"];
    
    //NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"piano_3_008" ofType:@"avi"];
    
    NSURL *videoURL = [NSURL URLWithString:videoPath ];
    
    moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
                       
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
