//
//  RootViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 20/08/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelHelper.h"
#import "CategoryAddViewController.h"
#import "TaskDetailViewController.h"

@interface RootViewController : UIViewController <TaskDelegate,
												  CategoryAddDelegate,
												  UITableViewDelegate,
												  UITableViewDataSource,
												  NSFetchedResultsControllerDelegate> 
{
@private
	NSFetchedResultsController *fetchedResultsController;
	NSFetchedResultsController *fetchedResultsControllerForTasks;
	NSManagedObjectContext *managedObjectContext;
	NSUInteger allTasks, notDoneTasks, doneTasks, todayTasks, lateTasks;
	UITableView *rootTableView;
	UIBarButtonItem *addTaskButton;
	UIBarButtonItem *addListButton;
	UIBarButtonItem *configButton;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForTasks;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *rootTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *configButton;

- (IBAction)presentModalConfigView:(id)sender;
- (void)setEditable:(BOOL)editable;
- (void)reloadAll;
@end
