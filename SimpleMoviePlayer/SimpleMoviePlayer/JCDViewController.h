//
//  JCDViewController.h
//  SimpleMoviePlayer
//
//  Created by Jason Cui on 1/23/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface JCDViewController : UIViewController

@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayer;

-(IBAction)playMovie:(id)sender;


@end
