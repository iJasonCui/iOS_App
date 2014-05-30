

#import <UIKit/UIKit.h>
#import "FTUtilsExample.h"

@interface SimpleAnimationExample : UIViewController<FTUtilsExample> {
	UIImageView *viewToAnimate_;	
	UIButton *performAnimationButton_;
	UISegmentedControl *directionControl_;
	
	UIView *uiViewToAnimate_;
	UITextView *uiTextViewToAnimate_;

}

@property(nonatomic,retain) UIImageView *viewToAnimate;
@property(nonatomic,retain) UIButton *performAnimationButton;
@property(nonatomic,retain) UISegmentedControl *directionControl;
@property(assign) BOOL hasDirectionControl;

@property(nonatomic,retain) UIView *uiViewToAnimate;
@property(nonatomic,retain) UITextView *uiTextViewToAnimate;


- (void)performAnimation:(id)sender;

@end
