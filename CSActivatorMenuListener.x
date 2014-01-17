/**
 * This file is part of ClipShot
 * Copyright 2014 Oliver Kuckertz <oliver.kuckertz@mologie.de>
 * See COPYING for licensing information.
 */

#import <libactivator/libactivator.h>
#import "CSScreenShotter.h"

@interface CSActivatorMenuListener : NSObject<LAListener>
@end

@implementation CSActivatorMenuListener

- (BOOL)dismiss {
	return [[CSScreenShotter sharedInstance] dismissMenu];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[[CSScreenShotter sharedInstance] showMenuIfNotVisible];
	[event setHandled:YES];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	[self dismiss];
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
	[self dismiss];
}

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	if ([self dismiss]) {
		[event setHandled:YES];
	}
}

+ (void)load {
	Class activatorClass = %c(LAActivator);
	if (activatorClass) {
		LAActivator *activator = [activatorClass sharedInstance];
		[activator registerListener:[[self alloc] init] forName:@"com.mologie.clipshot.openMenu"];
	}
}

@end 
