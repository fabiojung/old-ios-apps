// 
//  Category.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 31/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

#import "Task.h"

@implementation Category 

@dynamic sortOrder;
@dynamic categoryName;
@dynamic tasks;

- (NSUInteger)countNotDoneTasks {
	if ([self.tasks count] == 0) {
		return 0;
	}
	NSUInteger count = 0;
	Task *aTask;
	
	for (aTask in [self tasks]) {
		if (aTask != nil) {
			if (aTask.isDone.intValue == 0) {
				count++;
			}
		}
	}
	return count;
}

@end
