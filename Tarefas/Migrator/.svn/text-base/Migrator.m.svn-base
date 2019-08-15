//
//  Migrator.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 11/09/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "Migrator.h"
#import "Task.h"
#import "DateHelper.h"
#import <sqlite3.h>

@implementation Migrator

@synthesize persistentStoreCoordinator;
@synthesize delegate;
@synthesize pathToSQLiteDatabase;

- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext == nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    }
    return managedObjectContext;
}

- (void)dealloc {
    [persistentStoreCoordinator release];
    [managedObjectContext release];
    [pathToSQLiteDatabase release];
    [super dealloc];
}

- (void)main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *taskEntityDescription = [[NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc] retain];
    
    sqlite3 *db;
    NSLog(@"opening store at %@", self.pathToSQLiteDatabase);
    int success = sqlite3_open([self.pathToSQLiteDatabase UTF8String], &db);
    NSAssert1(success == SQLITE_OK, @"Failed to open sqlite database: %s", sqlite3_errmsg(db));
    sqlite3_stmt *statement;
    success = sqlite3_prepare_v2(db, "SELECT pk, name, notes, complete, date, priority FROM tasks ORDER BY pk LIMIT ? OFFSET ?", -1, &statement, NULL);
    NSAssert1(success == SQLITE_OK, @"Failed to prepare sqlite statement: %s", sqlite3_errmsg(db));
    NSUInteger iteration = 0;
    
	NSError *error = nil;
    static NSUInteger const kImportingBatchSize = 50;
    BOOL finished = NO;
    do {
        sqlite3_bind_int(statement, 1, kImportingBatchSize);
        sqlite3_bind_int(statement, 2, kImportingBatchSize * iteration);
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            do {
                Task *task = [[Task alloc] initWithEntity:taskEntityDescription insertIntoManagedObjectContext:moc];
                
				int pKey = sqlite3_column_int(statement, 0);
				task.sortOrder = [NSNumber numberWithInteger:pKey];
				
                char *tmp = (char *)sqlite3_column_text(statement, 1);
                task.title = (tmp != NULL) ? [NSString stringWithUTF8String:tmp] : @"no title";
                
				tmp = (char *)sqlite3_column_text(statement, 2);
                task.notes = (tmp != NULL) ? [NSString stringWithUTF8String:tmp] : nil;
				
				int done = sqlite3_column_int(statement, 3);
				if (done > 1 || done < 0) done = 1;
				task.isDone = [NSNumber numberWithInteger:done];
				
                double secondsSince1970 = sqlite3_column_double(statement, 4);
				
				if (secondsSince1970 == 0.0 || secondsSince1970 == 4102483357.0) {
					task.dueDate = [DateHelper noDueDate];
				} else {
					NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondsSince1970];
					task.dueDate = [DateHelper dateWithoutTimeFor:date];
					task.hasDueDate = [NSNumber numberWithInteger:1];
				}
				
				int priority = sqlite3_column_int(statement, 5);
				if (priority > 3 || priority < 0) priority = 3;
				task.priority = [NSNumber numberWithInteger:priority];
				
				[task release];
				[moc save:&error];
            } while (sqlite3_step(statement) == SQLITE_ROW);

            sqlite3_reset(statement);
            iteration++;
				
            
            [pool drain];
            pool = [[NSAutoreleasePool alloc] init];
        } else {
            finished = YES;
        }
        
    } while (finished == NO);
    
    [taskEntityDescription release];

    sqlite3_finalize(statement);
    sqlite3_close(db);
    if (delegate && [delegate respondsToSelector:@selector(migratorDidFinishMigration:)]) {
        [delegate performSelector:@selector(migratorDidFinishMigration:) withObject:self];
    }
    [managedObjectContext release];
    managedObjectContext = nil;
    [pool drain];    
}

@end
