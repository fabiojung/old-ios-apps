//
//  TaskAddViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 26/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "TaskAddViewController.h"
#import "DateHelper.h"
#import "Task.h"

@interface TaskAddViewController ()
- (void)cancel:(id)sender;
- (void)save:(id)sender;
- (void)showAlert;
@end

@implementation TaskAddViewController

- (id)init {
	if (self = [super init]) {
		[self setTitle:NSLocalizedString(@"AddTask_Loc", nil)];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																							   target:self action:@selector(cancel:)] autorelease];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																							 	target:self action:@selector(save:)] autorelease];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	self.editing = YES;	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	if (task.title != nil) titleTextField.text = task.title;
	task.sortOrder = self.sortOrder;
	priorityControl.enabled = YES;
	priorityControl.selectedSegmentIndex = [task.priority intValue];
}

- (void)save:(id)sender {
	[self saveTaskTitle];
	if (task.title == nil) {
		[self showAlert];
		return;
	}
	if (task.dueDate == nil) {
		task.dueDate = [DateHelper noDueDate];
	}
	[self.delegate activeViewController:self didSaveTask:task];
}

- (void)cancel:(id)sender {
	NSError *error = nil;
	[task.managedObjectContext deleteObject:task];
	
	if (![task.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}	
	
    [self.delegate activeViewController:self didSaveTask:nil];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	//if (task && task.title == nil) {
//		task.title = NSLocalizedString(@"NoTitle_Loc", nil);
//	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops..." 
													  message:NSLocalizedString(@"NoName_Loc", nil)
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"OK", nil];
	[myAlert show];
	[myAlert release];
}

@end
