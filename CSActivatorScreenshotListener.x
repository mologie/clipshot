/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <libactivator/libactivator.h>
#import "CSScreenShotter.h"

@interface CSActivatorScreenshotListener : NSObject<LAListener>
- (id)initWithAction:(SEL)action;
@property (nonatomic) SEL action;
@end

@implementation CSActivatorScreenshotListener

- (id)initWithAction:(SEL)action {
	if (self = [super init]) {
		self.action = action;
	}
	return self;
}

- (void)captureToCameraRoll {
	CSScreenShotter *screenShotter = [CSScreenShotter sharedInstance];
	[screenShotter saveScreenshotToCameraRoll:[screenShotter captureScreenshot]];
}

- (void)captureToClipboard {
	CSScreenShotter *screenShotter = [CSScreenShotter sharedInstance];
	[screenShotter saveScreenshotToClipboard:[screenShotter captureScreenshot]];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)even {
	[self performSelector:self.action];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
}

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
}

+ (void)load {
	Class activatorClass = %c(LAActivator);
	if (activatorClass) {
		LAActivator *activator = [activatorClass sharedInstance];
		[activator registerListener:[[self alloc] initWithAction:@selector(captureToCameraRoll)] forName:@"com.mologie.clipshot.captureToCameraRoll"];
		[activator registerListener:[[self alloc] initWithAction:@selector(captureToClipboard)] forName:@"com.mologie.clipshot.captureToClipboard"];
	}
}

@end 
