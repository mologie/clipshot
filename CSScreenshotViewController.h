/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#pragma once

#import <UIKit/UIKit.h>

@interface CSScreenshotViewController : UIViewController <UIActionSheetDelegate>

+ (CSScreenshotViewController *)sharedInstance;
+ (CSScreenshotViewController *)sharedInstanceIfExists;
- (void)show;
- (void)hide;

@property (nonatomic, assign) UIImage *screenshot;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic) BOOL isWritingScreenshot;

@end
