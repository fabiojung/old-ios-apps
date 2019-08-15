//
//  InfoViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController (Private)
- (void)showVetInfo;
- (void)showAlert;
- (void)showDeletedAlert;
- (void)showRemoveAlert;
- (void)pickContact;
- (void)addContact;
- (void)updateVetName;
@end

@implementation InfoViewController

@synthesize primaryKey, pet, editingEnabled;

void ABChangedCallback(ABAddressBookRef ab, CFDictionaryRef info, void *context) {
	InfoViewController *infoVC = (InfoViewController *)context;
	[infoVC updateVetName];
}

- (id)init {
	if (self = [super init]) {
		[self setTitle:NSLocalizedString(@"MoreInfo", nil)];
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		self.editingEnabled = NO;
	}
	ab = ABAddressBookCreate();
	ABAddressBookRegisterExternalChangeCallback(ab, &ABChangedCallback, self);
	return self;
}

- (void)dealloc {
	ABAddressBookUnregisterExternalChangeCallback(ab, &ABChangedCallback, self);
	CFRelease(ab);
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	regField.delegate = nil;
	chipField.delegate = nil;
	notesField.delegate = nil;
	[pet release];
	[super dealloc];
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = contentView;
	[contentView release];
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0) style:UITableViewStyleGrouped];
	myTableView.allowsSelectionDuringEditing = YES;
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[myTableView setScrollEnabled:NO];
	[contentView addSubview:myTableView];
	[myTableView release];
	
}

- (void)viewWillAppear:(BOOL)animated {
	if (primaryKey > 0) {
		self.pet = (Pet*)[Pet findByPK:primaryKey];
	}
	[self updateVetName];
	if (editingEnabled) [self setEditing:YES animated:YES];
	[myTableView reloadData];
	[super viewWillAppear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (editing) {
		
	} else {
		[notesField resignFirstResponder];
		[self tableViewAnimation:NO];
		self.editingEnabled = NO;
	}
	[super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	[myTableView setEditing:editing animated:YES];
	[myTableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		UILabel *header = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 40.0)] autorelease];
		header.textAlignment = UITextAlignmentCenter;
		header.font = [UIFont boldSystemFontOfSize:20.0];
		header.opaque = YES;
		header.textColor = [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.00];
		header.shadowColor = [UIColor whiteColor];
		header.shadowOffset = CGSizeMake(1, 1);
		header.text = [NSString stringWithString:pet.name];
		header.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
		return header;
	} 
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) return 3;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) return 140;
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 1) return NSLocalizedString(@"Notes", nil);
	return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
	static NSString *CellIdentifier = @"InfoViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.contentView.autoresizesSubviews = YES;
		cell.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		if (indexPath.section == 0) {
			label = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 12.0, 100.0, 25.0)] autorelease];
			[label setTag:LABEL_INFO_TAG];
			[label setFont:[UIFont boldSystemFontOfSize:14]];
			[label setTextColor:[UIColor grayColor]];
			[label setTextAlignment:UITextAlignmentRight];
			[label setBackgroundColor:[UIColor whiteColor]];
			[label setOpaque:YES];
			[cell.contentView addSubview:label];
			
			if (indexPath.row == 0)	{
				regField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 190.0, 25.0)];
				[regField setEnabled:NO];
				[regField setDelegate:self];
				[regField setClearButtonMode:UITextFieldViewModeWhileEditing];
				[regField setReturnKeyType:UIReturnKeyDone];
				[regField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[regField setTag:REGISTRATION_TAG];
				[regField setFont:[UIFont boldSystemFontOfSize:18]];
				[regField setAdjustsFontSizeToFitWidth:YES];
				[regField setMinimumFontSize:12];
				[regField setTextColor:[UIColor blackColor]];
				[regField setBackgroundColor:[UIColor whiteColor]];
				[regField setOpaque:YES];
				[cell.contentView addSubview:regField];
				[regField release];
			}
			if (indexPath.row == 1)	{
				chipField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 190.0, 25.0)];
				[chipField setEnabled:NO];
				[chipField setDelegate:self];
				[chipField setClearButtonMode:UITextFieldViewModeWhileEditing];
				[chipField setReturnKeyType:UIReturnKeyDone];
				[chipField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[chipField setTag:CHIP_TAG];
				[chipField setFont:[UIFont boldSystemFontOfSize:18]];
				[chipField setAdjustsFontSizeToFitWidth:YES];
				[chipField setMinimumFontSize:12];
				[chipField setTextColor:[UIColor blackColor]];
				[chipField setBackgroundColor:[UIColor whiteColor]];
				[chipField setOpaque:YES];
				[cell.contentView addSubview:chipField];
				[chipField release];
			}
			if (indexPath.row == 2) {
				vetField = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 170.0, 25.0)];
				[vetField setTag:VET_TAG];
				vetField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				vetField.adjustsFontSizeToFitWidth = YES; 
				vetField.minimumFontSize = 14;
				[vetField setFont:[UIFont boldSystemFontOfSize:18]];
				[vetField setTextColor:[UIColor blackColor]];
				[vetField setBackgroundColor:[UIColor whiteColor]];
				[vetField setOpaque:YES];
				[cell.contentView addSubview:vetField];
				[vetField release];
			}
		}
		
		if (indexPath.section == 1)	{
			notesField = [[UITextView alloc] initWithFrame:CGRectMake(10, 6, 280, 120)];
			[notesField setDelegate:self];
			[notesField setTag:NOTES_TAG];
			[notesField setAutocorrectionType:UITextAutocorrectionTypeDefault];
			[notesField setBackgroundColor:[UIColor whiteColor]];
			[notesField setFont:[UIFont systemFontOfSize:14]];
			[notesField setUserInteractionEnabled:YES];
			[notesField setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
			[cell.contentView addSubview:notesField];
			[notesField release];
		}
	} else {
		if (indexPath.section == 0) {
			label = (UILabel *) [cell.contentView viewWithTag:LABEL_INFO_TAG];
			if (indexPath.row == 0) regField = (UITextField *) [cell.contentView viewWithTag:REGISTRATION_TAG];
			if (indexPath.row == 1) chipField = (UITextField *) [cell.contentView viewWithTag:CHIP_TAG];
			if (indexPath.row == 2) vetField = (UILabel *) [cell.contentView viewWithTag:VET_TAG];
		}
		
		if (indexPath.section == 1)	notesField = (UITextView *) [cell.contentView viewWithTag:NOTES_TAG];
	}
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0)	{
			if (self.pet.regnumber != nil) regField.text = [self.pet regnumber];
			label.text = NSLocalizedString(@"RegNumber", nil);
		}
		
		if (indexPath.row == 1) {
			if (self.pet.chipnumber != nil) chipField.text = [self.pet chipnumber];
			label.text = NSLocalizedString(@"ChipNumber", nil);
		}
		
		if (indexPath.row == 2) {
			if (!self.editing) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if ([self.pet vetname] != nil) {
				vetField.text = [self.pet vetname];
			}
			label.text = NSLocalizedString(@"Vet", nil);
		}
	}
	if (indexPath.section == 1)	{
		if (self.pet.notes != nil) notesField.text = [self.pet notes];
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 2) return YES;
	return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 2) return indexPath;
	return (self.editing) ? indexPath : nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    if (indexPath.section == 0 && indexPath.row == 2) {
		if ([vetField.text isEqualToString:@" "] || vetField.text == nil) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
    }
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self saveData];
	if (indexPath.section == 0 && indexPath.row == 2) {
		if (editingStyle == UITableViewCellEditingStyleInsert){
			[self showAlert];
		} 
		else if (editingStyle == UITableViewCellEditingStyleDelete) {
			[self.pet setVetid:0];
			[self.pet setVetname:@" "];
			[pet save];
			[myTableView reloadData];
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self saveData];
	
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0) {
				edited = REGISTRATION_TAG;
				editedFieldKey = @"regnumber";
				[regField setEnabled:YES];
				[regField becomeFirstResponder];
				[self tableViewAnimation:NO];
			}
			if (indexPath.row == 1) {
				edited = CHIP_TAG;
				editedFieldKey = @"chipnumber";
				[chipField setEnabled:YES];
				[chipField becomeFirstResponder];
				[self tableViewAnimation:NO];
			}
			if (indexPath.row == 2) {
				if (self.editing) {
					if ([self.pet vetid] == 0) {
						if ([self tableView:myTableView editingStyleForRowAtIndexPath:indexPath] == UITableViewCellEditingStyleInsert) {
							[self tableView:myTableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
						}
					}
				} else {
					if (![[self.pet vetname] isEqualToString:@" "]){
						[self showVetInfo];
					} 
					if ([[self.pet vetname] isEqualToString:@" "]) {
					}
				}
			}
			break;
		case 1:
			[self textViewDidBeginEditing:notesField];
			break;
	}
}

- (void)tableViewAnimation:(BOOL)hide {
	if (hide){
		if (myTableView.frame.origin.y == -185) return;
		[UIView beginAnimations:@"advancedAnimations" context:nil];
		[UIView setAnimationDuration:0.3];
		CGRect myTableViewFrame = myTableView.frame;
		myTableViewFrame.origin.y -= 185;
		myTableView.frame = myTableViewFrame;
		[UIView commitAnimations];
	} else if (!hide) {
		if (myTableView.frame.origin.y == 0) return;
		[UIView beginAnimations:@"advancedAnimations" context:nil];
		[UIView setAnimationDuration:0.3];
		CGRect myTableViewFrame = myTableView.frame;
		myTableViewFrame.origin.y += 185;
		myTableView.frame = myTableViewFrame;
		[UIView commitAnimations];
	}
}

- (void)saveData {
	if (editedFieldKey == nil) return;
	switch (edited) {
		case REGISTRATION_TAG:
			[self.pet setValue:regField.text forKey:editedFieldKey];
			regField.enabled = NO;
			break;
		case CHIP_TAG:
			[self.pet setValue:chipField.text forKey:editedFieldKey];
			chipField.enabled = NO;
			break;
		case NOTES_TAG:
			[self.pet setValue:notesField.text forKey:editedFieldKey];
			break;
	}
	editedFieldKey = nil;
	[self.pet save];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self tableViewAnimation:YES];
	edited = NOTES_TAG;
	editedFieldKey = @"notes";
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if (self.editing) return YES;
	return NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self saveData];	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self saveData];
	[self tableViewAnimation:NO];
	[textField setEnabled:NO];
	[textField resignFirstResponder];
	return NO;
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AddVet", nil) 
													  message:nil
													 delegate:self 
											cancelButtonTitle:nil
											otherButtonTitles:NSLocalizedString(@"PickOne", nil), 
															  NSLocalizedString(@"AddNew", nil), 
															  NSLocalizedString(@"Cancel", nil) ,
															  nil];
	[myAlert show];
	[myAlert release];
}

- (void)showDeletedAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VetNotFound", nil) 
													  message:NSLocalizedString(@"VetNotFoundMSG", nil) 
													 delegate:self 
											cancelButtonTitle:nil
											otherButtonTitles:NSLocalizedString(@"PickOne", nil), 
															  NSLocalizedString(@"AddNew", nil), 
															  NSLocalizedString(@"Cancel", nil), 
															  nil];
	[myAlert show];
	[myAlert release];
}

- (void)showRemoveAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RemoveVet", nil) 
													  message:nil
													 delegate:self 
											cancelButtonTitle:NSLocalizedString(@"NO", nil)
											otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
	
	[myAlert setTag:REMOVE_ALERT_TAG];
	[myAlert show];
	[myAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == REMOVE_ALERT_TAG) {
		if (buttonIndex == 0) return;
		if (buttonIndex == 1) {
			[self.pet setVetid:0];
			[self.pet setVetname:@" "];
			[pet save];
			[myTableView reloadData];
		}
	} else {
		if (buttonIndex == 0) { // Escolher dos contatos
			[self pickContact];
		} else if (buttonIndex == 1) { // Adicionar novo contato
			[self addContact];
		} else if (buttonIndex == 2) {
			[self.pet setVetid:0];
			[self.pet setVetname:@" "];
			[pet save];
			[myTableView reloadData];
		}
	}
}

- (void)pickContact {
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)addContact {
	newPersonVC = [[ABNewPersonViewController alloc] init];
	[newPersonVC setNewPersonViewDelegate:self];
	UINavigationController *newPersonNav = [[UINavigationController alloc] initWithRootViewController:newPersonVC];
	[newPersonVC release];
	[self presentModalViewController:newPersonNav animated:YES];
	[newPersonNav release];
}


- (void)showVetInfo {
	if ([self.pet vetid] == 0) {
		return;
	}
	ABRecordID personID = (ABRecordID)[self.pet vetid];
	ABAddressBookRef addressBook;
	addressBook = ABAddressBookCreate();
	ABRecordRef vet = ABAddressBookGetPersonWithRecordID(addressBook, personID);
	if (vet == NULL) {
		[self showDeletedAlert];
		CFRelease(addressBook);
		return;
	}
	ABPersonViewController *personView = [[ABPersonViewController alloc] init];
    personView.personViewDelegate = self;
	[personView setDisplayedPerson:vet];
	personView.allowsEditing = YES;
	UINavigationController *personNav = [[UINavigationController alloc] initWithRootViewController:personView];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
																   style:UIBarButtonItemStyleBordered 
																  target:self
																  action:@selector(dismissModalViewControllerAnimated:)];
	personView.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	[self presentModalViewController:personNav animated:YES];
    [personView release];
	[personNav release];
	CFRelease(addressBook);
}

- (void)updateVetName {
	if ([self.pet vetid] == 0) {
		return;
	}
	ABRecordID personID = (ABRecordID)[self.pet vetid];
	ABAddressBookRef addressBook = ABAddressBookCreate();
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, personID);
	if (person == NULL) {
		CFRelease(addressBook);
		return;
	}
	CFStringRef theName = ABRecordCopyCompositeName(person);
	[self.pet setVetname:[NSString stringWithString:(NSString *)theName]];
	CFRelease(theName);
	CFRelease(addressBook);
}

#pragma mark AddressBook

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	CFStringRef theName = ABRecordCopyCompositeName(person);
	[self.pet setVetname:[NSString stringWithString:(NSString *)theName]];
	CFRelease(theName);
	[self.pet setVetid:(NSInteger)ABRecordGetRecordID(person)];
    [self dismissModalViewControllerAnimated:YES];
	[self.pet save];
	[myTableView reloadData];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person {
	if (person == NULL) {
		[self dismissModalViewControllerAnimated:YES];
		return;
	}
	
	CFStringRef theName = ABRecordCopyCompositeName(person);
	NSString *nameString = [NSString stringWithString:(NSString *)theName];
	[self.pet setVetname:nameString];
	CFRelease(theName);
	[self.pet setVetid:(NSInteger)ABRecordGetRecordID(person)];
	[self.pet save];
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person 
					property:(ABPropertyID)property 
				  identifier:(ABMultiValueIdentifier)identifier {
	return YES;
}

@end
