//
//  Settingd.h
//  Hockey
//
//  Created by Reza Pekan on 10-07-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface Settingd : UIViewController {
	AVAudioPlayer *theAudio;
	MPMediaItem *pickedItem;
	MPMusicPlayerController *player;
	MPMusicPlayerController *musicPlayer;
	MPMediaItemCollection *userMediaItemCollection;
	AVAudioPlayer *appSoundPlayer;
	BOOL playing ;
	
}
@property (nonatomic, retain) MPMediaItem *pickedItem;
@property(nonatomic, retain) MPMusicPlayerController *player;
-(IBAction)done;
-(IBAction)volume;

- (BOOL) useiPodPlayer;
-(IBAction)pickASong:(id)sender;


@end