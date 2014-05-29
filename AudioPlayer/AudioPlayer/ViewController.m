//
//  ViewController.m
//  AudioPlayer
//
//  Created by David McMahon on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController (){
    
    NSArray *imagethumbs;
    NSArray *soundfiles;
    NSArray *soundtitles;
    
}

@end

@implementation ViewController

@synthesize tableView, timeSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = NSLocalizedString(@"Audio Player", @"Audio Player");
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    self.navigationController.navigationBar.translucent = YES;

	
    imagethumbs = [[NSArray alloc] initWithObjects:
                   @"thumbsongbird.jpg",
                   @"thumbWindChimes.jpg",
                   @"thumbRain.jpg",
                   @"thumbOceanWave.jpg",
                   @"thumbWhale.jpg",
                   nil];
    
    soundtitles = [[NSArray alloc] initWithObjects:
                   @"Singing Birds",
                   @"Wind Chimes",
                   @"Falling Rain",
                   @"Ocean",
                   @"Whale Song", 
                   nil];
    
    soundfiles = [[NSArray alloc] initWithObjects:
                  @"birds",
                  @"windchimes",
                  @"rain",
                  @"ocean",
                  @"whales",
                  nil];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.alpha = 0.9;

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [soundtitles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    // Configure the cell.
    cell.textLabel.text =[soundtitles objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imagethumbs objectAtIndex:indexPath.row]];
        
    cell.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
   
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedImage = [[NSString alloc] init];
    NSString *selectedSound = [[NSString alloc] init];
    
    switch (indexPath.row) {
        case 0:
            selectedImage = @"songbird.jpg";
            selectedSound = @"birds";
            break;
        case 1:
            selectedImage = @"WindChimes.jpg";
            selectedSound = @"windchimes";
            break;
        case 2:
            selectedImage = @"Rain.jpg";
            selectedSound = @"rain";
            break;
        case 3:
            selectedImage = @"OceanWave.jpg";
            selectedSound = @"ocean";
            break;
        case 4:
            selectedImage = @"Whale.jpg";
            selectedSound = @"whales";
            break;
        default:
            break;
    }
    
    DetailViewController *soundController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
    
    soundController.imageName = selectedImage;
    
    soundController.title = [soundtitles objectAtIndex:indexPath.row];
    
    soundController.soundFile = selectedSound;
    soundController.playLength = timeSlider.value*60;  //convert time to seconds
    
   [self.navigationController pushViewController:soundController animated:YES];
    
}

@end
