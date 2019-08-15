//
//  LoadingView.m
//  LoadingLayer
//
//  Created by Fabio Leonardo Jung on 26/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"

#define kIndicatorFrame CGRectMake(141.5, 211.0, 37.0, 37.0)
#define kLabelFrame CGRectMake(0.0, 255.0, 320.0, 50.0)

@implementation LoadingView

@synthesize indicator;
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.70];
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:kIndicatorFrame];
		indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[indicator startAnimating];
		[self addSubview:indicator];
		
		
		label = [[UILabel alloc] initWithFrame:kLabelFrame];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:15];
		label.textColor = [UIColor whiteColor];
		label.numberOfLines = 2;
		label.text = NSLocalizedString(@"ImportMSG_Loc", nil);
		
		[self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews {
	
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
	[indicator release], indicator = nil;
    [label release], label = nil;
    [super dealloc];
}


@end
