//
//  TaskDetailViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 24/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateViewController.h"
#import "RecurrenceViewController.h"
#import "CategoryViewController.h"
#import "NotesViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol TaskDelegate;
@class Task;

@interface TaskDetailViewController : UIViewController <UITextFieldDelegate, 
														UIActionSheetDelegate, 
														UITableViewDelegate, 
														UITableViewDataSource,
														DateViewControllerDelegate,
														RecurrenceViewControllerDelegate,
														CategoryViewControllerDelegate,
														NotesViewControllerDelegate, 
														MFMailComposeViewControllerDelegate>
{
	UITextField *titleTextField;
	UISegmentedControl *priorityControl;
	UITableView *taskTableView;
	UIView *mailButtonView;
	Task *task;
	NSNumber *sortOrder;
	id <TaskDelegate> delegate;
}

@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) NSNumber *sortOrder;
@property (nonatomic, assign) id <TaskDelegate> delegate;

- (void)saveTaskTitle;

@end

@protocol TaskDelegate <NSObject>
- (void)activeViewController:(UIViewController *)viewController didSaveTask:(Task *)aTask;
@end
