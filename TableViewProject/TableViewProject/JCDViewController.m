//
//  JCDViewController.m
//  TableViewProject
//
//  Created by Jason Cui on 1/21/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"
#import "DetailViewController.h"

@interface JCDViewController () {
    NSArray *soundTitles;
    NSArray *imagethumbs;
}

@end

@implementation JCDViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Song Title";
    
    imagethumbs = [[NSArray alloc] initWithObjects:
                   @"thumbsongbird.jpg",
                   @"thumbWindChimes.jpg",
                   @"thumbRain.jpg",
                   @"thumbOceanWave.jpg",
                   @"thumbWhale.jpg",
                   nil];
    
    soundTitles = [[NSArray alloc] initWithObjects:
                   @"Singing Bird",
                   @"Wind Chimes",
                   @"Falling Rain",
                   @"Ocean",
                   @"Whale song",
                   nil];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.alpha = 0.9;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [soundTitles count];
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
    cell.textLabel.text =[soundTitles objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imagethumbs objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UIColor *selectedColor = [UIColor grayColor];
    UIView *myBackgroundColor = [[UIView alloc] init];
    [myBackgroundColor setBackgroundColor:selectedColor];
    
    [cell setSelectedBackgroundView:myBackgroundColor];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I did select row at the index path!");
    NSLog(@"Row %d", indexPath.row);
    
    NSString *selectedImage = [[NSString alloc] init];
    //NSString *selectedSound = [[NSString alloc] init];
    
    switch (indexPath.row)
    {
        case 0:
            selectedImage = @"songbird.jpg";
      //      selectedSound = @"birds";
            break;
        case 1:
            selectedImage = @"WindChimes.jpg";
      //      selectedSound = @"windchimes";
            break;
        case 2:
            selectedImage = @"Rain.jpg";
      //      selectedSound = @"rain";
            break;
        case 3:
            selectedImage = @"OceanWave.jpg";
      //      selectedSound = @"ocean";
            break;
        case 4:
            selectedImage = @"Whale.jpg";
      //      selectedSound = @"whales";
            break;
        default:
            break;
    }
    
    DetailViewController *detailScreen = [[DetailViewController alloc]
    initWithNibName:@"DetailViewController" bundle: [NSBundle mainBundle] ];
    
    detailScreen.imageName = selectedImage;
    detailScreen.soundName = [soundTitles objectAtIndex:indexPath.row];
    
    NSLog(@"selectedImage");
    NSLog(selectedImage);
    
    //detailScreen.
    
    [self.navigationController pushViewController:detailScreen animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
