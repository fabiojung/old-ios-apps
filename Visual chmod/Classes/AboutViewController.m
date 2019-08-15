//
//  AboutViewController.m
//  Visual chmod
//
//  Created by Fabio Leonardo Jung on 07/01/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
- (id)infoValueForKey:(NSString*)key;
@end

@implementation AboutViewController

- (id)init {
	if (self = [super init]) {
		[self setTitle:@"# about"];
		self.tabBarItem.image = [UIImage imageNamed:@"about.png"];
	}
	return self;
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor clearColor]];
	self.view = contentView;
	[contentView release];
	
	UIImageView *bground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
																								pathForResource:@"aboutBG" 
																								ofType:@"png"]]];
	
	[contentView addSubview:bground];
	[bground release];
	
	
	UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 26)];
	[appName setBackgroundColor:[UIColor clearColor]];
	[appName setFont:[UIFont fontWithName:@"Courier-Bold" size:18]];
	[appName setTextColor:[UIColor greenColor]];
	[appName setText:[NSString stringWithFormat:@"%@", [self infoValueForKey:@"CFBundleName"]]];
	[appName setTextAlignment:UITextAlignmentCenter];
	[contentView addSubview:appName];
	[appName release];
	
	UILabel *appVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 320, 26)];
	[appVersion setBackgroundColor:[UIColor clearColor]];
	[appVersion setFont:[UIFont fontWithName:@"Courier-Bold" size:14]];
	[appVersion setTextColor:[UIColor greenColor]];
	[appVersion setText:[NSString stringWithFormat:@"%@ %@", @"Version", [self infoValueForKey:@"CFBundleVersion"]]];
	[appVersion setTextAlignment:UITextAlignmentCenter];
	[contentView addSubview:appVersion];
	[appVersion release];
	
	UIButton *mailBt = [UIButton buttonWithType:UIButtonTypeCustom];
	mailBt.frame = CGRectMake(275.0, 0.0, 44.0, 44.0);
	//mailBt.center = CGPointMake(160, 250);
	[mailBt setBackgroundColor:[UIColor clearColor]];
	[mailBt setImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateNormal];
	[mailBt setImage:[UIImage imageNamed:@"mailsend.png"] forState:UIControlStateHighlighted];
	[mailBt addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:mailBt];
	
	UILabel *appCopyright = [[UILabel alloc] initWithFrame:CGRectMake(0, 360, 320, 26)];
	[appCopyright setBackgroundColor:[UIColor clearColor]];
	[appCopyright setTextColor:[UIColor greenColor]];
	[appCopyright setFont:[UIFont fontWithName:@"Courier-Bold" size:16]];
	[appCopyright setText:[self infoValueForKey:@"NSHumanReadableCopyright"]];
	[appCopyright setTextAlignment:UITextAlignmentCenter];
	[contentView addSubview:appCopyright];
	[appCopyright release];
	
	UILabel *appRights = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, 320, 26)];
	[appRights setBackgroundColor:[UIColor clearColor]];
	[appRights setTextColor:[UIColor greenColor]];
	[appRights setFont:[UIFont fontWithName:@"Courier-Bold" size:12]];
	[appRights setText:@"All Rights Reserved."];
	[appRights setTextAlignment:UITextAlignmentCenter];
	[contentView addSubview:appRights];
	[appRights release];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)sendMail {
	NSString *string = [NSString stringWithFormat:@"mailto:%@?subject=%@", @"contact@itouchfactory.com", @"Visual chmod App"];
	NSURL *mail = [[NSURL alloc] initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[[UIApplication sharedApplication] openURL:mail];
	
	[mail release];
}

- (id)infoValueForKey:(NSString*)key
{
	if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}


- (void)dealloc {
    [super dealloc];
}


@end
