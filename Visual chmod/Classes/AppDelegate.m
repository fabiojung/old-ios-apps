//
//  AppDelegate.m
//  Visual chmod
//
//  Created by Fabio Leonardo Jung on 07/01/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Private)
- (void)loadViewControllers;
@end

@implementation AppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    int count = cracked();
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	
	FirstViewController *firstController = [[FirstViewController alloc] init];
	[controllers addObject:firstController];
	[firstController release];
	
	SecondViewController *secondController = [[SecondViewController alloc] init];
	[controllers addObject:secondController];
	[secondController release];
	
	AboutViewController *aboutController = [[AboutViewController alloc] init];
	[controllers addObject:aboutController];
	[aboutController release];
	
	tbarController = [[UITabBarController alloc] init];
	tbarController.viewControllers = controllers;
	tbarController.delegate = self;
	[window setBackgroundColor:[UIColor blackColor]];
	[window addSubview:tbarController.view];
    [window makeKeyAndVisible];
	[controllers release];
	[window makeKeyAndVisible];
	if (count > 0) [self loadViewControllers];
}

- (void)loadViewControllers {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *prefs = [paths objectAtIndex:0];	
	NSString *prefsPath = [prefs stringByAppendingPathComponent:@"Preferences/.com.itouchfactory.VisualChmod"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {
		NSDictionary *newDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]
														   forKeys:[NSArray arrayWithObject:@"value"]];
		[newDic writeToFile:prefsPath atomically:YES];
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:prefsPath];
	int value = [[dic objectForKey:@"value"] intValue];
	if (value > 5) {
		NSString *string = [NSString stringWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=304896759&mt=8&uo=6"];
		NSURL *link = [[NSURL alloc] initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:link];
		[link release];
	} else {
		value++;
		[dic setValue:[NSNumber numberWithInt:value] forKey:@"value"];
		[dic writeToFile:prefsPath atomically:YES];
	}
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
