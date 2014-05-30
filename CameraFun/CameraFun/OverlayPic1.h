//
//  OverlayPic1.h
//  CameraFun
//
//  Created by Hoa Chen on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
 #import <UIKit/UIKit.h>
#import "BTLFullScreenCameraController.h"
#import "MBProgressHUD.h"

@interface OverlayPic1 : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate> {
    BTLFullScreenCameraController *camera;
    UIView *overlayView;
    BOOL cameraMode;
	CGPoint startTouchPosition;
	UILabel *overlayLabel;
    
    
}

@property (nonatomic, retain) BTLFullScreenCameraController *camera;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UILabel *overlayLabel;
@property (assign) BOOL cameraMode;
@property (nonatomic) CGPoint startTouchPosition;


- (void)initCamera;
- (void)toggleAugmentedReality;
- (void)startCamera;
- (void)onSingleTap:(UITouch*)touch;
- (void)onDoubleTap:(UITouch*)touch;
- (void)onSwipeUp;
- (void)onSwipeDown;
- (void)onSwipeLeft;
- (void)onSwipeRight;
- (void)cameraWillTakePicture:(id)sender;
- (void)cameraDidTakePicture:(id)sender;

@end

