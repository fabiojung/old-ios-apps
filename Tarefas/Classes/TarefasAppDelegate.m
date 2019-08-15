//
//  TarefasAppDelegate.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 20/08/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import "TarefasAppDelegate.h"
#import "RootViewController.h"
#import "Constants.h"
#import "LoadingView.h"
#import "ModelHelper.h"
#import "Category.h"
#import "Task.h"

@interface TarefasAppDelegate ()
- (void)fetchController;
@end

static NSString * const kSQLiteDatabaseFileName = @"todos.sqlite";
static int nextSortValue;
static int nextCategorySortValue;

@implementation TarefasAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize sqliteMigrator;


#pragma mark -
#pragma mark LoadingView methods

- (void)showLoadingView {
	LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0.0, 20.0, 320.0, 460.0)];
	loadingView.tag = LOAD_VIEW_TAG;
	[window addSubview:loadingView];
}

- (void)hideLoadingView {
	UIView *loadingView = (LoadingView *)[window viewWithTag:LOAD_VIEW_TAG];
	[UIView beginAnimations:@"CWFadeOut" context:(void *)loadingView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f];
	loadingView.alpha = 0.0;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark CoreData Stuff

+ (void)setNextSortValue:(int)value {
	nextSortValue = value;
}

+ (void)incrementNextSortValue {
	nextSortValue++;
}

+ (int)nextSortValue {
	return nextSortValue;
}

+ (void)setNextCategorySortValue:(int)value {
	nextCategorySortValue = value;
}

+ (void)incrementNextCategorySortValue {
	nextCategorySortValue++;
}

+ (int)nextCategorySortValue {
	return nextCategorySortValue;
}

- (void)saveWithContext:(NSManagedObjectContext *)context {
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Error saving data: %@, %@", error, [error userInfo]);
	}
}

- (void)deleteDoneTasks {
	NSError *error = nil;
	NSManagedObjectContext *context = [self managedObjectContext];
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"doneTasks"] copy];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil) {
		[fetchRequest release];
		return;
	}
	
	Task *tmpTask = nil;
	for (tmpTask in fetchedObjects) {
		[context deleteObject:tmpTask];
	}
	[self saveWithContext:context];
	[fetchRequest release];
}

- (void)setBadgeCountFor:(NSUInteger)option {
	NSUInteger count = 0;
	switch (option) {
		case 0:
			count = 0;
			break;
		case 1:
			count = [ModelHelper countLateTasksIn:[self managedObjectContext]];
			break;
		case 2:
			count = [ModelHelper countTodayTasksIn:[self managedObjectContext]];;
			break;
		case 3:
			count = [ModelHelper countNextSevenDaysTasksIn:[self managedObjectContext]];;
			break;
		case 4:
			count = [ModelHelper countLatePlusTodayTasksIn:[self managedObjectContext]];;
			break;
		case 5:
			count = [ModelHelper countLatePlusSevenDaysTasksIn:[self managedObjectContext]];;
			break;
		case 6:
			count = [ModelHelper countNotDoneTasksIn:[self managedObjectContext]];;
			break;
		default:
			break;
	}
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)updatePreferences {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
	if (![defaults objectForKey:@"firstRun"]) // Nenhuma versão instalada
	{ 
		[defaults setBool:YES forKey:@"firstRun"];
		[defaults setValue:@"" forKey:@"email"];
		[defaults setBool:NO forKey:@"autoDeleteTasks"];
		[defaults setDouble:2.0 forKey:@"version"];
		[defaults setInteger:0 forKey:@"SortOrder"];
		[defaults setInteger:0 forKey:@"iconBadge"];
	} 
	else if (![defaults objectForKey:@"version"])  // Versao 1.0 instalada
	{
		[defaults setDouble:2.0 forKey:@"version"];
		[defaults setInteger:0 forKey:@"SortOrder"];
		[defaults setInteger:0 forKey:@"iconBadge"];

		[defaults removeObjectForKey:@"showBadges"];
	} 
	else if ([[defaults objectForKey:@"version"] isEqualToNumber:[NSNumber numberWithDouble:1.1]]) // Versao 1.1 instalada
	{ 
		[defaults setDouble:2.0 forKey:@"version"];
		[defaults setInteger:3 forKey:@"SortOrder"];
		[defaults setInteger:0 forKey:@"iconBadge"];
		[defaults removeObjectForKey:@"showBadges"];
		[defaults removeObjectForKey:@"badgeCompletes"];
	} 
	else if ([[defaults objectForKey:@"version"] isEqualToNumber:[NSNumber numberWithDouble:1.2]]) // Versao 1.2 instalada
	{ 
		[defaults setDouble:2.0 forKey:@"version"];
		[defaults setInteger:3 forKey:@"SortOrder"];
		[defaults setInteger:0 forKey:@"iconBadge"];
		[defaults removeObjectForKey:@"showBadges"];
		[defaults removeObjectForKey:@"badgeCompletes"];
		[defaults removeObjectForKey:@"ActiveFilter"];
	}
}

- (void)validateTasksOrder {
	NSError *error = nil;
	NSManagedObjectContext *context = [self managedObjectContext];
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allTasks" substitutionVariables:nil];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil) {
		return;
	}
	NSUInteger idx = 0;
	Task *tmpTask = nil;
	for (tmpTask in fetchedObjects) {
		if (tmpTask.sortOrder.intValue != idx) {
			tmpTask.sortOrder = [NSNumber numberWithInteger:idx];
		}
		idx++;
	}
	[self saveWithContext:context];
}

- (void)validateCategoriesOrder {
	NSError *error = nil;
	NSManagedObjectContext *context = [self managedObjectContext];
	NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allCategories" substitutionVariables:nil];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES] autorelease]]];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil) {
		return;
	}
	NSUInteger idx = 0;
	Category *tmpCat = nil;
	for (tmpCat in fetchedObjects) {
		if (tmpCat.sortOrder.intValue != idx) {
			tmpCat.sortOrder = [NSNumber numberWithInteger:idx];
		}
		idx++;
	}
	[self saveWithContext:context];
}

#pragma mark -
#pragma mark Migrator methods

- (NSOperationQueue *)operationQueue {
    if (operationQueue == nil) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return operationQueue;
}

- (NSPersistentStoreCoordinator *)preparePersistentStoreCoordinatorForMigration {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathToSQLiteDatabase = [self.applicationDocumentsDirectory stringByAppendingPathComponent:kSQLiteDatabaseFileName];
    if ([fileManager fileExistsAtPath:pathToSQLiteDatabase]) {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Tarefas.sqlite"];
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        NSError *error;
        NSPersistentStore *newStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
        NSAssert2(newStore != nil, @"Failure adding persistent store at %@: %@", storePath, [error localizedFailureReason]);
        
        self.sqliteMigrator = [[[Migrator alloc] init] autorelease];
        sqliteMigrator.persistentStoreCoordinator = persistentStoreCoordinator;
        sqliteMigrator.pathToSQLiteDatabase = pathToSQLiteDatabase;
        sqliteMigrator.delegate = self;
        [self.operationQueue addOperation:sqliteMigrator];
        
		isImporting = YES;
		
        return persistentStoreCoordinator;        
    }
    return nil;
}

#pragma mark -
#pragma mark Migrator Delegate methods

- (void)migratorDidFinishMigration:(Migrator *)migrator {
	if ([NSThread isMainThread] == YES) {
        NSError *error = nil;
        BOOL removeOldDatabaseSuccess = [[NSFileManager defaultManager] removeItemAtPath:[self.applicationDocumentsDirectory stringByAppendingPathComponent:kSQLiteDatabaseFileName] error:&error];
        NSAssert1(removeOldDatabaseSuccess, @"Failure removing old database file: %@", [error localizedFailureReason]);
        
        RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
		[rootViewController reloadAll];
		[self hideLoadingView];
		isImporting = NO;
    } else {
        [self performSelectorOnMainThread:@selector(migratorDidFinishMigration:) withObject:migrator waitUntilDone:NO];
    }
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	isImporting = NO;
    UIImageView *backgroungImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stripe.png"]];
	backgroungImage.frame = CGRectMake(0.0, 20.0, 320.0, 460.0);
	[window addSubview:backgroungImage];
	[backgroungImage release];
	
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	rootViewController.managedObjectContext = self.managedObjectContext;
	
	[self validateCategoriesOrder];
	[self validateTasksOrder];
	
	[window addSubview:[navigationController view]];
    
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"];
	UIImage* backImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
	UIView* backView = [[UIImageView alloc] initWithImage:backImage];
	[backImage release];
	backView.frame = [[UIScreen mainScreen] applicationFrame];
	[window addSubview:backView];
	[UIView beginAnimations:@"CWFadeOut" context:(void *)backView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f];
	backView.alpha = 0.0;
	[UIView commitAnimations];	
	
	if (isImporting) [self showLoadingView];
	
	[window makeKeyAndVisible];
	
	if (isCracked()) {
		[self fetchController];
	}
}

- (void)animationDidStop:(NSString*)animationID 
				finished:(NSNumber*)finished
				 context:(void*)context 
{
	UIView* backView = (UIView*)context;
	[backView removeFromSuperview];
	[backView release];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges]) {
			[self saveWithContext:managedObjectContext];
        }
    }
	BOOL status = [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoDeleteTasks"] boolValue];
	if (status) [self deleteDoneTasks];
	NSUInteger option = [[[NSUserDefaults standardUserDefaults] objectForKey:@"iconBadge"] intValue];
	[self setBadgeCountFor:option];
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Tarefas.sqlite"];
	NSString *oldDBPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"todos.sqlite"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Tarefas" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
		[self updatePreferences];
	}
	
	if ([fileManager fileExistsAtPath:oldDBPath]) {
		[self preparePersistentStoreCoordinatorForMigration];
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

- (NSString *)applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)applicationPreferencesDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *prefs = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;	
	NSString *prefsPath = [prefs stringByAppendingPathComponent:@"Preferences/.com.itouchfactory.Tarefas"];
	return prefsPath;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[navigationController release];
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark AntiCrack

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *string = [NSString stringWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=300971757&mt=8"];
	NSURL *link = [[NSURL alloc] initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[[UIApplication sharedApplication] openURL:link];
	[link release];		
}

- (void)performActionWithTimer:(NSTimer *)theTimer {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertTitle_Loc", nil) 
													  message:NSLocalizedString(@"AlertMessage_Loc", nil)
													 delegate:self 
											cancelButtonTitle:NSLocalizedString(@"AlertButton_Loc", nil) 
											otherButtonTitles:nil];
	[myAlert show];
	[myAlert release];
}

- (void)fetchController {
	NSString *prefsPath = [self applicationPreferencesDirectory];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {
		NSDictionary *newDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"value", nil];
		[newDic writeToFile:prefsPath atomically:YES];
		[newDic release];
	}
	
	NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
	
	int value = [[dic objectForKey:@"value"] intValue];
	if (value > 4) {
		[NSTimer scheduledTimerWithTimeInterval:5 
										 target:self 
									   selector:@selector(performActionWithTimer:) 
									   userInfo:nil 
										repeats:NO];
	} else {
		value++;
		[dic setValue:[NSNumber numberWithInt:value] forKey:@"value"];
		[dic writeToFile:prefsPath atomically:YES];
	}
	[dic release];
}


@end

