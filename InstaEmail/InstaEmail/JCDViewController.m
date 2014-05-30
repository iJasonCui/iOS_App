//
//  JCDViewController.m
//  InstaEmail
//
//  Created by Jason Cui on 2/12/2014.
//  Copyright (c) 2014 Jason Cui. All rights reserved.
//

#import "JCDViewController.h"

@interface JCDViewController ()

@end

@implementation JCDViewController

@synthesize emailPicker=emailPicker_;
@synthesize noteField=noteField_;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    activities_ = [[NSArray alloc] initWithObjects:
                   @"sleeping",
                   @"eating",
                   @"thinking",
                   @"walking",
                   nil];
    
    feelings_ = [[NSArray alloc] initWithObjects:
                 @"happy",
                 @"sad",
                 @"anxious",
                 @"confused",
                 nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark -
# pragma mark Picker datasource protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0){
        return [activities_ count];
    }
    else {
        return [feelings_ count];
    }
}

# pragma mark -
# pragma mark Picker delegate protocol

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [activities_ objectAtIndex:row];
    }
    else {
        return [feelings_ objectAtIndex:row];
    }
    return nil;
}

# pragma mark -
# pragma mark Action
- (IBAction) sendButtonTapped:(id)sender {
    NSString* theMessage = [NSString stringWithFormat:@" %@ I am %@ and feeling %@ about it",
                            noteField_.text ? noteField_.text : @"",
                           [activities_ objectAtIndex: [emailPicker_ selectedRowInComponent:0]],
                           [feelings_ objectAtIndex: [emailPicker_ selectedRowInComponent:1]]
                           ];
    NSLog(@"%@", theMessage);
    NSLog(@"Email button tapped");
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailController=[[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Hello Renee"];
        [mailController setMessageBody:theMessage isHTML:NO];
        [self presentViewController:mailController animated:YES completion:nil];
        
    }
    else {
        NSLog(@"%@", @"Sorry, you need to set up email!");
    }
}

# pragma mark -
# pragma mark Mail composer delegate method
- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

# pragma mark -
# pragma mark textFieldDoneEditing
- (IBAction) textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}


@end
