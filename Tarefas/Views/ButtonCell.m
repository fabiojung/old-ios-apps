//
//  ButtonCell.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 27/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

@synthesize indexPath;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
		// Drawing code
}


- (void)dealloc {
	[indexPath release], indexPath = nil;
    [super dealloc];
}

@end
