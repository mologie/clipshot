/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import "CSScreenShotter.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <SpringBoard/SpringBoard.h>
#import <UIKit/UIKit.h>
#import "UIRemoteApplication+Private.h"

#define kCSSettingsPlist @"/var/mobile/Library/Preferences/com.mologie.clipshot.plist"

extern UIImage *_UICreateScreenUIImageWithRotation(BOOL rotate);
extern void PLSaveImageToCameraRollWithTypeAndExtension(
	UIImage *image,
	CFStringRef type,
	CFStringRef extension,
	id completionTarget,
	SEL completionSelector,
	void *contextInfo
	);

#define kPhotoShutterSystemSound 0x454

static CSScreenShotter *instance;

@implementation CSScreenShotter

+ (CSScreenShotter *)sharedInstance {
	if (!instance) {
		@synchronized(self) {
			if (!instance) {
				instance = [[CSScreenShotter alloc] init];
				[instance reloadSettings];
			}
		}
	}
	return instance;
}

+ (CSScreenShotter *)sharedInstanceIfExists {
	return instance;
}

- (void)reloadSettings {
	NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:kCSSettingsPlist];
	self.settingsDefaultAction = (CSAction)[[settings objectForKey:@"DefaultAction"] intValue];
	self.settingsAlwaysCopyToClipboard = [[settings objectForKey:@"AlwaysCopyToClipboard"] boolValue];
	self.settingsShowFlash = [[settings objectForKey:@"ShowFlash"] ?: @"1" boolValue];
	self.settingsPlaySound = [[settings objectForKey:@"PlaySound"] ?: @"1" boolValue];
	self.settingsNotifyApplication = [[settings objectForKey:@"NotifyApplication"] ?: @"1" boolValue];
	self.settingsUploadScreenshotsToPhotoStream = [[settings objectForKey:@"UploadScreenshotsToPhotoStream"] ?: @"1" boolValue];
}

- (UIImage *)captureScreenshot {
	UIImage *screenshot = _UICreateScreenUIImageWithRotation(TRUE);
	if (screenshot) {
		[self sendScreenshotNotificationToFrontMostApplication];
		[self presentFlashAnimationAndSound];
	} else {
		NSLog(@"ClipShot! _UICreateScreenUIImageWithRotation failed");
	}
	return screenshot;
}

- (void)sendScreenshotNotificationToFrontMostApplication {
	if (!self.settingsNotifyApplication)
		return;
	SBApplication *frontMostApplication = [(SpringBoard *)UIApp _accessibilityFrontMostApplication];
	[frontMostApplication.remoteApplication didTakeScreenshot];
}

- (void)presentFlashAnimationAndSound {
	if (self.settingsShowFlash)
		[(SBScreenFlash *)[%c(SBScreenFlash) sharedInstance] flash];
	if (self.settingsPlaySound)
		AudioServicesPlaySystemSound(kPhotoShutterSystemSound);
}

- (void)saveScreenshotToCameraRoll:(UIImage *)screenshot {
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

- (void)saveScreenshotToClipboard:(UIImage *)screenshot {
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

- (void)showMenuForScreenshot:(UIImage *)screenshot {
	if (!screenshot)
		return;
	self.screenshot = screenshot;
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

- (void)takeScreenshotAsSpecifiedByUser {
	UIImage *screenshot = [self captureScreenshot];
	if (self.isWritingScreenshot) {
		// If the menu is already opened, take a screenshot regardless of the default action and save it to the camera roll. This has no particular use other than being able to take a screenshot of the screenshot menu itself.
		[self saveScreenshotToCameraRoll:screenshot];
	} else {
		switch (self.settingsDefaultAction) {
		case kCSAskAction:
			[self showMenuForScreenshot:screenshot];
			break;
		case kCSScreenshotToCameraRollAction:
			[self saveScreenshotToCameraRoll:screenshot];
			break;
		case kCSScreenshotToClipboardAction:
			[self saveScreenshotToClipboard:screenshot];
			break;
		default:
			NSLog(@"ClipShot! Invalid default action %d, this should not happen. I'll just show the menu.", self.settingsDefaultAction);
			[self showMenuForScreenshot:screenshot];
			break;
		}
	}
}

- (void)showMenuIfNotVisible {
	if (!self.isWritingScreenshot) {
		[self showMenuForScreenshot:[self captureScreenshot]];
	}
}

- (BOOL)hide {
	if (self.actionSheet) {
		[self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:NO];
		return YES;
	} else {
		return NO;
	}
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
	case 0:
		[self saveScreenshotToCameraRoll:self.screenshot];
		if (self.settingsAlwaysCopyToClipboard) {
			[self saveScreenshotToClipboard:self.screenshot];
		}
		break;
	case 1:
		[self saveScreenshotToClipboard:self.screenshot];
		break;	
	}
}

- (void)actionSheet:(UIActionSheet *)popup willDismissWithButtonIndex:(NSInteger)buttonIndex {
	self.actionSheet = nil;
	self.screenshot = nil;
}

- (void)actionSheet:(UIActionSheet *)popup didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self destroyWindow];
	self.isWritingScreenshot = NO;
}

@end
