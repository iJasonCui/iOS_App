


#import "SimpleAnimationExample.h"


//@interface HoorayNew : SimpleAnimationExample {
@interface Home : UIViewController {

	IBOutlet UITextView *textView;
	IBOutlet UIImageView *myImage;
	IBOutlet UIButton *button;
	IBOutlet UIView *myView;	
	IBOutlet UIImageView *viewToAnimate_;
	IBOutlet UIButton *performAnimationButton_;
	IBOutlet UISegmentedControl *directionControl_;	
	IBOutlet UIView *uiViewToAnimate_;
	IBOutlet UITextView *uiTextViewToAnimate_;	
	UIButton* btn1;
    UIButton* btn2;
	UIView *BarContainerView;

	
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView *myImage;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIView *myView;
@property(nonatomic,retain) UIView *uiViewToAnimate;
@property(nonatomic,retain) UITextView *uiTextViewToAnimate;
@property(nonatomic,retain) UIImageView *viewToAnimate;
@property(nonatomic,retain) UIButton *performAnimationButton;
@property(nonatomic,retain) UISegmentedControl *directionControl;



- (IBAction)performAnimation;

@end
