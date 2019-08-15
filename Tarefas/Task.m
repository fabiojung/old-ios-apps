// 
//  Task.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 31/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Task.h"
#import "Category.h"
#import "DateHelper.h"

@implementation Task 

@dynamic hasDueDate;
@dynamic dueDate;
@dynamic isDone;
@dynamic priority;
@dynamic title;
@dynamic notes;
@dynamic recurrenceFrom;
@dynamic recurrenceOff;
@dynamic recurrence;
@dynamic sortOrder;
@dynamic completionDate;
@dynamic category;

- (TaskDateKeyPath)dateKeyPath {
	NSTimeInterval taskDate = [self.dueDate timeIntervalSinceReferenceDate];
	NSTimeInterval refDate = [[DateHelper todayDateWithoutTime] timeIntervalSinceReferenceDate];
	if ([self.hasDueDate intValue] == 0) return TaskDateKeyPathNoDueDate;
	if (taskDate < refDate) return TaskDateKeyPathOverdue;
	if (taskDate == refDate) return TaskDateKeyPathToday;
	refDate += 86400;
	if (taskDate == refDate) return TaskDateKeyPathTomorrow;
	refDate += 604800;
	if (taskDate < refDate) return TaskDateKeyPathNextDays;
	if (taskDate >= refDate) return TaskDateKeyPathFuture;
	
	return TaskDateKeyPathNoDueDate;
}

@end
