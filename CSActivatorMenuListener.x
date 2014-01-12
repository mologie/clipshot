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
	return [[CSScreenShotter sharedInstance] hide];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)even {
	// Called when we recieve event
	if (![self dismiss]) {
		[[CSScreenShotter sharedInstance] showMenuIfNotVisible];
	}
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	// Called when event is escalated to a higher event
	// (short-hold sleep button becomes long-hold shutdown menu, etc)
	[self dismiss];
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
	// Called when some other listener received an event; we should cleanup
	[self dismiss];
}

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	// Called when the home button is pressed.
	// Call event's setHandled:YES if the UI was previously visible.
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
