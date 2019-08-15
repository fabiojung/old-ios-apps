//
//  BaseView.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 28/09/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "BaseView.h"


@implementation BaseView

@synthesize bgImage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"stripe" ofType:@"png"];
        bgImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [bgImage drawAtPoint:CGPointMake(0, 0)];
}


- (void)dealloc {
	[bgImage release], bgImage = nil;
    [super dealloc];
}


@end
