/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <libactivator/libactivator.h>
#import "CSScreenShotter.h"

@interface CSActivatorScreenshotListener : NSObject<LAListener>
@end

@implementation CSActivatorScreenshotListener

- (void)captureToCameraRoll {
	CSScreenShotter *screenShotter = [CSScreenShotter sharedInstance];
	[screenShotter saveScreenshotToCameraRoll:[screenShotter captureScreenshot]];
}

- (void)captureToClipboard {
	CSScreenShotter *screenShotter = [CSScreenShotter sharedInstance];
	[screenShotter saveScreenshotToClipboard:[screenShotter captureScreenshot]];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
	NSString *selector = [activator infoDictionaryValueOfKey:@"selector" forListenerWithName:listenerName];
	objc_msgSend(self, NSSelectorFromString(selector), activator, event, listenerName);
	[event setHandled:YES];
}

+ (void)load {
	Class activatorClass = %c(LAActivator);
	if (activatorClass) {
		LAActivator *activator = [activatorClass sharedInstance];
		CSActivatorScreenshotListener *screenshotListener = [[CSActivatorScreenshotListener alloc] init];
		[activator registerListener:screenshotListener forName:@"com.mologie.clipshot.captureToCameraRoll"];
		[activator registerListener:screenshotListener forName:@"com.mologie.clipshot.captureToClipboard"];
	}
}

@end 
