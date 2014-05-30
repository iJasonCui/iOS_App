//
//  JCDViewController.h
//  InstaEmail
//
//  Created by Jason Cui on 2/12/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface JCDViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate> {
    UIPickerView *emailPicker_;
    NSArray* activities_;
    NSArray* feelings_;
    UITextField *noteField_;
}

@property (nonatomic, retain) IBOutlet UIPickerView *emailPicker;
@property (nonatomic, retain) IBOutlet UITextField  *noteField;

- (IBAction) sendButtonTapped: (id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;

@end
