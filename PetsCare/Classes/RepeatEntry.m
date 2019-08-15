//
//  RepeatEntry.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 02/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "RepeatEntry.h"
#import "DateHelper.h"

@implementation RepeatEntry

- (void)createRecurrentEventFor:(Event *)event {
	Event *newEvent = [[Event alloc] init];
	[newEvent setPetpk:event.petpk];
	[newEvent setEvent:event.event];
	[newEvent setDate:[DateHelper newDateForRepeatType:event.kindrepeat andDone:event.donedate]];
	[newEvent setIsdone:0];
	[newEvent setIslate:0];
	[newEvent setKindrepeat:event.kindrepeat];
	[newEvent save];
	[newEvent release];
}

- (void)createRecurrentHealthFor:(Health *)health {
	Health *newHealth = [[Health alloc] init];
	[newHealth setPetpk:health.petpk];
	[newHealth setType:health.type];
	[newHealth setInfotag:health.infotag];
	[newHealth setDate:[DateHelper newDateForRepeatType:health.kindrepeat andDone:health.donedate]];
	[newHealth setIsdone:0];
	[newHealth setIslate:0];
	[newHealth setKindrepeat:health.kindrepeat];
	[newHealth save];
	[newHealth release];
}

- (void) dealloc {
	[super dealloc];
}


@end
