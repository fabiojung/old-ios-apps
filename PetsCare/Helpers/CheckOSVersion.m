//
//  CheckOSVersion.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 15/07/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "CheckOSVersion.h"

static int majorVersion;

@implementation CheckOSVersion

+ (int)iPhoneOSMajorVersion {
	if (majorVersion == 0) {
		NSString *version = [[UIDevice currentDevice] systemVersion];
		majorVersion = [[version substringToIndex:1] intValue];
	}
	return majorVersion;
}

+ (BOOL)isNewOS {
	return [self iPhoneOSMajorVersion] >=3;
}

@end
