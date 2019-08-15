//
//  ModelHelper.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 11/09/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelHelper : NSObject {

}

+ (NSUInteger)countAllTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countNotDoneTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countDoneTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countTodayTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countLateTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countNextSevenDaysTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countLatePlusTodayTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countLatePlusSevenDaysTasksIn:(NSManagedObjectContext *)context;
+ (NSUInteger)countByCategory:(NSString *)name inContext:(NSManagedObjectContext *)context;
@end
