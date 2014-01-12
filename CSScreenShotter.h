/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#pragma once

#import <UIKit/UIKit.h>

typedef enum _CSAction {
	kCSAskAction,
	kCSScreenshotToCameraRollAction,
	kCSScreenshotToClipboardAction
} CSAction;

@interface CSScreenShotter : UIViewController <UIActionSheetDelegate>

+ (CSScreenShotter *)sharedInstance;
+ (CSScreenShotter *)sharedInstanceIfExists;
- (void)reloadSettings;
- (UIImage *)captureScreenshot;
- (void)saveScreenshotToCameraRoll:(UIImage *)screenshot;
- (void)saveScreenshotToClipboard:(UIImage *)screenshot;
- (void)takeScreenshotAsSpecifiedByUser;
- (void)showMenuIfNotVisible;
- (BOOL)hide;

@property (nonatomic, assign) UIImage *screenshot;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic) BOOL isWritingScreenshot;
@property (nonatomic) CSAction settingsDefaultAction;
@property (nonatomic) BOOL settingsAlwaysCopyToClipboard;
@property (nonatomic) BOOL settingsShowFlash;
@property (nonatomic) BOOL settingsPlaySound;
@property (nonatomic) BOOL settingsNotifyApplication;
@property (nonatomic) BOOL settingsUploadScreenshotsToPhotoStream;

@end
