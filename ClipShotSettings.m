/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <Preferences/Preferences.h>

@interface ClipShotSettingsListController : PSListController
@end

@implementation ClipShotSettingsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ClipShotSettings" target:self] retain];
	}
	return _specifiers;
}

- (void)visitWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cydia.mologie.com/package/com.mologie.clipshot/"]];
}

@end
