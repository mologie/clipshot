/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <SpringBoard/SpringBoard.h>
#import "CSScreenshotViewController.h"

%hook SBScreenShotter

-(void)saveScreenshot:(BOOL)screenshot {
	[[CSScreenshotViewController sharedInstance] show];
}

%end

static void CSHasBlankedScreenNotification(
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo)
{
	[[CSScreenshotViewController sharedInstanceIfExists] hide];
}

static void CSRegisterNotifications()
{
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		CSHasBlankedScreenNotification,
		CFSTR("com.apple.springboard.hasBlankedScreen"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately
		);
} 

%ctor
{
	%init;
	CSRegisterNotifications();
}
