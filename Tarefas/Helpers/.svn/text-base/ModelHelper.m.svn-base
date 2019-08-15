//
//  ModelHelper.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 11/09/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "ModelHelper.h"
#import "DateHelper.h"

@implementation ModelHelper

+ (NSUInteger)countAllTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allTasks" substitutionVariables:nil];
	NSUInteger allTasks = 0;
	allTasks = [context countForFetchRequest:fetchRequest error:&error];
		
	return allTasks;
}

+ (NSUInteger)countNotDoneTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"notDoneTasks"] copy];
	NSUInteger notDoneTasks = 0;
	notDoneTasks = [context countForFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	return notDoneTasks;
}

+ (NSUInteger)countDoneTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"doneTasks"] copy];
	NSUInteger doneTasks = 0;
	doneTasks = [context countForFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	return doneTasks;
}

+ (NSUInteger)countTodayTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSDictionary *substitutionDic = [NSDictionary dictionaryWithObjectsAndKeys:[DateHelper todayDateWithoutTime], @"TODAY", nil];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"todayTasks" substitutionVariables:substitutionDic];
	NSUInteger todayTasks = 0;
	todayTasks = [context countForFetchRequest:fetchRequest error:&error];
	return todayTasks;
}

+ (NSUInteger)countLateTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSDictionary *substitutionDic = [NSDictionary dictionaryWithObjectsAndKeys:[DateHelper todayDateWithoutTime], @"TODAY", nil];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"lateTasks" substitutionVariables:substitutionDic];
	NSUInteger lateTasks = 0;
	lateTasks = [context countForFetchRequest:fetchRequest error:&error];
	return lateTasks;
}

+ (NSUInteger)countNextSevenDaysTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSDate *startDate = [NSDate date];
	NSDate *endDate = [[NSDate date] addTimeInterval:604800];
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSDictionary *substitutionDic = [NSDictionary dictionaryWithObjectsAndKeys:
									 [DateHelper dateWithoutTimeFor:startDate], @"TODAY",
									 [DateHelper dateWithoutTimeFor:endDate], @"DATE", nil];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"sevenDaysTasks" substitutionVariables:substitutionDic];
	NSUInteger sevenDayTasks = 0;
	sevenDayTasks = [context countForFetchRequest:fetchRequest error:&error];
	return sevenDayTasks;
}

+ (NSUInteger)countLatePlusTodayTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSUInteger overdue = 0;
	NSUInteger today = 0;
	overdue = [self countLateTasksIn:context];
	today = [self countTodayTasksIn:context];
	return overdue + today;
}

+ (NSUInteger)countLatePlusSevenDaysTasksIn:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSUInteger overdue = 0;
	NSUInteger sevenDays = 0;
	overdue = [self countLateTasksIn:context];
	sevenDays = [self countNextSevenDaysTasksIn:context];
	return overdue + sevenDays;
}

+ (NSUInteger)countByCategory:(NSString *)name inContext:(NSManagedObjectContext *)context {
	if (context == nil) {
		return 0;
	}
	NSError *error = nil;
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSDictionary *substitutionDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"NAME", nil];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"countByCategory" substitutionVariables:substitutionDic];
	NSUInteger categoryTasks = 0;
	categoryTasks = [context countForFetchRequest:fetchRequest error:&error];
	return categoryTasks;
}
@end
