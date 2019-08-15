//
//  Weight.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "Weight.h"


@implementation Weight

@synthesize petpk;
@synthesize weight;
@synthesize date;

- (void) dealloc
{
	[weight release];
	[date release];
	[super dealloc];
}


@end
