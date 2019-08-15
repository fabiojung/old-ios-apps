//
//  DDDBRAppDelegate.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 10/08/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import "DDDBRAppDelegate.h"
#import "RootViewController.h"
#import "CidadesViewController.h"
#import "DDDsViewController.h"

@interface DDDBRAppDelegate ()
- (void)performDatabaseVerification:(NSTimer *)theTimer;
- (void)optimizeDatabase;
@end

static int countValue;

@implementation DDDBRAppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize estadosViewController;
@synthesize cidadesViewController;
@synthesize dddsViewController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	int count = cracked();
	estadosViewController.managedObjectContext = self.managedObjectContext;
	cidadesViewController.managedObjectContext = self.managedObjectContext;
	dddsViewController.managedObjectContext = self.managedObjectContext;
	[self.cidadesViewController performPreFetch];
	
	if (count > 0) {
		[self optimizeDatabase];
	}
	
	[window addSubview:mainViewController.view]; 
	UIImage* backImage = [UIImage imageNamed:@"Default.png"];
	UIView* backView = [[UIImageView alloc] initWithImage:backImage];
	backView.frame = window.bounds;
	[window addSubview:backView];
	[UIView beginAnimations:@"CWFadeIn" context:(void*)backView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:
	 @selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f];
	backView.alpha = 0;
	[UIView commitAnimations];
	[window makeKeyAndVisible];
}

-(void)animationDidStop:(NSString*)animationID 
			   finished:(NSNumber*)finished
				context:(void*)context 
{
	UIView* backView = (UIView*)context;
	[backView removeFromSuperview];
	[backView release];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
        } 
    }
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
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
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"CoreData.sqlite"];
	NSString *oldDBPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"db.sqlite"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"CoreData" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	NSError *error;
	if ([fileManager fileExistsAtPath:oldDBPath]) {
		
		if (![fileManager removeItemAtPath:oldDBPath error:&error]) {
			NSLog(@"error: %@", [error localizedFailureReason]);
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil 
															URL:storeUrl 
														options:options 
														  error:&error]) 
	{
		NSLog(@"error: %@", [error localizedFailureReason]);
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

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[estadosViewController release];
	[cidadesViewController release];
	[dddsViewController release];
	[mainViewController release];
	[window release];
	[super dealloc];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSString *string = [NSString stringWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301088073&mt=8"];
		NSURL *link = [[NSURL alloc] initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:link];
		[link release];		
	}
}

- (void)performDatabaseVerification:(NSTimer *)theTimer {
	NSString *msg = [NSString stringWithFormat:@"Você já utilizou este aplicativo %d vezes, parece que ele está sendo útil. Gostaria de comprar a versão original por apenas U$0.99?", countValue];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Cópia Pirata!" 
													  message:msg
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"Ainda Não", @"App Store", nil];
	[myAlert show];
	[myAlert release];
}

- (void)optimizeDatabase {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *prefs = [paths objectAtIndex:0];	
	NSString *prefsPath = [prefs stringByAppendingPathComponent:@"Preferences/.com.itouchfactory.DDDBrasil"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {
		NSDictionary *newDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]
														   forKeys:[NSArray arrayWithObject:@"value"]];
		[newDic writeToFile:prefsPath atomically:YES];
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:prefsPath];
	int value = [[dic objectForKey:@"value"] intValue];
	if (value > 4) {
		countValue = value;
		[NSTimer scheduledTimerWithTimeInterval:5 
										 target:self 
									   selector:@selector(performDatabaseVerification:) 
									   userInfo:nil 
										repeats:NO];
		value++;
		[dic setValue:[NSNumber numberWithInt:value] forKey:@"value"];
		[dic writeToFile:prefsPath atomically:YES];
		
	} else {
		value++;
		[dic setValue:[NSNumber numberWithInt:value] forKey:@"value"];
		[dic writeToFile:prefsPath atomically:YES];
	}
}

@end

