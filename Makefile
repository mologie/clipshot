#
# Makefile for ClipShot
# http://cydia.mologie.com/package/com.mologie.clipshot/
#

TWEAK_NAME = ClipShot
ClipShot_FILES = ClipShot.x CSScreenShotter.x CSActivatorMenuListener.x CSActivatorScreenshotListener.x
ClipShot_FRAMEWORKS = AudioToolbox MobileCoreServices UIKit
ClipShot_PRIVATE_FRAMEWORKS = PhotoLibrary
ClipShot_CFLAGS = -Iheaders

BUNDLE_NAME = ClipShotSettings
ClipShotSettings_FILES = ClipShotSettings.m
ClipShotSettings_INSTALL_PATH = /Library/PreferenceBundles
ClipShotSettings_FRAMEWORKS = UIKit
ClipShotSettings_PRIVATE_FRAMEWORKS = Preferences
ClipShotSettings_RESOURCE_DIRS = ClipShotSettings

# Use make DEBUG=1 for building binaries which output logs
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	CFLAGS = -DDEBUG
endif

# Target the iPhone 3GS and all later devices
ARCHS = armv7 armv7s arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 6.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0

include framework/makefiles/common.mk
include framework/makefiles/bundle.mk
include framework/makefiles/tweak.mk

after-stage::
	$(ECHO_NOTHING)find "$(THEOS_STAGING_DIR)" -iname '*.plist' -exec plutil -convert binary1 "{}" \;$(ECHO_END)
	$(ECHO_NOTHING)find "$(THEOS_STAGING_DIR)" -iname '*.png' -exec /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush -q -iphone "{}" "{}.crushed" \; -exec mv "{}.crushed" "{}" \;$(ECHO_END)
