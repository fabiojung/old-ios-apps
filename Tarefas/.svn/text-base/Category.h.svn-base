//
//  Category.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 31/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Task;

@interface Category :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSSet* tasks;

- (NSUInteger)countNotDoneTasks;

@end


@interface Category (CoreDataGeneratedAccessors)
- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)value;
- (void)removeTasks:(NSSet *)value;

@end

