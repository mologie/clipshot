/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <Preferences/Preferences.h>
#import "CoreFoundationVersions.h"

@interface ClipShotSettingsListController : PSListController
@end

@implementation ClipShotSettingsListController

- (id)specifiers {
	if (_specifiers == nil) {
		NSArray *specifiers = [self loadSpecifiersFromPlistName:@"ClipShotSettings" target:self];
		if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_7_0) {
			NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
			[indexes addIndex:9];
			[indexes addIndex:10];
			NSMutableArray *newSpecifiers = [specifiers mutableCopy];
			[newSpecifiers removeObjectsAtIndexes:indexes];
			specifiers = newSpecifiers;
		}
		_specifiers = [specifiers retain];
	}
	return _specifiers;
}

- (void)visitWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cydia.mologie.com/package/com.mologie.clipshot/"]];
}

- (void)sendEmail:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support+cydia@mologie.com?subject=ClipShot"]];
}

@end
