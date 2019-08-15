//
//  SecondViewController.m
//  Visual chmod
//
//  Created by Fabio Leonardo Jung on 07/01/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController

- (id)init {
	if (self = [super init]) {
		[self setTitle:@"# man chmod"];
		self.tabBarItem.image = [UIImage imageNamed:@"manpage.png"];
		
		contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		[contentView setBackgroundColor:[UIColor blackColor]];
		contentView.autoresizesSubviews = YES;
		self.view = contentView;
		[contentView release];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"man" ofType:@"html"];
		NSURL *url = [NSURL fileURLWithPath:path];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		
		UIWebView *manView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 416.0, 325.0)];
		[manView setBackgroundColor:[UIColor blackColor]];
		CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
		rotate = CGAffineTransformTranslate(rotate, +45, +45);
		[manView setTransform:rotate];
		[manView loadRequest:request];
		[contentView addSubview:manView];
		[manView setScalesPageToFit:YES];
		[manView release];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
