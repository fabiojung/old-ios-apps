//
//  PetsCareAppDelegate.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/07/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import "PetsCareAppDelegate.h"
#import "RootViewController.h"
#import "MigrationDB.h"
#import "SQLiteInstanceManager.h"

@interface PetsCareAppDelegate ()
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)checkDatabase;
- (void)updatePreferences;
- (void)performMigration;
- (BOOL)needsDatabaseMigration;
@end

@implementation PetsCareAppDelegate

@synthesize window;
@synthesize rootNavController;
@synthesize weightUnit;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[self createEditableCopyOfDatabaseIfNeeded];
	int count = cracked();
	RootViewController *tempRootController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *tempNavController = [[UINavigationController alloc] initWithRootViewController:tempRootController];
	[self setRootNavController:tempNavController];
	[tempRootController release];
	[tempNavController release];
	
	self.weightUnit = [[NSUserDefaults standardUserDefaults] objectForKey:@"units_preference"];
	
	if ([self needsDatabaseMigration]) {
		[NSThread detachNewThreadSelector:@selector(performMigration) toTarget:self withObject:nil];
	}

	[window addSubview:rootNavController.view];
    [window makeKeyAndVisible];
	
	if (count > 0) {
		[self checkDatabase];
	}
}

- (void)dealloc {
	[rootNavController release];
	[weightUnit release];
    [window release];
    [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	SQLiteInstanceManager *manager = [[SQLiteInstanceManager alloc] init];
	[manager vacuum];
	[manager release];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *documentsDirectory = [self applicationDocumentsDirectory];
	NSString *pathToDatabase = [documentsDirectory stringByAppendingPathComponent:@"petscare.sqlite3"];
	
	if ([fileManager fileExistsAtPath:pathToDatabase]) return;
	
    NSString *pathToEmptyDatabase = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"petscare.sqlite3"];
    BOOL success = [fileManager copyItemAtPath:pathToEmptyDatabase toPath:pathToDatabase error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	NSString *str = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] substringToIndex:2];
	if ([str isEqualToString:@"pt"] || [str isEqualToString:@"es"]) {
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:2] forKey:@"units_preference"];
	}
}

- (BOOL)needsDatabaseMigration {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [self applicationDocumentsDirectory];
	NSString *pathToOldDatabase = [documentsDirectory stringByAppendingPathComponent:@"petdb.sqlite"];
	if ([fileManager fileExistsAtPath:pathToOldDatabase]) {
		return YES;
	} else {
		[self updatePreferences];
	}
	return NO;
}

- (void)performMigration {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	RootViewController *rootViewController = (RootViewController *)[rootNavController topViewController];
	rootViewController.navigationItem.prompt = NSLocalizedString(@"Migration", nil);
	[rootViewController setEditable:NO];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *documentsDirectory = [self applicationDocumentsDirectory];
	NSString *pathToOldDatabase = [documentsDirectory stringByAppendingPathComponent:@"petdb.sqlite"];
	
	int oldDatabaseVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dbVersion"] intValue];
	int success = [MigrationDB performDatabaseMigration:oldDatabaseVersion];
	if (success) {
		NSString *renamedOldDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"petdb.old"];
		success = [fileManager moveItemAtPath:pathToOldDatabase toPath:renamedOldDatabasePath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to rename old database with message '%@'.", [error localizedDescription]);
		}
	}
	[self updatePreferences];
	[self performSelectorOnMainThread:@selector(migrationDone) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void)migrationDone {
	RootViewController *rootViewController = (RootViewController *)[rootNavController topViewController];
	[rootViewController refreshData];
	[rootViewController.tableView reloadData];
	rootViewController.navigationItem.prompt = nil;
	[rootViewController setEditable:YES];
}

- (void)updatePreferences {
	[[NSUserDefaults standardUserDefaults] setDouble:1.3 forKey:@"version"];
	[[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"dbVersion"];
}

- (void)checkDatabase {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *prefs = [paths objectAtIndex:0];	
	NSString *prefsPath = [prefs stringByAppendingPathComponent:@"Preferences/.com.itouchfactory.PetsCare"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {
		NSDictionary *newDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]
														   forKeys:[NSArray arrayWithObject:@"value"]];
		[newDic writeToFile:prefsPath atomically:YES];
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:prefsPath];
	int value = [[dic objectForKey:@"value"] intValue];
	if (value > 5) {
		NSString *string = [NSString stringWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=300417104&mt=8"];
		NSURL *link = [[NSURL alloc] initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:link];
		[link release];
	} else {
		value++;
		[dic setValue:[NSNumber numberWithInt:value] forKey:@"value"];
		[dic writeToFile:prefsPath atomically:YES];
	}
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
