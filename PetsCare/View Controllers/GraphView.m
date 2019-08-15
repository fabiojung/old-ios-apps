//
//  GraphView.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 29/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "GraphView.h"


@implementation GraphView

@synthesize weights, weightUnit, petpk;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
		self.weights = [NSMutableArray array];
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setWeights:(NSMutableArray *)newWeights {
	if (newWeights == weights)
		return;
	
	[newWeights retain];
	[weights release];
	weights = newWeights;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
									   pathForResource:@"graph" 
									   ofType:@"png"]] drawAtPoint:CGPointZero];
}


- (void)dealloc 
{
	self.weights = nil;
	[weightUnit release];
    [super dealloc];
}

@end
