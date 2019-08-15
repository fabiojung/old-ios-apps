//
//  DDDBRAppDelegate.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 10/08/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

@class RootViewController, CidadesViewController, DDDsViewController;

@interface DDDBRAppDelegate : NSObject <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UIWindow *window;
	UITabBarController *mainViewController;
	RootViewController *estadosViewController;
	CidadesViewController *cidadesViewController;
	DDDsViewController *dddsViewController;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *mainViewController;
@property (nonatomic, retain) IBOutlet RootViewController *estadosViewController;
@property (nonatomic, retain) IBOutlet CidadesViewController *cidadesViewController;
@property (nonatomic, retain) IBOutlet DDDsViewController *dddsViewController;

@end

