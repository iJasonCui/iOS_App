//
//  DetailViewController.h
//  AudioPlayer
//
//  Created by David McMahon on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface DetailViewController : UIViewController{
    
    AVAudioPlayer *player;
    int playState;
    NSTimer *stopWatch;
    NSTimeInterval timerEndTime;
	
}

@property(nonatomic,retain) NSString *imageName;
@property(nonatomic, retain) NSString *soundFile;
@property float playLength;

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIButton *playButton;
@property(nonatomic, retain) IBOutlet UILabel *timeLabel;

-(IBAction)playSound:(id)sender;

@end
