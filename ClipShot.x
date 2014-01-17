/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <CoreFoundation/CoreFoundation.h>
#import <SpringBoard/SpringBoard.h>
#import "CSScreenShotter.h"
#import "PLPhotoStreamsHelper.h"

static void CSSettingsChangedNotification(
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo)
{
	[[CSScreenShotter sharedInstanceIfExists] reloadSettings];
}

static void CSSpringBoardHasBlankedScreenNotification(
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo)
{
	[[CSScreenShotter sharedInstanceIfExists] dismissMenu];
}

static void CSRegisterNotifications()
{
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		CSSettingsChangedNotification,
		CFSTR("com.mologie.clipshot.settingschanged"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
		);

	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		CSSpringBoardHasBlankedScreenNotification,
		CFSTR("com.apple.springboard.hasBlankedScreen"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
		);
}

%hook PLPhotoStreamsHelper

- (BOOL)shouldPublishScreenShots {
	return [CSScreenShotter sharedInstance].settingsUploadScreenshotsToPhotoStream;
}

%end

%hook SBScreenShotter

-(void)saveScreenshot:(BOOL)screenshot {
	[[CSScreenShotter sharedInstance] takeScreenshotAsSpecifiedByUser];
}

%end

%ctor
{
	CSRegisterNotifications();
}
