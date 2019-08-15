//
//  TarefasAppDelegate.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 20/08/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import "Migrator.h"

@interface TarefasAppDelegate : NSObject <UIApplicationDelegate, MigratorDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UIWindow *window;
    UINavigationController *navigationController;
	Migrator *sqliteMigrator;
    NSOperationQueue *operationQueue;
	BOOL isImporting;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, readonly) NSString *applicationPreferencesDirectory;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) Migrator *sqliteMigrator;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;

+ (void)setNextSortValue:(int)value;
+ (void)incrementNextSortValue;
+ (int)nextSortValue;
+ (void)setNextCategorySortValue:(int)value;
+ (void)incrementNextCategorySortValue;
+ (int)nextCategorySortValue;
- (void)validateCategoriesOrder;
@end

