/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import "CSScreenshotViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <SpringBoard/SpringBoard.h>
#import <UIKit/UIKit.h>
#import "UIRemoteApplication+Private.h"

extern UIImage *_UICreateScreenUIImageWithRotation(BOOL rotate);
extern void PLSaveImageToCameraRollWithTypeAndExtension(UIImage *image, CFStringRef type, CFStringRef extension, id completionTarget, SEL completionSelector, void *contextInfo);

#define kPhotoShutterSystemSound 0x454

static CSScreenshotViewController *instance;

@implementation CSScreenshotViewController

+ (CSScreenshotViewController *)sharedInstance {
	if (!instance) {
		instance = [[CSScreenshotViewController alloc] init];
	}
	return instance;
}

+ (CSScreenshotViewController *)sharedInstanceIfExists {
	return instance;
}

- (UIImage *)captureScreenshot {
	UIImage *screenshot = _UICreateScreenUIImageWithRotation(TRUE);
	if (screenshot) {
		[self sendScreenshotNotificationToFrontMostApplication];
		[self presentFlashAnimationAndSound];
	} else {
		NSLog(@"UICreateScreenUIImageWithRotation failed");
	}
	return screenshot;
}

- (void)sendScreenshotNotificationToFrontMostApplication {
	SBApplication *frontMostApplication = [(SpringBoard *)UIApp _accessibilityFrontMostApplication];
	[frontMostApplication.remoteApplication didTakeScreenshot];
}

- (void)presentFlashAnimationAndSound {
	[(SBScreenFlash *)[%c(SBScreenFlash) sharedInstance] flash];
	AudioServicesPlaySystemSound(kPhotoShutterSystemSound);
}

- (void)screenshotToCameraRoll:(UIImage *)screenshot {
	if (!screenshot)
		return;
	PLSaveImageToCameraRollWithTypeAndExtension(
		screenshot,
		CFSTR("public.png"),
		CFSTR("PNG"),
		[%c(SBScreenShotter) sharedInstance],
		@selector(finishedWritingScreenshot:didFinishSavingWithError:context:),
		NULL
		);
}

- (void)screenshotToClipboard:(UIImage *)screenshot {
	if (!screenshot)
		return;
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	[pb setData:UIImagePNGRepresentation(screenshot) forPasteboardType:(__bridge NSString *)kUTTypePNG];
}

- (void)createWindow {
	UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	window.windowLevel = UIWindowLevelAlert;
	window.hidden = NO;
	window.rootViewController = self;
	self.window = window;
}

- (void)destroyWindow {
	self.window.rootViewController = nil;
	self.window.hidden = YES;
	self.window = nil;
}

- (void)show {
	if (self.isWritingScreenshot) {
		[self screenshotToCameraRoll:[self captureScreenshot]];
		return;
	}
	self.screenshot = [self captureScreenshot];
	if (!self.screenshot)
		return;
	self.isWritingScreenshot = YES;
	[self createWindow];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
		initWithTitle:@"Screenshot"
		delegate:self
		cancelButtonTitle:@"Cancel"
		destructiveButtonTitle:nil
	    otherButtonTitles:@"Save to camera roll", @"Save to clipboard", nil];
	[actionSheet showInView:self.view];
	self.actionSheet = actionSheet;
}

- (void)hide {
	[self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:NO];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
	case 0:
		[self screenshotToCameraRoll:self.screenshot];
		break;
	case 1:
		[self screenshotToClipboard:self.screenshot];
		break;	
	}
}

- (void)actionSheet:(UIActionSheet *)popup didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self destroyWindow];
	self.isWritingScreenshot = NO;
	self.actionSheet = nil;
}

@end
