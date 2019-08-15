//
//  AddHealthViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "AddHealthViewController.h"
#import "Constants.h"
#import "DateHelper.h"
#import "Type.h"
#import "TypesViewController.h"
#import "RepeatEntry.h"

@interface AddHealthViewController ()
- (void)save;
- (void)cancel;
- (void)saveData;
- (void)showAlert;
- (void)changeDate;
- (void)checkFields;
- (void)addType;
- (void)cellSwitchDidChange:(id)sender;
- (void)pushRecurrenceViewController;
- (NSString *)getFrequencyStringFor:(NSInteger)value;
- (void)tableViewAnimation:(BOOL)hide;
@end

@implementation AddHealthViewController

@synthesize selectedEntry, petPk, newType;

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
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) 
																	   style:UIBarButtonItemStyleBordered 
																	  target:nil 
																	  action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release];
	}
    return self;
}

- (void)loadView {
	
	contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 400.0) style:UITableViewStyleGrouped];
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
	
	datePickerBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 156, 320, 44)];
	[datePickerBar setBarStyle:UIBarStyleBlackTranslucent];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DoneBt", nil) 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(dismissDatePicker)];
	doneButton.width = 60;
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																			  target:nil
																			  action:nil];
	UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
																			   target:nil 
																			   action:nil];
	fixedItem.width = 10;
	
	NSArray *items = [NSArray arrayWithObjects:flexItem, doneButton, fixedItem, nil];
	
	[datePickerBar setItems:items];
	[doneButton release];
	[flexItem release];
	[fixedItem release];
	[contentView addSubview:datePickerBar];
	[datePickerBar release];
	
	datePickerBar.hidden = YES;
	
	self.view = contentView;
	[contentView release];
	
	if (tempEntry == nil) tempEntry = [[Health alloc] init];
	if (selectedEntry.type != nil) {
		tempEntry.type = selectedEntry.type;
		tempEntry.infotag = selectedEntry.infotag;
		tempEntry.date = selectedEntry.date;
		tempEntry.donedate = selectedEntry.donedate;
		tempEntry.isdone = selectedEntry.isdone;
		tempEntry.kindrepeat = selectedEntry.kindrepeat;
		tempEntry.repeatoff = selectedEntry.repeatoff;
	}
}

- (void)dismissDatePicker {
	[self saveData];
	[self tableViewAnimation:NO];
}

- (void)dealloc {
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	
	[newType release];
	[tempEntry release];
	[selectedEntry release];
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
	} else if (edited == NEXT_TAG) {
		[doneLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
		dateValue = datePicker.date;
	}
}

- (void)save {
	[self saveData];
	
	if (tempEntry.infotag == nil) {
		tempEntry.infotag == @" ";
	}
	if (tempEntry.type == nil) {
		[self showAlert];
		return;
	}
	[self checkFields];
	selectedEntry.petpk = petPk;
	if (selectedEntry.isdone == 1 && selectedEntry.kindrepeat > 0 && selectedEntry.repeatoff == 0) {
		RepeatEntry *clone = [[RepeatEntry alloc] init];
		[clone createRecurrentHealthFor:selectedEntry];
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
			[tempEntry setValue:tagLabel.text forKey:editedFieldKey];
			tagLabel.enabled = NO;
			break;
		case DATE_TAG:
			[tempEntry setValue:dateValue forKey:editedFieldKey];
			[self tableViewAnimation:NO];
			break;
		case NEXT_TAG:
			[tempEntry setValue:dateValue forKey:editedFieldKey];
			[self tableViewAnimation:NO];
			break;
		case DESC_TAG:
			[tempEntry setValue:typeLabel.text forKey:editedFieldKey];
			break;
	}
	editedFieldKey = nil;
}

- (void)checkFields {
	if (tempEntry.infotag != selectedEntry.infotag) {
		selectedEntry.infotag = tempEntry.infotag;
	} else if (selectedEntry.pk < 1 && selectedEntry.infotag == nil) {
		selectedEntry.infotag = @"";
	}
	if (tempEntry.type != selectedEntry.type && tempEntry.type.length > 0) {
		selectedEntry.type = tempEntry.type;
	} else if (selectedEntry.pk < 1 && selectedEntry.type == nil) {
		selectedEntry.type = NSLocalizedString(@"Other", nil);
	}
	if (tempEntry.date && tempEntry.date != selectedEntry.date) {
		selectedEntry.date = tempEntry.date;
	} else if (selectedEntry.pk < 1) {
		selectedEntry.date = [NSDate date];
	}
	selectedEntry.donedate = tempEntry.donedate;
	selectedEntry.isdone = tempEntry.isdone;
	selectedEntry.kindrepeat = tempEntry.kindrepeat;
}

- (void)cancel {
	tempEntry.infotag = nil;
	tempEntry.type = nil;
	tempEntry.date = nil;
	tempEntry.donedate = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops..." 
													  message:NSLocalizedString(@"NoType", nil)
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"OK", nil];
	[myAlert show];
	[myAlert release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField setEnabled:NO];
	[textField resignFirstResponder];
	[self tableViewAnimation:NO];
	return NO; 
}

- (void)cellSwitchDidChange:(id)sender {
	[self saveData];
	if (tempEntry.isdone == 0) {
		tempEntry.isdone = 1;
		tempEntry.donedate = [NSDate date];
		doneLabel.text = [DateHelper stringFromDate:tempEntry.donedate withNames:NO];
		[checkBox setImage:[UIImage imageNamed:@"checkedbox.png"]];
	} else if (tempEntry.isdone == 1) {
		tempEntry.isdone = 0;
		tempEntry.donedate = NULL;
		doneLabel.text = NSLocalizedString(@"NO", nil);
		[checkBox setImage:[UIImage imageNamed:@"checkbox.png"]];
	}
}

- (void)tableViewAnimation:(BOOL)hide {
	if (!hide){
		datePicker.hidden = YES;
		datePickerBar.hidden = YES;
		if (myTableView.frame.origin.y == 0) return;
		[UIView beginAnimations:@"advancedAnimations" context:nil];
		[UIView setAnimationDuration:0.2];
		CGRect myTableViewFrame = myTableView.frame;
		myTableViewFrame.origin.y += 90;
		myTableView.frame = myTableViewFrame;
		[UIView commitAnimations];
	} else if (hide) {
		datePicker.hidden = NO;
		datePickerBar.hidden = NO;
		if (myTableView.frame.origin.y == -90) return;
		[UIView beginAnimations:@"advancedAnimations" context:nil];
		[UIView setAnimationDuration:0.2];
		CGRect myTableViewFrame = myTableView.frame;
		myTableViewFrame.origin.y -= 90;
		myTableView.frame = myTableViewFrame;
		[UIView commitAnimations];
	}
}

#pragma mark TableVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AddHealthCell";
    
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
			typeLabel = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 180.0, 25.0)];
			[typeLabel setEnabled:NO];
			[typeLabel setTag:DESC_TAG];
			[typeLabel setFont:[UIFont boldSystemFontOfSize:18]];
			[typeLabel setTextColor:[UIColor blackColor]];
			[typeLabel setBackgroundColor:[UIColor whiteColor]];
			[typeLabel setOpaque:YES];
			[cell.contentView addSubview:typeLabel];
			[typeLabel release];
		}
		if (indexPath.row == 1) {
			tagLabel = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 190.0, 25.0)];
			[tagLabel setEnabled:NO];
			[tagLabel setDelegate:self];
			[tagLabel setClearButtonMode:UITextFieldViewModeWhileEditing];
			[tagLabel setReturnKeyType:UIReturnKeyDone];
			[tagLabel setAutocorrectionType:UITextAutocorrectionTypeDefault];
			[tagLabel setTag:EVENT_TAG];
			[tagLabel setFont:[UIFont boldSystemFontOfSize:18]];
			[tagLabel setTextColor:[UIColor blackColor]];
			[tagLabel setBackgroundColor:[UIColor whiteColor]];
			[tagLabel setOpaque:YES];
			[cell.contentView addSubview:tagLabel];
			[tagLabel release];
		}
		if (indexPath.row == 2) {
			dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 180.0, 25.0)];
			[dateLabel setTag:DATE_TAG];
			[dateLabel setFont:[UIFont boldSystemFontOfSize:16]];
			[dateLabel setTextColor:[UIColor blackColor]];
			[dateLabel setBackgroundColor:[UIColor whiteColor]];
			[dateLabel setOpaque:YES];
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
		}
		if (indexPath.row == 3) {
			doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 120.0, 25.0)];
			[doneLabel setTag:NEXT_TAG];
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
		if (indexPath.row == 4) {
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
		if (indexPath.row == 0) typeLabel = (UITextField *) [cell.contentView viewWithTag:DESC_TAG];
		if (indexPath.row == 1) tagLabel = (UITextField *) [cell.contentView viewWithTag:EVENT_TAG];
		if (indexPath.row == 2) dateLabel = (UITextField *) [cell.contentView viewWithTag:DATE_TAG];
		if (indexPath.row == 3) {
			doneLabel = (UITextField *) [cell.contentView viewWithTag:NEXT_TAG];
			checkBox = (UIImageView *) [cell.contentView viewWithTag:CELL_SWITCH_TAG];
		}
		if (indexPath.row == 4) repeatsLabel = (UILabel *) [cell.contentView viewWithTag:REPEATS_LABEL_TAG];
	}
	if (indexPath.row == 0) {
		typeLabel.text = NSLocalizedString(tempEntry.type, nil);
		if (newType != nil) {
			typeLabel.text = newType;
		}
		cellLabel.text = NSLocalizedString(@"Type", nil);
	} else if (indexPath.row == 1) { 
		tagLabel.text = tempEntry.infotag;
		cellLabel.text = NSLocalizedString(@"Description", nil);
	} else if (indexPath.row == 2) { 
		dateLabel.text = [DateHelper stringFromDate:tempEntry.date withNames:NO];
		cellLabel.text = NSLocalizedString(@"Date", nil);
	} else if (indexPath.row == 3) { 
		cellLabel.text = NSLocalizedString(@"Complete", nil);
		if (tempEntry.isdone == 1) {
			[checkBox setImage:[UIImage imageNamed:@"checkedbox.png"]];
			doneLabel.text = [DateHelper stringFromDate:tempEntry.donedate withNames:NO];
		} else {
			[checkBox setImage:[UIImage imageNamed:@"checkbox.png"]];
			doneLabel.text = NSLocalizedString(@"NO", nil);
		}
	} else if (indexPath.row == 4) {
		cellLabel.text = NSLocalizedString(@"Repeats", nil);
		repeatsLabel.text = [self getFrequencyStringFor:tempEntry.kindrepeat];
	}
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 3 && tempEntry.isdone == 0) return nil;
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	[self saveData];
	switch (indexPath.row) {
		case 0:
			edited = DESC_TAG;
			editedFieldKey = @"type";
			[self addType];
			[self tableViewAnimation:NO];
			break;
		case 1:
			edited = EVENT_TAG;
			editedFieldKey = @"infotag";
			[tagLabel setEnabled:YES];
			[tagLabel becomeFirstResponder];
			break;
		case 2:
			edited = DATE_TAG;
			editedFieldKey = @"date";
			if (tempEntry.date != nil) [datePicker setDate:tempEntry.date];
			if (tempEntry.date == nil) {
				[datePicker setDate:[NSDate date] animated:YES];
				[dateLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
			}
			dateValue = datePicker.date;
			[self tableViewAnimation:YES];
			break;
		case 3:
			edited = NEXT_TAG;
			editedFieldKey = @"donedate";
			if (tempEntry.donedate != nil) [datePicker setDate:tempEntry.donedate];
			if (tempEntry.donedate == nil) {
				[datePicker setDate:[NSDate date] animated:YES];
				[doneLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
			}
			dateValue = datePicker.date;
			[self tableViewAnimation:YES];
			break;
		case 4:
			[self pushRecurrenceViewController];
			[self tableViewAnimation:NO];
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
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	[self.navigationController presentModalViewController:nav animated:YES];
	[controller release];
	[nav release];
}

- (void)updateEntryWith:(NSInteger)repeat {
	tempEntry.kindrepeat = repeat;
}

- (NSInteger)repeatType {
	return selectedEntry.kindrepeat;
}

- (void)dismissRecurrenceViewController:(RecurrenceViewController *)controller {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	controller.delegate = nil;
}

- (void)addType {
	TypesViewController *controller = [[TypesViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	[self.navigationController presentModalViewController:nav animated:YES];
	[controller release];
	[nav release];
}

@end