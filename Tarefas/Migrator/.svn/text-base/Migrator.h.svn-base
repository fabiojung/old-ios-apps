//
//  Migrator.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 11/09/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol MigratorDelegate;

@interface Migrator : NSOperation {
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
    id <MigratorDelegate> delegate;
    NSString *pathToSQLiteDatabase;
}

@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) id <MigratorDelegate> delegate;
@property (nonatomic, retain) NSString *pathToSQLiteDatabase;

@end

@protocol MigratorDelegate <NSObject>

@optional

- (void)migratorDidFinishMigration:(Migrator *)migrator;
- (void)migratorDidSave:(NSNotification *)saveNotification;

@end