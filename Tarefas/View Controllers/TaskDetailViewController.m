//
//  TaskDetailViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 24/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "ConfigViewController.h"
#import "BaseView.h"
#import "DateHelper.h"
#import "StringsHelper.h"
#import "Constants.h"
#import "Category.h"
#import "Task.h"


@interface TaskDetailViewController ()
- (void)pushDateViewController;
- (void)pushRecurrenceViewController;
- (void)pushCategoryViewController;
- (void)pushNotesViewController;
- (void)mailButtonWillHide:(BOOL)animated;
- (void)mailButtonWillAppear:(BOOL)animated;
- (void)presentMailSheet;
- (void)sendTaskByMailTo:(BOOL)me;
- (void)showAlert;
@end

@implementation TaskDetailViewController

@synthesize task, sortOrder, delegate;

- (id)init {
    if (self = [super init]) {
		self.navigationItem.title = NSLocalizedString(@"Task_Loc", nil);
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}
    return self;
}

- (void)dealloc {
	task = nil;
	[task release];
	[sortOrder release];
    [super dealloc];
}

- (void)loadView {
	BaseView *contentView = [[BaseView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0) style:UITableViewStyleGrouped];
	
	[taskTableView setDelegate:self];
	[taskTableView setDataSource:self];
	[taskTableView setScrollEnabled:NO];
	[taskTableView setBackgroundColor:[UIColor clearColor]];
	
	[contentView addSubview:taskTableView];
	[taskTableView release];
	
	mailButtonView = [[UIView alloc] initWithFrame:kMailViewFrame1];
	mailButtonView.backgroundColor = [UIColor clearColor];
	
	UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
	mailButton.frame = CGRectMake(136.0, 0.0, 48, 48);
	[mailButton setImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateNormal];
	[mailButton addTarget:self action:@selector(presentMailSheet) forControlEvents:UIControlEventTouchDown];
	[mailButtonView addSubview:mailButton];
	
	UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 320.0, 20.0)];
	[mailLabel setBackgroundColor:[UIColor clearColor]];
	[mailLabel setText:NSLocalizedString(@"Mail_Loc", nil)];
	[mailLabel setTextAlignment:UITextAlignmentCenter];
	[mailLabel setTextColor:[UIColor whiteColor]];
	[mailLabel setFont:[UIFont systemFontOfSize:14]];
	[mailLabel setShadowColor:[UIColor darkGrayColor]];
	[mailLabel setShadowOffset:CGSizeMake(1, 1)];
	[mailButtonView addSubview:mailLabel];
	[mailLabel release];
	
	[contentView addSubview:mailButtonView];
	[mailButtonView release];
	
	self.view = contentView;
	[contentView release];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [taskTableView reloadData];
	[super viewWillAppear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (editing) {
		priorityControl.enabled = YES;
		[self mailButtonWillHide:YES];
	}else {
		[self saveTaskTitle];
		[self mailButtonWillAppear:YES];
		priorityControl.enabled = NO;
	}
	[super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	[taskTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveTaskTitle {
	if (!titleTextField.enabled) {
		return;
	}
	[titleTextField setEnabled:NO];
	[titleTextField resignFirstResponder];
	if (titleTextField.text.length > 0) {
		task.title = titleTextField.text;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self saveTaskTitle];
	return YES;
}

- (void)priorityDidChange {
	[self saveTaskTitle];
	task.priority = [NSNumber numberWithInt:priorityControl.selectedSegmentIndex];
}

- (void)presentMailSheet {
	UIActionSheet *menu = [[UIActionSheet alloc] 
						   initWithTitle:NSLocalizedString(@"SendTo_Loc", nil)
						   delegate:self
						   cancelButtonTitle:NSLocalizedString(@"Cancel_Loc", nil)
						   destructiveButtonTitle:NSLocalizedString(@"Me_Loc", nil)
						   otherButtonTitles:NSLocalizedString(@"Other_Loc", nil), nil];
	menu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[menu showInView:self.view];
	[menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

- (void)presentModalConfigView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0]; 
	ConfigViewController *controller = [[ConfigViewController alloc] init];
	[self.navigationController pushViewController:controller animated:NO];
	[controller release];
	[UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self presentModalConfigView];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) return 3;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TaskDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section == 0) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		} else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		if (indexPath.section == 0) {
			titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 11.0, 280.0, 22.0)];
			[titleTextField setEnabled:NO];
			[titleTextField setDelegate:self];
			[titleTextField setPlaceholder:NSLocalizedString(@"Task_Loc", @"")];
			[titleTextField setReturnKeyType:UIReturnKeyDone];
			[titleTextField setAutocorrectionType:UITextAutocorrectionTypeDefault];
			[titleTextField setTag:TASKNAME_TAG];
			[titleTextField setFont:[UIFont boldSystemFontOfSize:18]];
			[titleTextField setAdjustsFontSizeToFitWidth:YES];
			[titleTextField setMinimumFontSize:14];
			[titleTextField setTextColor:[UIColor blackColor]];
			[titleTextField setBackgroundColor:[UIColor whiteColor]];
			[titleTextField setOpaque:YES];
			[cell.contentView addSubview:titleTextField];
			[titleTextField release];
		}
		
		if (indexPath.section == 1 && indexPath.row == 2) {
			priorityControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																		 [UIImage imageNamed:@"0.png"], 
																		 [UIImage imageNamed:@"1.png"],
																		 [UIImage imageNamed:@"2.png"],
																		 [UIImage imageNamed:@"3.png"], nil]];
			priorityControl.enabled = NO;
			priorityControl.momentary = NO;
			priorityControl.frame = CGRectMake(110.0, 6.0, 180.0, 32.0);
			priorityControl.segmentedControlStyle = UISegmentedControlStyleBar;
			priorityControl.tintColor = [UIColor colorWithRed:0.496 green:0.577 blue:0.637 alpha:1.000];
			priorityControl.tag = SEGCONTROL_TAG;
			[priorityControl addTarget:self action:@selector(priorityDidChange) forControlEvents:UIControlEventValueChanged];
			[cell.contentView addSubview:priorityControl];
			[priorityControl release];
		}
		
	} else {
		if (indexPath.section == 0) 
			titleTextField = (UITextField *)[cell.contentView viewWithTag:TASKNAME_TAG];
		if (indexPath.section == 1 && indexPath.row == 2) 
			priorityControl = (UISegmentedControl *) [cell.contentView viewWithTag:SEGCONTROL_TAG];
	}

	if (indexPath.section == 0) {
		titleTextField.text = task.title;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	} 
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"DueDate_Loc", @"");
			cell.detailTextLabel.text = [DateHelper stringFromDate:task.dueDate withNames:NO];
			if (self.editing)
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			else 
				cell.accessoryType = UITableViewCellAccessoryNone;
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Repeat_Loc", nil);
			if (task.recurrence == 0) {
				cell.detailTextLabel.text = NSLocalizedString(@"No_Loc", nil);
			} else {
				cell.detailTextLabel.text = [StringsHelper recurrenceString:task.recurrence];
			}
			if (self.editing) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
		} else if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Priority_Loc", @"");
			priorityControl.selectedSegmentIndex = [task.priority intValue];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	} else if (indexPath.section == 2) {
		cell.textLabel.text = NSLocalizedString(@"List_Loc", nil);
		cell.detailTextLabel.text = NSLocalizedString(task.category.categoryName, nil);
		if (self.editing) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	} else if (indexPath.section == 3) {
		cell.textLabel.text = NSLocalizedString(@"Notes_Loc", @"");
		if (task.notes.length > 0) {
			cell.detailTextLabel.text = NSLocalizedString(@"Yes_Loc", @"");
		} else {
			cell.detailTextLabel.text = NSLocalizedString(@"No_Loc", nil);
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 2) 
		return nil;
	if (!self.editing && indexPath.section != 3)
		return nil;
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self saveTaskTitle];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) {
		titleTextField.enabled = YES;
		[titleTextField becomeFirstResponder];
	} 
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			[self pushDateViewController];
		} else if (indexPath.row == 1) {
			[self pushRecurrenceViewController];
		}
	} else if (indexPath.section == 2) {
		[self pushCategoryViewController];
	} else if (indexPath.section == 3) {
		[self pushNotesViewController];
	}
}

- (void)pushDateViewController {
	DateViewController *controller = [[DateViewController alloc] init];
	controller.delegate = self;
	controller.dueDate = task.dueDate;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)pushRecurrenceViewController {
	RecurrenceViewController *controller = [[RecurrenceViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)pushCategoryViewController {
	CategoryViewController *controller = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)pushNotesViewController {
	NotesViewController *controller = [[NotesViewController alloc] init];
	controller.delegate = self;
	controller.currentNote = task.notes;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

#pragma mark -
#pragma mark DateViewController delegate

- (void)dateViewControllerEndWithDate:(NSDate *)aDate {
	if (aDate != nil) {
		task.dueDate = aDate;
		task.hasDueDate = [NSNumber numberWithInteger:1];
	} else {
		task.dueDate = [DateHelper noDueDate];
		task.hasDueDate = [NSNumber numberWithInteger:0];
	}
}

#pragma mark -
#pragma mark RecurrenceViewController delegate

- (void)updateTaskWithRecurrence:(NSInteger)value {
	task.recurrence = [NSNumber numberWithInt:value];
}

- (void)updateTaskWithRecurrenceFrom:(NSInteger)value {
	task.recurrenceFrom = [NSNumber numberWithInt:value];
}

- (NSInteger)recurrence {
	return [self.task.recurrence intValue]; 
}

- (NSInteger)recurrenceFrom {
	return [self.task.recurrenceFrom intValue];
}

#pragma mark -
#pragma mark CategoryViewController delegate

- (void)updateTaskWithCategory:(Category *)newCategory {
	if (newCategory != nil) {
		self.task.category = newCategory;
	}
}

- (NSInteger)categoryOrder {
	NSNumber *order = self.task.category.sortOrder;
	
	if (order) {
		return [order intValue];
	}
	return -1;
}

#pragma mark -
#pragma mark NotesViewController delegate

- (void)updateTaskWithNote:(NSString *)aNote {
	if (aNote.length > 0) {
		task.notes = aNote;
	} else {
		task.notes = nil;
	}
}

#pragma mark -
#pragma mark Animations

- (void)mailButtonWillHide:(BOOL)animated {
	if (mailButtonView.frame.origin.y == 416) return;
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	mailButtonView.frame = kMailViewFrame2;
	[UIView commitAnimations];
}

- (void)mailButtonWillAppear:(BOOL)animated {
	if (mailButtonView.frame.origin.y == 346) return;
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	mailButtonView.frame = kMailViewFrame1;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Mail Delegate Methods

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
    
    [picker setSubject:NSLocalizedString(@"subject1", nil)];
	
	if (recipient != nil) {
		NSArray *toRecipients = [NSArray arrayWithObject:recipient]; 
		[picker setToRecipients:toRecipients];
	}	
	
	NSString *due = nil;
	NSString *done = nil;
	NSString *priority = nil;
	NSString *category = nil;
	NSString *notes = nil;
	
	if (task.hasDueDate.intValue == 0) {
		due = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DueDate_Loc", nil), NSLocalizedString(@"NoDueDate_Loc", nil)];
	} else {
		due = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DueDate_Loc", nil), [DateHelper stringFromDate:task.dueDate withNames:NO]];
	}
	
	if (task.isDone.intValue == 0) {
		done = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Completed2_Loc", nil), NSLocalizedString(@"No_Loc", nil)];
	} else {
		done = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Completed2_Loc", nil), [DateHelper stringFromDate:task.completionDate withNames:NO]];
	}
	
	if (task.category == nil) {
		category = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"List_Loc", nil), NSLocalizedString(@"None_Loc", nil)];
	} else {
		category = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"List_Loc", nil), NSLocalizedString(task.category.categoryName, nil)];
	}
	
	if (task.notes == nil) {
		notes = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Notes_Loc", nil), NSLocalizedString(@"None_Loc", nil)];
	} else {
		notes = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Notes_Loc", nil), task.notes];
	}
	
	priority = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Priority_Loc", nil), [StringsHelper sectionTitleString:task.priority.intValue]];
	
	NSString *path = [[NSBundle mainBundle] pathForResource: @"body" ofType: @"txt"];
	NSString *message = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	NSMutableString *body = [NSMutableString stringWithFormat:message, task.title, due, done, priority, category, notes];
	
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

