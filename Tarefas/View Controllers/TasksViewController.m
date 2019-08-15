//
//  TasksViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 24/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "TasksViewController.h"
#import "UITableViewCellTask.h"
#import "TarefasAppDelegate.h"
#import "TaskAddViewController.h"
#import "ConfigViewController.h"
#import "Constants.h"
#import "ButtonCell.h"
#import "DateHelper.h"
#import "StringsHelper.h"
#import "Task.h"
#import "Category.h"

@interface TasksViewController ()
- (void)configureCell:(UITableViewCellTask *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSPredicate *)predicateForCase:(NSNumber *)aCase;
- (NSArray *)sortDescriptorsForCase:(NSNumber *)aCase;
- (NSString *)secNameKeyPathForCase:(NSNumber *)aCase;
- (void)sendTaskByMailTo:(BOOL)me;
- (void)showAlert;
@end

@implementation TasksViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize tasksTableView;
@synthesize mailButton;
@synthesize sortButton;
@synthesize configButton;
@synthesize trashButton;
@synthesize sortOrder;
@synthesize predicateNumber;
@synthesize predicateCategory;
@synthesize noTasksLabel;
@synthesize navigationBarTitle;
@synthesize fetchTimer;

- (void)showNoTasksLabel:(BOOL)show {
	if (show) {
		int idx = predicateNumber.intValue;
		NSString *text = nil;
		NSString *locStr = nil;
		switch (idx) {
			case 0:
				text = NSLocalizedString(@"NoTask_Loc", nil);
				break;
			case 1:
				text = NSLocalizedString(@"NoTodayTask_Loc", nil);
				break;
			case 2:
				text = NSLocalizedString(@"NoOverdueTask_Loc", nil);
				break;
			case 3:
				text = NSLocalizedString(@"NoCompletedTask_Loc", nil);
				break;
			case 4:
				locStr = NSLocalizedString(@"NoListTask_Loc", nil);
				NSString *locList = NSLocalizedString(predicateCategory, nil);
				text = [NSString stringWithFormat:locStr, locList];
				break;
			default:
				break;
		}
		noTasksLabel.text = text;
		noTasksLabel.alpha = 1.0;
	} else {
		noTasksLabel.alpha = 0.0;
	}
}

- (void)setToolBarIconsEnable:(BOOL)enable {
	mailButton.enabled = enable;
	sortButton.enabled = enable;
}

- (void)reloadData {
	[self.tasksTableView reloadData];
	NSUInteger objCount = [fetchedResultsController.fetchedObjects count];
	if (objCount == 0) {
		[self showNoTasksLabel:YES];
		[self setToolBarIconsEnable:NO];
		hasTasks = NO;
	} else {
		[self showNoTasksLabel:NO];
		[self setToolBarIconsEnable:YES];
		hasTasks = YES;
	}

}

- (void)fetch {
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"fetchedResultsController ERROR");
	} else {
		[self reloadData];
	}
	if (fetchTimer) fetchTimer = nil;
}

- (void)dealloc {
	[navigationBarTitle release];
	[sortOrder release];
	[predicateNumber release];
	[predicateCategory release];
	[tasksTableView release];
	[mailButton release];
	[sortButton release];
	[configButton release];
	[trashButton release];
	[fetchedResultsController release];
	[managedObjectContext release];
	managedObjectContext = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.navigationBarTitle;
	self.tasksTableView.backgroundColor = [UIColor clearColor];
	self.tasksTableView.rowHeight = 60;
	self.view.backgroundColor = [UIColor clearColor];
	
	self.sortOrder = [[NSUserDefaults standardUserDefaults] valueForKey:@"SortOrder"];
	
	UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																				target:self 
																				action:@selector(addNewTask)];
	self.navigationItem.rightBarButtonItem = tempButton;
	[tempButton release];
	
	noTasksLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 120.0, 320.0, 60.0)];
	noTasksLabel.backgroundColor = [UIColor clearColor];
	noTasksLabel.font = [UIFont boldSystemFontOfSize:20];
	noTasksLabel.textColor = [UIColor whiteColor];
	noTasksLabel.textAlignment = UITextAlignmentCenter;
	noTasksLabel.shadowColor = [UIColor darkGrayColor];
	noTasksLabel.shadowOffset = CGSizeMake(-1, -1);
	noTasksLabel.numberOfLines = 2;
	noTasksLabel.lineBreakMode = UILineBreakModeWordWrap;
	noTasksLabel.alpha = 0.0;
	[self.tasksTableView addSubview:noTasksLabel];
	[noTasksLabel release];
	
	[self fetch];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.mailButton = nil;
	self.sortButton = nil;
	self.configButton = nil;
	self.trashButton = nil;
	self.tasksTableView = nil;
	self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[self fetch];
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeTaskStatus:(id)sender {
	if (self.editing) {
		return;
	}
	NSError *error = nil;
	
	if (fetchTimer) {
		[fetchTimer invalidate];
		fetchTimer = nil;
	}
	
	NSIndexPath *indexPath = [sender indexPath];
	UITableViewCellTask *cell = (UITableViewCellTask *)[self.tasksTableView cellForRowAtIndexPath:indexPath];
	Task *aTask = [fetchedResultsController objectAtIndexPath:indexPath];

	int currentStatus = [aTask.isDone intValue];
	
	if (currentStatus == 0) {
		aTask.isDone = [NSNumber numberWithInteger:1];
		aTask.completionDate = [DateHelper dateWithoutTimeFor:[NSDate date]];
		if ([aTask.recurrence intValue] > 0 && [aTask.recurrenceOff intValue] == 0) {
			Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" 
														  inManagedObjectContext:managedObjectContext];
			newTask.title = aTask.title;
			newTask.priority = aTask.priority;
			newTask.notes = aTask.notes;
			newTask.category = aTask.category;
			newTask.sortOrder = [NSNumber numberWithInteger:[TarefasAppDelegate nextSortValue]];
			newTask.recurrenceFrom = aTask.recurrenceFrom;
			newTask.recurrence = aTask.recurrence;
			newTask.hasDueDate = [NSNumber numberWithInteger:1];
			if (aTask.hasDueDate.intValue == 0 || aTask.recurrenceFrom.intValue == 1) {
				newTask.dueDate = [DateHelper dateForRepeatType:aTask.recurrence.intValue 
														andDone:[DateHelper todayDateWithoutTime]];
			} else if (aTask.recurrenceFrom.intValue == 0) {
				newTask.dueDate = [DateHelper dateForRepeatType:aTask.recurrence.intValue 
														andDone:aTask.dueDate];
			}
			aTask.recurrenceOff = [NSNumber numberWithInteger:1];
		}
		[cell setCellCheckedWithAnimation];
	} else if (currentStatus == 1) {
		aTask.isDone = [NSNumber numberWithInteger:0];
		aTask.completionDate = nil;
		[cell setCellUncheckedWithAnimation];
	}
	
	if (![aTask.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	} else {
		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(fetch) userInfo:nil repeats:NO];
		self.fetchTimer = timer;
	}
}

- (IBAction)didSendEmail:(id)sender {
	UIActionSheet *menu = [[UIActionSheet alloc] 
						   initWithTitle:NSLocalizedString(@"SendTo_Loc", nil)
						   delegate:self
						   cancelButtonTitle:NSLocalizedString(@"Cancel_Loc", nil)
						   destructiveButtonTitle:NSLocalizedString(@"Me_Loc", nil)
						   otherButtonTitles:NSLocalizedString(@"Other_Loc", nil), nil];
	menu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	menu.tag = MAIL_MENU_TAG;
	[menu showInView:self.view];
	[menu release];
}

- (IBAction)didSortTasks:(id)sender {
	UIActionSheet *menu = [[UIActionSheet alloc] 
						   initWithTitle:NSLocalizedString(@"Sort_Loc", nil)
						   delegate:self
						   cancelButtonTitle:NSLocalizedString(@"Original_Loc", nil)
						   destructiveButtonTitle:nil
						   otherButtonTitles:NSLocalizedString(@"ByDate_Loc", nil), NSLocalizedString(@"ByPriority_Loc", nil), NSLocalizedString(@"ByChar_Loc", nil), nil];
	menu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	menu.tag = SORT_MENU_TAG;
	[menu showInView:self.view];
	[menu release];
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops..." 
													  message:NSLocalizedString(@"NoEmail_Loc", @"")
													 delegate:self 
											cancelButtonTitle:NSLocalizedString(@"No_Loc", @"") 
											otherButtonTitles:NSLocalizedString(@"Yes_Loc", @""), nil];
	[myAlert show];
	[myAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self presentModalConfigView:nil];
	}
}

- (IBAction)presentModalConfigView:(id)sender {
	ConfigViewController *configController = [[ConfigViewController alloc] init];
	UINavigationController *configNavController = [[UINavigationController alloc] initWithRootViewController:configController];
	[configController release];
	configNavController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController presentModalViewController:configNavController animated:YES];
	[configNavController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([actionSheet tag] == MAIL_MENU_TAG) {
		switch (buttonIndex) {
			case 0: //My Email
				[self sendTaskByMailTo:YES];
				break;
			case 1: //Other Email
				[self sendTaskByMailTo:NO];
				break;
			default: //None
				break;
		}
	} else if ([actionSheet tag] == SORT_MENU_TAG) {
		
		self.sortOrder = [NSNumber numberWithInteger:buttonIndex];
		[[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"SortOrder"];
		[self fetch];
	}
}

- (IBAction)setEditingTableView:(id)sender {
	if (self.editing) {
		[self setEditing:NO animated:YES];
	} else {
		[self setEditing:YES animated:YES];
	}
}

- (void)addNewTask {
	TaskAddViewController *controller = [[TaskAddViewController alloc] init];
	controller.delegate = self;
	Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedObjectContext];
	controller.task = newTask;
	controller.sortOrder = [NSNumber numberWithInteger:[TarefasAppDelegate nextSortValue]];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navigationController animated:YES];
    [navigationController release];
    [controller release];
}

#pragma mark -
#pragma mark TaskDelegate methods

- (void)activeViewController:(UIViewController *)viewController didSaveTask:(Task *)aTask {
	if (aTask != nil) {
		NSError *error = nil;
		if (![aTask.managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
		[TarefasAppDelegate incrementNextSortValue];
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[self.navigationItem setHidesBackButton:editing animated:animated];
	self.navigationItem.rightBarButtonItem.enabled = !editing;
	if (editing) {
		self.configButton.enabled = NO;
		self.mailButton.enabled = NO;
		self.sortButton.enabled = NO;
		[self.trashButton setImage:[UIImage imageNamed:@"TrashOpen.png"]];
	} else {
		self.configButton.enabled = YES;
		self.mailButton.enabled = hasTasks;
		self.sortButton.enabled = hasTasks;
		[self.trashButton setImage:[UIImage imageNamed:@"TrashBar.png"]];
	}
	[super setEditing:editing animated:animated];
	[self.tasksTableView setEditing:editing animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) {
		count = 1;
	} 
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self secNameKeyPathForCase:sortOrder] == nil) {
		if (predicateNumber.intValue == 3)
			return nil;//NSLocalizedString(@"Completed_Loc", nil);
		else 
			return nil;
	}
	int nameIdx = 10;
	if ([[fetchedResultsController sections] count] > 0) {
		nameIdx = [[[[fetchedResultsController sections] objectAtIndex:section] name] intValue];
	}
	return [StringsHelper sectionTitleString:nameIdx];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TasksViewCell";
    UITableViewCellTask *cell = (UITableViewCellTask *)[self.tasksTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCellTask alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[self configureCell:cell atIndexPath:indexPath];
	cell.contentView.alpha = 1.0;
	
    return cell;
}

- (void)configureCell:(UITableViewCellTask *)cell atIndexPath:(NSIndexPath *)indexPath {
	Task *task = (Task *)[fetchedResultsController objectAtIndexPath:indexPath];
	[cell setCheckButtonTag:indexPath andTarget:self];
	[cell setTitleLabelText:task.title];
	
	NSUInteger priority = [task.priority intValue];
	if (priority < 3) {
		NSString *imgName = [NSString stringWithFormat:@"%d.png", priority];
		[cell setPriorityImage:[UIImage imageNamed:imgName]];
	} else {
		[cell setPriorityImage:nil];
	}

	NSUInteger recurrence = [task.recurrence intValue];
	if (recurrence > 0) {
		[cell setRecurrenceImage:[UIImage imageNamed:@"repeat.png"]];
	} else {
		[cell setRecurrenceImage:nil];
	}

	if (task.notes.length > 0) {
		[cell setNotesImage:[UIImage imageNamed:@"note.png"]];
	} else {
		[cell setNotesImage:nil];
	}
	
	if ([task.isDone intValue] == 1) {
		if (task.completionDate == nil)
			[cell setDateLabelText:NSLocalizedString(@"Completed2_Loc", nil)];
		else {
			NSString *tmpStr = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"DoneOn_Loc", nil), [DateHelper stringFromDate:task.completionDate withNames:NO]];
			[cell setDateLabelText:tmpStr];
		}
		[cell didSetCell:YES];
		cell.imageView.image = [UIImage imageNamed:@"checkboxDone.png"];
	} else {
		[cell setDateLabelText:[DateHelper stringFromDate:task.dueDate withNames:YES]];
		if ([task.hasDueDate intValue] == 1 && [DateHelper compareAgainstNow:task.dueDate] == -1) {
			[cell didSetCell:NO];
			cell.imageView.image = [UIImage imageNamed:@"checkboxDue.png"];
		} else {
			[cell didSetCell:NO];
			cell.imageView.image = [UIImage imageNamed:@"checkbox.png"];
		}
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	TaskDetailViewController *controller = [[TaskDetailViewController alloc] init];
	controller.delegate = self;
	Task *selectedTask = [fetchedResultsController objectAtIndexPath:indexPath];
	controller.task = selectedTask;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		UITableViewCellTask *cell = (UITableViewCellTask *)[tableView cellForRowAtIndexPath:indexPath];
		[cell startDeleteAnimation];
		
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		NSError *error;
		if (![context save:&error]) {
				// Handle the error...
		} else {
			[NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(fetch) userInfo:nil repeats:NO];
		}
	}   
}

#pragma mark -
#pragma mark Core Data 

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        [fetchedResultsController release];
		fetchedResultsController = nil;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	NSString *keyPath = [self secNameKeyPathForCase:sortOrder];
	[fetchRequest setSortDescriptors:[self sortDescriptorsForCase:sortOrder]];
	[fetchRequest setPredicate:[self predicateForCase:predicateNumber]];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:managedObjectContext 
																								  sectionNameKeyPath:keyPath 
																										   cacheName:nil];
	self.fetchedResultsController = aFetchedResultsController;
	[aFetchedResultsController release];
	[fetchRequest release];
	return fetchedResultsController;
} 

- (NSPredicate *)predicateForCase:(NSNumber *)aCase {
	int idx = [aCase intValue];
	NSPredicate *predicate = nil;
	
	switch (idx) {
		case 0:
			predicate = [NSPredicate predicateWithFormat:@"isDone == 0"];
			break;
		case 1:
			predicate = [NSPredicate predicateWithFormat:@"dueDate == %@ AND isDone == 0", [DateHelper dateWithoutTimeFor:[NSDate date]]];
			break;
		case 2:
			predicate = [NSPredicate predicateWithFormat:@"dueDate < %@ AND isDone == 0", [DateHelper dateWithoutTimeFor:[NSDate date]]];
			break;
		case 3:
			predicate = [NSPredicate predicateWithFormat:@"isDone == 1"];
			break;
		case 4:
			predicate = [NSPredicate predicateWithFormat:@"category.categoryName == %@ AND isDone == 0", predicateCategory];
			break;
		default:
			break;
	}
	return predicate;
}

- (NSArray *)sortDescriptorsForCase:(NSNumber *)aCase {
	int idx = [aCase intValue];
	NSArray *descriptorsArray = nil;
	
	switch (idx) {
		case 0:
			if (predicateNumber.intValue == 3) {
				descriptorsArray = [NSArray arrayWithObjects:
									[[[NSSortDescriptor alloc] initWithKey:@"completionDate" ascending:NO] autorelease],
									[[[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES] autorelease], nil];
			} else {
				descriptorsArray = [NSArray arrayWithObjects:
									[[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES] autorelease],
									[[[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES] autorelease], nil];
			}
			break;
		case 1:
			descriptorsArray = [NSArray arrayWithObjects:
								[[[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES] autorelease],
								[[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES] autorelease], nil];
			break;
		case 2:
			descriptorsArray = [NSArray arrayWithObjects:
								[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(localizedCompare:)] autorelease], nil];
			break;
		case 3:
			descriptorsArray = [NSArray arrayWithObjects:
								[[[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES] autorelease], nil];
			break;
		default:
			break;
	}
	return descriptorsArray;
}

- (NSString *)secNameKeyPathForCase:(NSNumber *)aCase {
	int idx = [aCase intValue];
	NSString *nameKeyPath = nil;
	if ([predicateNumber intValue] != 3) {
		switch (idx) {
			case 0:
				nameKeyPath = [NSString stringWithString:@"dateKeyPath"];
				break;
			case 1:
				nameKeyPath = [NSString stringWithString:@"priority"];
				break;
			default:
				break;
		}
	}
	return nameKeyPath;
}

#pragma mark -
#pragma mark Mail Delegate Methods

- (NSString *)tasksInMailFormat {
	NSString *due = nil;
	NSString *done = nil;
	NSString *priority = nil;
	NSString *category = nil;
	NSString *notes = nil;
	NSMutableString *resultBody = [NSMutableString string];
	
	NSArray *tasks = [fetchedResultsController fetchedObjects];
	Task *aTask = nil;
	for (aTask in tasks) {
		if (aTask.hasDueDate.intValue == 0) {
			due = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DueDate_Loc", nil), NSLocalizedString(@"NoDueDate_Loc", nil)];
		} else {
			due = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DueDate_Loc", nil), [DateHelper stringFromDate:aTask.dueDate withNames:NO]];
		}
		
		if (aTask.isDone.intValue == 0) {
			done = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Completed2_Loc", nil), NSLocalizedString(@"No_Loc", nil)];
		} else {
			done = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Completed2_Loc", nil), [DateHelper stringFromDate:aTask.completionDate withNames:NO]];
		}
		
		if (aTask.category == nil) {
			category = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"List_Loc", nil), NSLocalizedString(@"None_Loc", nil)];
		} else {
			category = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"List_Loc", nil), NSLocalizedString(aTask.category.categoryName, nil)];
		}
		
		if (aTask.notes == nil) {
			notes = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Notes_Loc", nil), NSLocalizedString(@"None_Loc", nil)];
		} else {
			notes = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Notes_Loc", nil), aTask.notes];
		}
		
		priority = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Priority_Loc", nil), [StringsHelper sectionTitleString:aTask.priority.intValue]];
		
		NSString *path = [[NSBundle mainBundle] pathForResource: @"body" ofType: @"txt"];
		NSString *message = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
		NSMutableString *body = [NSMutableString stringWithFormat:message, aTask.title, due, done, priority, category, notes];
		
		[resultBody appendString:body];
	}
	return resultBody;
}

- (void)sendTaskByMailTo:(BOOL)me {
    NSString *recipient = nil;
	if (me) {
		recipient = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
		
		if (recipient == nil || recipient.length < 3) {
			[self showAlert];
			return;
		}
	}
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:NSLocalizedString(@"subject2", nil)];
	if (recipient != nil) {
		NSArray *toRecipients = [NSArray arrayWithObject:recipient]; 
		[picker setToRecipients:toRecipients];
	}	
	NSString *body = [self tasksInMailFormat];
	[picker setMessageBody:body isHTML:YES];
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error 
{    
	[self dismissModalViewControllerAnimated:YES];
}

@end

