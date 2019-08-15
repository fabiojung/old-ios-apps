//
//  Task.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 31/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
    TaskDateKeyPathOverdue = 4,
    TaskDateKeyPathToday = 5,
    TaskDateKeyPathTomorrow = 6,
	TaskDateKeyPathNextDays = 7,
	TaskDateKeyPathFuture = 8,
	TaskDateKeyPathNoDueDate = 9
} TaskDateKeyPath;


@class Category;

@interface Task :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * hasDueDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * recurrenceFrom;
@property (nonatomic, retain) NSNumber * recurrenceOff;
@property (nonatomic, retain) NSNumber * recurrence;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSDate * completionDate;
@property (nonatomic, retain) Category * category;

@end



