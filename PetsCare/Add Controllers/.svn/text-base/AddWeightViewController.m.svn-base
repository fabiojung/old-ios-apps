//
//  AddWeightViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 26/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "AddWeightViewController.h"
#import "Constants.h"
#import "DateHelper.h"

@interface AddWeightViewController ()
- (void)save;
- (void)cancel;
- (void)saveData;
- (void)showAlert;
- (void)changeDate;
- (void)checkFields;
@end

@implementation AddWeightViewController

@synthesize selectedWeight, petName, petPk, unit;

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
	
	flag = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(formatText:) name:@"UITextFieldTextDidChangeNotification" object:weightLabel];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:weightLabel];
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	[tempWeight release];
	[petName release];
	[unit release];
	[selectedWeight release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (tempWeight == nil) tempWeight = [[Weight alloc] init];
	if (selectedWeight.weight != nil) tempWeight.weight = selectedWeight.weight;
	datePicker.hidden = YES;
	[myTableView reloadData];
}

- (void)changeDate{
	[dateLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
	dateValue = datePicker.date;
}

- (void)save {
	[self saveData];
	if (tempWeight.weight == nil) {
		[self showAlert];
		return;
	}
	[self checkFields];
	selectedWeight.petpk = petPk;
	[selectedWeight save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveData {
	if (editedFieldKey == nil) return;
	switch (edited) {
		case WEIGHT_TAG:
			doubleValue = [NSNumber numberWithDouble:[weightLabel.text doubleValue]];
			[tempWeight setValue:doubleValue forKey:editedFieldKey];
			datePicker.hidden = NO;
			weightLabel.enabled = NO;
			break;
		case DATE_TAG:
			[tempWeight setValue:dateValue forKey:editedFieldKey];
			datePicker.hidden = YES;
			break;
	}
	editedFieldKey = nil;
}

- (void)checkFields {
	if (tempWeight.weight != selectedWeight.weight && tempWeight.weight > 0) {
		selectedWeight.weight = tempWeight.weight;
	} else if (selectedWeight.pk < 1) {
		selectedWeight.weight = 0;
	}
	if (tempWeight.date && tempWeight.date != selectedWeight.date) {
		selectedWeight.date = tempWeight.date;
	} else if (selectedWeight.pk < 1) {
		selectedWeight.date = [NSDate date];
	}
}

- (void)cancel {
	tempWeight.weight = nil;
	tempWeight.date = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops..." 
													  message:NSLocalizedString(@"NoWeight", nil)
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"OK", nil];
	[myAlert show];
	[myAlert release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self saveData];
	[textField setEnabled:NO];
	[textField resignFirstResponder];
	return NO; 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if(textField == weightLabel) {
		if (string.length != 0) {
			return !(textField.text.length > 5);	
		} 		
	}
	return YES;
}

- (void)formatText:(NSNotification *)note {
	if (flag) {
		if (weightLabel.text.length > 0) {
			flag = NO;
			NSString *str = weightLabel.text;
			str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
			weightLabel.text = [@"" stringByAppendingFormat:@"%.2f", [str doubleValue]/100.0];
		}
	} else {
		flag = YES;
	}
}

#pragma mark TableVIEW

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"%@", petName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"AddWeightCell";
    
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
			weightLabel = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 14.0, 60.0, 25.0)];
			[weightLabel setEnabled:NO];
			[weightLabel setDelegate:self];
			[weightLabel setKeyboardType:UIKeyboardTypeNumberPad];
			[weightLabel setTag:WEIGHT_TAG];
			[weightLabel setFont:[UIFont boldSystemFontOfSize:18]];
			[weightLabel setTextColor:[UIColor blackColor]];
			[weightLabel setBackgroundColor:[UIColor whiteColor]];
			[weightLabel setOpaque:YES];
			[cell.contentView addSubview:weightLabel];
			[weightLabel release];
			
			cellUnitLabel = [[[UILabel alloc] initWithFrame:CGRectMake(170.0, 12.0, 30.0, 25.0)] autorelease];
			[cellUnitLabel setTag:UNIT_TAG];
			[cellUnitLabel setFont:[UIFont boldSystemFontOfSize:18]];
			[cellUnitLabel setTextColor:[UIColor blackColor]];
			[cellUnitLabel setTextAlignment:UITextAlignmentLeft];
			[cellUnitLabel setBackgroundColor:[UIColor whiteColor]];
			[cellUnitLabel setText:unit];
			[cellUnitLabel setOpaque:YES];
			[cell.contentView addSubview:cellUnitLabel];
			
		}
		
		if (indexPath.row == 1) {
			dateLabel = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 180.0, 25.0)];
			[dateLabel setEnabled:NO];
			[dateLabel setTag:DATE_TAG];
			[dateLabel setFont:[UIFont boldSystemFontOfSize:18]];
			[dateLabel setTextColor:[UIColor blackColor]];
			[dateLabel setBackgroundColor:[UIColor whiteColor]];
			[dateLabel setOpaque:YES];
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
		}
		
	} else {
		cellLabel = (UILabel *) [cell.contentView viewWithTag:LABEL_TAG];
		if (indexPath.row == 0) {
			weightLabel = (UITextField *) [cell.contentView viewWithTag:WEIGHT_TAG];
			cellUnitLabel = (UILabel *) [cell.contentView viewWithTag:UNIT_TAG];
		}
		if (indexPath.row == 1) dateLabel = (UITextField *) [cell.contentView viewWithTag:DATE_TAG];
	}
	
	if (indexPath.row == 0) { 
		if (selectedWeight.weight != nil) {
			NSString *weightText = [NSString stringWithFormat:@"%.2f", selectedWeight.weight.doubleValue];
			weightLabel.text = weightText;
		} else {
		}

		cellLabel.text = NSLocalizedString(@"Weight", nil);
	} else if (indexPath.row == 1) { 
		dateLabel.text = [DateHelper stringFromDate:selectedWeight.date withNames:NO];
		cellLabel.text = NSLocalizedString(@"Date", nil);
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	[self saveData];
	switch (indexPath.row) {
		case 0:
			edited = WEIGHT_TAG;
			editedFieldKey = @"weight";
			[weightLabel setEnabled:YES];
			[weightLabel becomeFirstResponder];
			datePicker.hidden = YES;
			break;
		case 1:
			edited = DATE_TAG;
			editedFieldKey = @"date";
			if (selectedWeight.date != nil) [datePicker setDate:selectedWeight.date];
			if (selectedWeight.date == nil) [dateLabel setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
			dateValue = datePicker.date;
			datePicker.hidden = NO;
			break;
	}
}

@end
