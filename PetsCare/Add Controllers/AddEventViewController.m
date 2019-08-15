//
//  AddEventViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "AddEventViewController.h"
#import "Constants.h"
#import "RepeatEntry.h"
#import "DateHelper.h"

@interface AddEventViewController ()
- (void)save;
- (void)cancel;
- (void)saveData;
- (void)showAlert;
- (void)changeDate;
- (void)checkFields;
- (void)cellSwitchDidChange:(id)sender;
- (void)pushRecurrenceViewController;
- (NSString *)getFrequencyStringFor:(NSInteger)value;
@end

@implementation AddEventViewController

@synthesize selectedEntry, petPk, petName;

- (id)init {
    if (self = [super init]) {
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																					  target:self 
																					  action:@selector(cancel)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																					target:self 
																					action:@selector(save)];    
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
	}
    return self;
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.view = contentView;
	[contentView release];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0) style:UITableViewStyleGrouped];
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[myTableView setScrollEnabled:NO];
	[contentView addSubview:myTableView];
	[myTableView release];
	
	datePicker = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, 300.0, 200.0)] autorelease];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	[datePicker setTag:DATE_PICKER_TAG];
	[datePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
	[contentView addSubview:datePicker];
	
	if (tempEvent == nil) tempEvent = [[Event alloc] init];
	if (selectedEntry.event != nil) {
		tempEvent.event = selectedEntry.event;
		tempEvent.date = selectedEntry.date;
		tempEvent.donedate = selectedEntry.donedate;
		tempEvent.isdone = selectedEntry.isdone;
		tempEvent.kindrepeat = selectedEntry.kindrepeat;
		tempEvent.repeatoff = selectedEntry.repeatoff;
	}
}

- (void)dealloc {
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	[selectedEntry release];
	[tempEvent release];
	[petName release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	datePicker.hidden = YES;
	[myTableView reloadData];
}

- (void)changeDate {
	if (edited == DATE_TAG) {
		[dateLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
		dateValue = datePicker.date;
	} else if (edited == DONE_TAG) {
		[doneLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
		doneValue = datePicker.date;
	}
}

- (void)save {
	[self saveData];
	
	if (tempEvent.event == nil) {
		[self showAlert];
		return;
	}
	[self checkFields];
	selectedEntry.petpk = petPk;
	if (selectedEntry.isdone == 1 && selectedEntry.kindrepeat > 0 && selectedEntry.repeatoff == 0) {
		RepeatEntry *clone = [[RepeatEntry alloc] init];
		[clone createRecurrentEventFor:selectedEntry];
		[clone release];
		selectedEntry.repeatoff = 1;
		selectedEntry.kindrepeat = 0;
	}
	[selectedEntry save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveData {
	if (editedFieldKey == nil) return;
	switch (edited) {
		case EVENT_TAG:
			[tempEvent setValue:eventLabel.text forKey:editedFieldKey];
			eventLabel.enabled = NO;
			break;
		case DATE_TAG:
			[tempEvent setValue:dateValue forKey:editedFieldKey];
			datePicker.hidden = YES;
			break;
		case DONE_TAG:
			[tempEvent setValue:doneValue forKey:editedFieldKey];
			datePicker.hidden = YES;
			break;
	}
	editedFieldKey = nil;
}

- (void)checkFields {
	
	if (tempEvent.event != selectedEntry.event && tempEvent.event.length > 0) {
		selectedEntry.event = tempEvent.event;
	} else if (selectedEntry.pk < 1 && selectedEntry.event == nil) {
		selectedEntry.event = NSLocalizedString(@"Event", nil);
	}
	if (tempEvent.date && tempEvent.date != selectedEntry.date) {
		selectedEntry.date = tempEvent.date;
	} else if (selectedEntry.pk < 1) {
		selectedEntry.date = [NSDate date];
	}
	selectedEntry.donedate = tempEvent.donedate;
	selectedEntry.isdone = tempEvent.isdone;
	selectedEntry.kindrepeat = tempEvent.kindrepeat;
}

- (void)cancel {
	tempEvent.event = nil;
	tempEvent.date = nil;
	tempEvent.donedate = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops..." 
													  message:NSLocalizedString(@"NoEvent", nil)
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"OK", nil];
	[myAlert show];
	[myAlert release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField setEnabled:NO];
	[textField resignFirstResponder];
	datePicker.hidden = YES;
	[self saveData];
	return NO; 
}

- (void)cellSwitchDidChange:(id)sender {
	[self saveData];
	if (tempEvent.isdone == 0) {
		tempEvent.isdone = 1;
		tempEvent.donedate = [NSDate date];
		doneLabel.text = [DateHelper stringFromDate:tempEvent.donedate withNames:NO];
		[checkBox setImage:[UIImage imageNamed:@"checkedbox.png"]];
	} else if (tempEvent.isdone == 1) {
		tempEvent.isdone = 0;
		tempEvent.donedate = NULL;
		doneLabel.text = NSLocalizedString(@"NO", nil);
		[checkBox setImage:[UIImage imageNamed:@"checkbox.png"]];
	}
}
#pragma mark TableVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AddEventCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cellLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 12.0, 100.0, 25.0)] autorelease];
		[cellLabel setTag:LABEL_TAG];
		[cellLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[cellLabel setTextColor:[UIColor grayColor]];
		[cellLabel setTextAlignment:UITextAlignmentRight];
		[cellLabel setBackgroundColor:[UIColor whiteColor]];
		[cellLabel setOpaque:YES];
		[cell.contentView addSubview:cellLabel];
		
		if (indexPath.row == 0) {
			eventLabel = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 190.0, 25.0)];
			[eventLabel setEnabled:NO];
			[eventLabel setDelegate:self];
			[eventLabel setClearButtonMode:UITextFieldViewModeWhileEditing];
			[eventLabel setReturnKeyType:UIReturnKeyDone];
			[eventLabel setAutocorrectionType:UITextAutocorrectionTypeDefault];
			[eventLabel setTag:EVENT_TAG];
			[eventLabel setFont:[UIFont boldSystemFontOfSize:18]];
			[eventLabel setTextColor:[UIColor blackColor]];
			[eventLabel setBackgroundColor:[UIColor whiteColor]];
			[eventLabel setOpaque:YES];
			[cell.contentView addSubview:eventLabel];
			[eventLabel release];
		}
		if (indexPath.row == 1) {
			dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 180.0, 25.0)];
			[dateLabel setTag:DATE_TAG];
			[dateLabel setFont:[UIFont boldSystemFontOfSize:16]];
			[dateLabel setTextColor:[UIColor blackColor]];
			[dateLabel setBackgroundColor:[UIColor whiteColor]];
			[dateLabel setOpaque:YES];
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
		}
		if (indexPath.row == 2) {
			doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 180.0, 25.0)];
			[doneLabel setTag:DONE_TAG];
			[doneLabel setFont:[UIFont boldSystemFontOfSize:16]];
			[doneLabel setTextColor:[UIColor blackColor]];
			[doneLabel setBackgroundColor:[UIColor whiteColor]];
			[doneLabel setOpaque:YES];
			[cell.contentView addSubview:doneLabel];
			[doneLabel release];
			
			checkBox = [[UIImageView alloc] initWithFrame:CGRectMake(260.0, 6.0, 32.0, 32.0)];
			[checkBox setTag:CELL_SWITCH_TAG];
			[cell.contentView addSubview:checkBox];
		
			checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
			checkButton.frame = CGRectMake(256.0, 2.0, 40.0, 40.0);
			[checkButton addTarget:self action:@selector(cellSwitchDidChange:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:checkButton];
		} 
		if (indexPath.row == 3) {
			repeatsLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 14.0, 180.0, 20.0)];
			[repeatsLabel setTag:REPEATS_LABEL_TAG];
			[repeatsLabel setFont:[UIFont boldSystemFontOfSize:16]];
			[repeatsLabel setTextColor:[UIColor blackColor]];
			[repeatsLabel setBackgroundColor:[UIColor whiteColor]];
			[repeatsLabel setOpaque:YES];
			[cell.contentView addSubview:repeatsLabel];
			[repeatsLabel release];
		}
		
	} else {
		cellLabel = (UILabel *) [cell.contentView viewWithTag:LABEL_TAG];
		if (indexPath.row == 0) eventLabel = (UITextField *) [cell.contentView viewWithTag:EVENT_TAG];
		if (indexPath.row == 1) dateLabel = (UILabel *) [cell.contentView viewWithTag:DATE_TAG];
		if (indexPath.row == 2) {
			doneLabel = (UILabel *)[cell.contentView viewWithTag:DONE_TAG];
			checkBox = (UIImageView *) [cell.contentView viewWithTag:CELL_SWITCH_TAG];
		}
		if (indexPath.row == 3) repeatsLabel = (UILabel *) [cell.contentView viewWithTag:REPEATS_LABEL_TAG];
	}
	
    if (indexPath.row == 0) { 
		eventLabel.text = [tempEvent event];
		cellLabel.text = NSLocalizedString(@"Event", nil);
	} else if (indexPath.row == 1) { 
		dateLabel.text = [DateHelper stringFromDate:tempEvent.date withNames:NO];
		cellLabel.text = NSLocalizedString(@"Date", nil);
	} else if (indexPath.row == 2) {
		cellLabel.text = NSLocalizedString(@"Complete", nil);
		if (tempEvent.isdone == 1) {
			[checkBox setImage:[UIImage imageNamed:@"checkedbox.png"]];
			doneLabel.text = [DateHelper stringFromDate:tempEvent.donedate withNames:NO];
		} else {
			[checkBox setImage:[UIImage imageNamed:@"checkbox.png"]];
			doneLabel.text = NSLocalizedString(@"NO", nil);
		}
	} else if (indexPath.row == 3) {
		cellLabel.text = NSLocalizedString(@"Repeats", nil);
		repeatsLabel.text = [self getFrequencyStringFor:tempEvent.kindrepeat];
	}

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2 && tempEvent.isdone == 0) return nil;
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	[self saveData];
	switch (indexPath.row) {
		case 0:
			edited = EVENT_TAG;
			editedFieldKey = @"event";
			[eventLabel setEnabled:YES];
			[eventLabel becomeFirstResponder];
			break;
		case 1:
			edited = DATE_TAG;
			editedFieldKey = @"date";
			if (tempEvent.date != nil) [datePicker setDate:tempEvent.date];
			if (tempEvent.date == nil) {
				[datePicker setDate:[NSDate date] animated:YES];
				[dateLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
			}
			dateValue = datePicker.date;
			datePicker.hidden = NO;
			break;
		case 2:
			edited = DONE_TAG;
			editedFieldKey = @"donedate";
			if (tempEvent.donedate != nil) [datePicker setDate:tempEvent.donedate];
			if (tempEvent.donedate == nil) {
				[datePicker setDate:[NSDate date] animated:YES];
				[doneLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
			}
			doneValue = datePicker.date;
			datePicker.hidden = NO;
			break;
		case 3:
			[self pushRecurrenceViewController];
			break;
	}
}

- (NSString *)getFrequencyStringFor:(NSInteger)value {
	switch (value) {
		case 0:
			return NSLocalizedString(@"NO", nil);
			break;
		case 1:
			return NSLocalizedString(@"Daily", nil);
			break;
		case 2:
			return NSLocalizedString(@"Weekly", nil);
			break;
		case 3:
			return NSLocalizedString(@"Monthly", nil);
			break;
		case 4:
			return NSLocalizedString(@"Every Three Months", nil);
			break;
		case 5:
			return NSLocalizedString(@"Every Six Months", nil);
			break;
		case 6:
			return NSLocalizedString(@"Yearly", nil);
			break;
	}
	return nil;
}

- (void)pushRecurrenceViewController {
	RecurrenceViewController *controller = [[RecurrenceViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (NSInteger)repeatType {
	return selectedEntry.kindrepeat;
}

- (void)updateEntryWith:(NSInteger)repeat {
	tempEvent.kindrepeat = repeat;
}

- (void)dismissRecurrenceViewController:(RecurrenceViewController *)controller {
	[self.navigationController popViewControllerAnimated:YES];
	controller.delegate = nil;
}
@end
