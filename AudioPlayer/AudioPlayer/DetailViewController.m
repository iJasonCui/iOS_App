//
//  DetailViewController.m
//  AudioPlayer
//
//  Created by David McMahon on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize imageName,imageView, soundFile, playButton,playLength,timeLabel;

-(IBAction)playSound:(id)sender{
    
    if(playState == 0){
        
        [player play];	
        
        UIImage *buttonImage = [UIImage imageNamed:@"pausebutton.png"];
        [playButton setImage:buttonImage forState:UIControlStateNormal];
        
        playState = 1;
        stopWatch = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
        timerEndTime = [NSDate timeIntervalSinceReferenceDate] + playLength + 0.2;
    }
    else {
        [player pause];	
        UIImage *buttonImage = [UIImage imageNamed:@"playbutton.png"];
        [playButton setImage:buttonImage forState:UIControlStateNormal];
        [self resetTimer];
        playState = 0;
    }
    
    
}

- (void)resetTimer
{
	if (stopWatch != nil)
	{
		[stopWatch invalidate];
    
		stopWatch = nil;
	}
	
	   	
}


- (void)showTimeRemaining:(NSTimeInterval)timeRemaining
{
	int minutesRemaining = timeRemaining/60;
	int secondsRemaining = timeRemaining-(minutesRemaining*60);
	
	NSString *timeRemainingString = [NSString stringWithFormat:@"%d:%02d",minutesRemaining,secondsRemaining];
	timeLabel.text = timeRemainingString;
}

- (void)timerTicked{
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval timeRemaining = timerEndTime-currentTime;
	
	if (timeRemaining <= 0.0)
	{
		// stop the timer
		
		
		// stop the music
		[player stop];
				
            
		timeRemaining = 0.0;
		
		// remove the timer
		[stopWatch invalidate];
		
		stopWatch = nil;
        
         UIImage *buttonImage = [UIImage imageNamed:@"playbutton.png"];
        [playButton setImage:buttonImage forState:UIControlStateNormal];
        playState = 0;
		
		
		
	}
	
	[self showTimeRemaining:timeRemaining];

    
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
    //self.title = @"Ambient Sound";
    imageView.image = [UIImage imageNamed:imageName];
    
    playState = 0;
    
    player = [[AVAudioPlayer alloc]
              initWithContentsOfURL:[NSURL fileURLWithPath:
                                     [[NSBundle mainBundle] pathForResource:soundFile ofType:@"m4a"]]
              error:nil];
    
    player.numberOfLoops = -1;
    
    [player prepareToPlay];
    NSTimeInterval timeRemaining = playLength;
    [self showTimeRemaining:timeRemaining];

   
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [player stop];
    player = nil;
    [stopWatch invalidate];
    stopWatch = nil;
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
