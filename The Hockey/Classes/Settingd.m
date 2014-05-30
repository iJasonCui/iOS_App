//
//  Settingd.m
//  Hockey
//
//  Created by Reza Pekan on 10-07-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settingd.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation Settingd


@synthesize pickedItem, player;


#pragma mark MPMediaPickerControllerDelegate Implementation

//executes immediately after user selects song
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	self.pickedItem = mediaItemCollection.representativeItem;
	//remove iPod library view
	[self dismissModalViewControllerAnimated:YES];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark iPod Library
//executes once user clicks "Pick Song" button
- (void)pickASong:(id)sender {
	MPMediaPickerController *picker = [[MPMediaPickerController alloc]
									   initWithMediaTypes:MPMediaTypeMusic];
	picker.delegate = self;
	//display iPod library view as modal
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

//executes once iPod library view is removed
- (void)setPickedItem:(MPMediaItem *)newItem {
	//if same song, do nothing.  Otherwise prepare media player with
	
	if (pickedItem != newItem) {
		[pickedItem release];
		pickedItem = [newItem retain];
		
		// Archive picked item to preferences
		NSData *pickedItemArchivedData = [NSKeyedArchiver
										  archivedDataWithRootObject:pickedItem];
		[[NSUserDefaults standardUserDefaults]
		 setObject:pickedItemArchivedData forKey:@"PickedItem"];
		
		[[MPMusicPlayerController applicationMusicPlayer]
		 setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:
									 [NSArray arrayWithObject:pickedItem]]];
		//save time in creating instance of player
		if(player == nil){
			player = [MPMusicPlayerController applicationMusicPlayer];
		}
		//start play immediately after selection
		[player play];
	}
	

}




-(IBAction)done{
	[self dismissModalViewControllerAnimated:YES];

}
-(IBAction)volume{
	MPVolumeSettingsAlertShow();
	

	
	
}




/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end