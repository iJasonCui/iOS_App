//
//  DetailViewController.h
//  TableViewProject
//
//  Created by Jason Cui on 1/22/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *soundName;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end
