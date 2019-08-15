//
//  TasksViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 24/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TasksViewController : UIViewController <TaskDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
@private
	NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
	UITableView *tasksTableView;
	UIBarButtonItem *mailButton;
	UIBarButtonItem *sortButton;
	UIBarButtonItem *configButton;
	UIBarButtonItem *trashButton;
	UILabel *noTasksLabel;
	BOOL hasTasks;
	
	NSNumber *sortOrder;
	NSNumber *predicateNumber;
	NSString *predicateCategory;
	NSString *navigationBarTitle;
	NSTimer *fetchTimer;
	
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSNumber *sortOrder;
@property (nonatomic, retain) NSNumber *predicateNumber;
@property (nonatomic, retain) NSString *predicateCategory;
@property (nonatomic, retain) UILabel *noTasksLabel;
@property (nonatomic, copy) NSString *navigationBarTitle;
@property (nonatomic, retain) IBOutlet UITableView *tasksTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sortButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *configButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *trashButton;
@property (assign) NSTimer *fetchTimer;

- (IBAction)didSendEmail:(id)sender;
- (IBAction)didSortTasks:(id)sender;
- (IBAction)presentModalConfigView:(id)sender;
- (IBAction)setEditingTableView:(id)sender;

@end
