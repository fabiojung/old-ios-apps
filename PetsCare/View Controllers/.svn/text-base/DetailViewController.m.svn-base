//
//  DetailViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "DetailViewController.h"
#import "InfoViewController.h"
#import "HealthViewController.h"
#import "EventViewController.h"
#import "ImageClass.h"
#import "Constants.h"
#import "DateHelper.h"
#import "Pet.h"
#import "WeightViewController.h"
#import "CheckOSVersion.h"

@interface DetailViewController (Private)

- (void)calculeAge;
- (void)changePetData;
- (void)saveData;
- (void)changeName;
- (void)showPhotoUploadScreen:(id)sender;
- (void)showHealth;
- (void)showWeights;
- (void)showEvents;
- (void)changeDate;
- (void)useImage:(UIImage *)theImage;
- (void)pickPhotoFromPhotoLibrary:(id)sender;
- (void)pickPhotoFromCamera:(id)sender;
- (void)pickPhotoFromImages:(id)sender;
- (void)showPhotoPickerActionSheet;
- (void)createAndPopulateArray;
- (void)confirmDeletePetPhoto;
@end

@implementation DetailViewController

@synthesize pet, contentView;

- (id)initWithPrimaryKey:(NSInteger)pk {
	if (self = [super init]) {
		[self setTitle:NSLocalizedString(@"Info", nil)];
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) 
																	   style:UIBarButtonItemStyleBordered 
																	  target:nil 
																	  action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release];
		
		primaryKey = pk;
		recalculeAge = YES;
	}
	return self;
}

- (void)dealloc {
	pickerController.delegate = nil;
	nameField.delegate = nil;
	breedField.delegate = nil;
	colorField.delegate = nil;
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	[contentView release];
	contentView = nil;
	[pet release];
	[tempPet release];
	[Pet clearCache];
	[pickerSourceArray release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (void)loadView {
	contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	imagePet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[imagePet setFrame:CGRectMake(15, 35, 64, 64)];
	[imagePet setBackgroundColor:[UIColor clearColor]];
	[imagePet setUserInteractionEnabled:NO];
	[imagePet addTarget:self action:@selector(showPhotoUploadScreen:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:imagePet];
	
	nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[nameButton setFrame:CGRectMake(98, 35, 212, 64)];
	[nameButton setEnabled:NO];
	[nameButton addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:nameButton];
	nameButton.hidden = YES;
	
	nameField = [[UITextField alloc] initWithFrame:CGRectMake(108, 55, 200, 20)];
	[nameField setEnabled:NO];
	[nameField setDelegate:self];
	[nameField setAutocorrectionType:UITextAutocorrectionTypeDefault];
	[nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[nameField setPlaceholder:NSLocalizedString(@"Name", nil)];
	[nameField setReturnKeyType:UIReturnKeyDone];
	[nameField setTag:NAME_TAG];
	[nameField setFont:[UIFont boldSystemFontOfSize:18]];
	[nameField setTextColor:[UIColor blackColor]];
	[nameField setBackgroundColor:[UIColor clearColor]];
	[nameField setOpaque:YES];
	[contentView addSubview:nameField];
	[nameField release];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 110.0, 320.0, 280.0) style:UITableViewStyleGrouped];
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[myTableView setScrollEnabled:NO];
	[contentView addSubview:myTableView];
	[myTableView release];
	
	if (!isAddViewController) {
		toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 375.0, 320.0, 44.0)];
		NSArray *buttons = [NSArray arrayWithObjects:NSLocalizedString(@"Health", nil), 
													 NSLocalizedString(@"Events", nil), 
													 NSLocalizedString(@"Growth", nil), 
													 nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
		segmentedControl.momentary = YES;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		segmentedControl.frame = CGRectMake(10, 7, 300, 30);
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		[toolBar addSubview:segmentedControl];
		[segmentedControl release];
		[toolBar setBarStyle:UIBarStyleDefault];
		[toolBar setTag:TOOLBAR_TAG];
		[contentView addSubview:toolBar];
		[toolBar release];
		
		ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 75, 200, 20)];
		[ageLabel setFont:[UIFont systemFontOfSize:14]];
		[ageLabel setTextColor:[UIColor darkGrayColor]];
		[ageLabel setBackgroundColor:[UIColor clearColor]];
		[ageLabel setOpaque:YES];
		[contentView addSubview:ageLabel];
		[ageLabel release];
	}
	self.view = contentView;
}

- (void)segmentAction:(id)sender {
	switch([sender selectedSegmentIndex] + 1) {
		case 1: [self showHealth]; break;
		case 2: [self showEvents]; break;
		case 3: [self showWeights]; break;
	}
}

- (void)createAndPopulateArray {
	pickerSourceArray = nil;
	pickerSourceArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Female", nil), 
														 NSLocalizedString(@"Male", nil), 
														 NSLocalizedString(@"Spayed", nil),
														 NSLocalizedString(@"Neutered", nil), 
														 nil];
}

- (void)viewWillAppear:(BOOL)animated {
	if (self.view == nil) {
		self.view = contentView;
	}
	if (primaryKey > 0 && self.pet == nil) {
		self.pet = (Pet *)[Pet findByPK:primaryKey];
		if (!isAddViewController && recalculeAge) {
			[self calculeAge];
			recalculeAge = NO;
		} 
	}
	
	if ([self.pet photo] != nil) [imagePet setBackgroundImage:[self.pet photo] forState:UIControlStateNormal];
	if ([self.pet photo] == nil) [imagePet setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
																			   pathForResource:NSLocalizedString(@"addPhoto", nil) 
																						ofType:@"png"]] 
																					  forState:UIControlStateNormal];
	[myTableView reloadData];
	[super viewWillAppear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (editing) {
		wasEdited = YES;
		
		datePicker = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, 300.0, 200.0)] autorelease];
		[datePicker setDatePickerMode:UIDatePickerModeDate];
		[datePicker setMaximumDate:[NSDate date]];
		[datePicker setTag:DATE_PICKER_TAG];
		[datePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
		[contentView addSubview:datePicker];
		datePicker.hidden = YES;
		
		myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
		[self createAndPopulateArray];
		[myPickerView setDelegate:self];
		[myPickerView setDataSource:self];
		myPickerView.showsSelectionIndicator = YES;
		[contentView addSubview:myPickerView];
		[myPickerView release];
		myPickerView.hidden = YES;
		
		ageLabel.hidden = YES;
		nameButton.hidden = NO;
		nameButton.enabled = YES;
		[imagePet setUserInteractionEnabled:YES];
		if ([self.pet photo] != nil) {
			[imagePet setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												pathForResource:NSLocalizedString(@"editPNG", nil) 
														 ofType:@"png"]] 
													   forState:UIControlStateNormal];
		}
		toolBar.hidden = YES;
	} else {
		nameButton.hidden = YES;
		datePicker.hidden = YES;
		myPickerView.hidden = YES;
		nameField.hidden = NO;
		nameButton.enabled = NO;
		toolBar.hidden = NO;
		ageLabel.hidden = NO;
		if (wasEdited) {
			[self changePetData];
			[self tableViewAnimation:NO];
			[imagePet setUserInteractionEnabled:NO];
			if (recalculeAge) [self calculeAge];
			[myTableView reloadData];
			wasEdited = NO;
		}
		[imagePet setImage:nil forState:UIControlStateNormal];
		myPickerView.delegate = nil;
		myPickerView.dataSource = nil;
		[datePicker removeFromSuperview];
		[myPickerView removeFromSuperview];
	}
	[super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (isAddViewController) return 1;
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1) {
		return 1;
	}
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
	static NSString *CellIdentifier = @"DetailViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if ([CheckOSVersion isNewOS]) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		else 
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		if (indexPath.section == 0) {
			left = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 12.0, 100.0, 25.0)] autorelease];
			[left setTag:LEFT_TAG];
			[left setFont:[UIFont boldSystemFontOfSize:14]];
			[left setTextColor:[UIColor grayColor]];
			[left setTextAlignment:UITextAlignmentRight];
			[left setBackgroundColor:[UIColor whiteColor]];
			[left setOpaque:YES];
			[cell.contentView addSubview:left];
			
			if (indexPath.row == 0)	{
				bornField = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 195.0, 25.0)];
				[bornField setTag:BORN_TAG];
				[bornField setFont:[UIFont boldSystemFontOfSize:18]];
				[bornField setTextColor:[UIColor blackColor]];
				[bornField setBackgroundColor:[UIColor whiteColor]];
				[bornField setOpaque:YES];
				[cell.contentView addSubview:bornField];
				[bornField release];
			}
			
			if (indexPath.row == 1) {
				breedField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 195.0, 25.0)];
				[breedField setEnabled:NO];
				[breedField setDelegate:self];
				[breedField setClearButtonMode:UITextFieldViewModeWhileEditing];
				[breedField setReturnKeyType:UIReturnKeyDone];
				[breedField setAutocorrectionType:UITextAutocorrectionTypeDefault];
				[breedField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
				[breedField setTag:BREED_TAG];
				[breedField setFont:[UIFont boldSystemFontOfSize:18]];
				[breedField setAdjustsFontSizeToFitWidth:YES];
				[breedField setMinimumFontSize:12];
				[breedField setTextColor:[UIColor blackColor]];
				[breedField setBackgroundColor:[UIColor whiteColor]];
				[breedField setOpaque:YES];
				[cell.contentView addSubview:breedField];
				[breedField release];
			}
			
			if (indexPath.row == 2) {
				colorField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 195.0, 25.0)];
				[colorField setEnabled:NO];
				[colorField setDelegate:self];
				[colorField setClearButtonMode:UITextFieldViewModeWhileEditing];
				[colorField setReturnKeyType:UIReturnKeyDone];
				[colorField setAutocorrectionType:UITextAutocorrectionTypeDefault];
				[colorField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
				[colorField setTag:COLOR_TAG];
				[colorField setFont:[UIFont boldSystemFontOfSize:18]];
				[colorField setAdjustsFontSizeToFitWidth:YES];
				[colorField setMinimumFontSize:12];
				[colorField setTextColor:[UIColor blackColor]];
				[colorField setBackgroundColor:[UIColor whiteColor]];
				[colorField setOpaque:YES];
				[cell.contentView addSubview:colorField];
				[colorField release];
			}
			
			if (indexPath.row == 3) {
				genderField = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 12.0, 195.0, 25.0)];
				[genderField setTag:GENDER_TAG];
				[genderField setFont:[UIFont boldSystemFontOfSize:18]];
				[genderField setTextColor:[UIColor blackColor]];
				[genderField setBackgroundColor:[UIColor whiteColor]];
				[genderField setOpaque:YES];
				[cell.contentView addSubview:genderField];
				[genderField release];
			}
		}
	} else {
		if (indexPath.section == 0) {
			left = (UILabel *) [cell.contentView viewWithTag:LEFT_TAG];
			if (indexPath.row == 0) bornField = (UILabel *) [cell.contentView viewWithTag:BORN_TAG];
			if (indexPath.row == 1) breedField = (UITextField *) [cell.contentView viewWithTag:BREED_TAG];
			if (indexPath.row == 2) colorField = (UITextField *) [cell.contentView viewWithTag:COLOR_TAG];
			if (indexPath.row == 3) genderField = (UILabel *) [cell.contentView viewWithTag:GENDER_TAG];
		}
	}
	if (indexPath.section == 0) {
		if ([self.pet name] != nil) {
			[nameField setTextColor:[UIColor blackColor]];
			[nameField setText:[self.pet name]];
		} else if ([self.pet name] == nil) {
			[nameField setTextColor:[UIColor grayColor]];
			nameField.text = nil;
		}
		
		if (indexPath.row == 0) {
			[bornField setText:[DateHelper stringFromDate:[self.pet born] withNames:NO]];
			NSString *born = NSLocalizedString(@"Born", nil);
			[left setText:born];
		} else if (indexPath.row == 1) { 
			[breedField setText:[self.pet breed]];
			NSString *breed = NSLocalizedString(@"Breed", nil);
			[left setText:breed];
		} else if (indexPath.row == 2) { 
			[colorField setText:[self.pet color]];
			NSString *color = NSLocalizedString(@"Color", nil);
			[left setText:color];
		} else if (indexPath.row == 3) {
			[genderField setText:NSLocalizedString([self.pet gender], nil)];
			NSString *gender = NSLocalizedString(@"Gender", nil);
			[left setText:gender];
		}
	} else {
		NSString *moreInfo = NSLocalizedString(@"MoreInfo", nil);
		if ([CheckOSVersion isNewOS]) 
			cell.textLabel.text = moreInfo;
		else
			cell.text = moreInfo;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell; 
} 

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return indexPath;
	return (self.editing) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	[self saveData];
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				edited = BORN_TAG;
				editedFieldKey = @"born";
				if ([self.pet born] != nil) [datePicker setDate:[self.pet born]];
				if ([self.pet born] == nil) [bornField setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
				dateValue = datePicker.date;
				nameField.hidden = YES;
				datePicker.hidden = NO;
				recalculeAge = YES;
				[self tableViewAnimation:YES];
				break;
			case 1:
				edited = BREED_TAG;
				editedFieldKey = @"breed";
				[breedField setEnabled:YES];
				[breedField becomeFirstResponder];
				nameField.hidden = YES;
				[self tableViewAnimation:YES];
				break;
			case 2:
				edited = COLOR_TAG;
				editedFieldKey = @"color";
				[colorField setEnabled:YES];
				[colorField becomeFirstResponder];
				nameField.hidden = YES;
				[self tableViewAnimation:YES];
				break;
			case 3:
				edited = GENDER_TAG;
				editedFieldKey = @"gender";
				if ([self.pet gender] == nil) {
					[genderField setText:NSLocalizedString(@"Female", nil)];
				}
				myPickerView.hidden = NO;
				datePicker.hidden = YES;
				[self tableViewAnimation:YES];
				break;
		} 
	} else {
		InfoViewController *controller = [[InfoViewController alloc] init];
		controller.primaryKey = primaryKey;
		if (self.editing) controller.editingEnabled = YES;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

- (void)changeName {
	[self saveData];
	nameButton.enabled = NO;
	edited = NAME_TAG;
	editedFieldKey = @"name";
	[nameField setEnabled:YES];
	[nameField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self saveData];
	[self tableViewAnimation:NO];
	nameButton.enabled = YES;
	nameField.hidden = NO;
	[textField setEnabled:NO];
	[textField resignFirstResponder];
	return NO; 
}

- (void)saveData {
	if (editedFieldKey == nil) return;
	if (tempPet == nil) tempPet = [[Pet alloc] init];
	nameField.hidden = NO;
	switch (edited) {
		case BORN_TAG:
			[tempPet setValue:dateValue forKey:editedFieldKey];
			datePicker.hidden = YES;
			recalculeAge = YES;
			break;
		case BREED_TAG:
			[tempPet setValue:breedField.text forKey:editedFieldKey];
			breedField.enabled = NO;
			break;
		case COLOR_TAG:
			[tempPet setValue:colorField.text forKey:editedFieldKey];
			colorField.enabled = NO;
			break;
		case GENDER_TAG:
			[tempPet setValue:genderField.text forKey:editedFieldKey];
			myPickerView.hidden = YES;
			break;
		case NAME_TAG:
			[tempPet setValue:nameField.text forKey:editedFieldKey];
			nameField.enabled = NO;
			break;
		default:
			break;
	}
	editedFieldKey = nil;
}

- (void)changePetData {
	[self saveData];
	if (tempPet.name != self.pet.name && tempPet.name.length > 0) {
		self.pet.name = tempPet.name;
	}
	if (tempPet.born && tempPet.born != self.pet.born) {
		self.pet.born = tempPet.born;
	}
	if (tempPet.breed != self.pet.breed && tempPet.breed.length > 0) {
		self.pet.breed = tempPet.breed;
	}
	if (tempPet.color != self.pet.color && tempPet.color.length > 0) {
		self.pet.color = tempPet.color;
	}
	if (tempPet.gender != self.pet.gender && tempPet.gender.length > 0) {
		self.pet.gender = tempPet.gender;
	}
	[self.pet save];
}

- (void)changeDate {
	[bornField setText:[DateHelper stringFromDate:datePicker.date withNames:NO]];
	dateValue = datePicker.date;
}

- (void)showHealth {
	HealthViewController *hController = [[HealthViewController alloc] init];
	hController.petPk = primaryKey;
	hController.petName = [NSString stringWithFormat:@"%@", self.pet.name];
	[self.navigationController pushViewController:hController animated:YES];
	[hController release];
}

- (void)showWeights {
	WeightViewController *wController = [[WeightViewController alloc] init];
	wController.petPk = primaryKey;
	wController.petName = [NSString stringWithFormat:@"%@", self.pet.name];
	[self.navigationController pushViewController:wController animated:YES];
	[wController release];
}

- (void)showEvents {
	EventViewController *eController = [[EventViewController alloc] init];
	eController.petPk = primaryKey;
	eController.petName = [NSString stringWithFormat:@"%@", self.pet.name];
	[self.navigationController pushViewController:eController animated:YES];
	[eController release];
}

- (void)calculeAge {
	[ageLabel setText:[DateHelper petAgeFromBornDate:[pet born]]];
	recalculeAge = NO;
}

- (void)tableViewAnimation:(BOOL)hide {
	if (hide){
		if (myTableView.frame.origin.y == 0) return;
		[UIView beginAnimations:@"advancedAnimations" context:nil];
		[UIView setAnimationDuration:0.2];
		CGRect myTableViewFrame = myTableView.frame;
		myTableViewFrame.origin.y -= 110;
		myTableView.frame = myTableViewFrame;
		[UIView commitAnimations];
	} else if (!hide) {
		if (myTableView.frame.origin.y == 110) return;
		[UIView beginAnimations:@"advancedAnimations" context:nil];
		[UIView setAnimationDuration:0.2];
		CGRect myTableViewFrame = myTableView.frame;
		myTableViewFrame.origin.y += 110;
		myTableView.frame = myTableViewFrame;
		[UIView commitAnimations];
	}
}

#pragma mark PickerVIEW

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return pickerSourceArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 200;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [pickerSourceArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[genderField setText:[NSString stringWithString:[pickerSourceArray objectAtIndex:[myPickerView selectedRowInComponent:0]]]];
}


#pragma mark Photo

- (void)showPhotoUploadScreen:(id)sender {
	[self saveData];
	[self showPhotoPickerActionSheet];
}

- (void)addPhotoFromLibraryAction:(id)sender {
	[self pickPhotoFromPhotoLibrary:nil];
}

- (void)addPhotoFromCameraAction:(id)sender {
	[self pickPhotoFromCamera:nil];		
}

- (UIImagePickerController *)pickerController {
	if( pickerController == nil ) {
		pickerController = [[UIImagePickerController alloc] init];
		[pickerController setDelegate:self];
		[pickerController setAllowsImageEditing:YES];
	}
	return pickerController;
}

- (void)clearPickerController {
	pickerController.delegate = nil;
	[pickerController release];
	pickerController = nil;
}

- (void)showPhotoPickerActionSheet {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) { // iPhone with Camera
		if ([self.pet photo] == nil) {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
													   destructiveButtonTitle:nil
															otherButtonTitles:NSLocalizedString(@"TakePhoto", nil), 
																			  NSLocalizedString(@"AddPhoto", nil),
																			  NSLocalizedString(@"GenericImages", nil), nil];
			[actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
			[actionSheet setTag:IPHONE_CAMERA_ADD_TAG];
			[actionSheet showInView:self.view];
			[actionSheet release];
			
		} else {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
													   destructiveButtonTitle:nil
															otherButtonTitles:NSLocalizedString(@"TakePhoto", nil), 
																			  NSLocalizedString(@"AddPhoto", nil),
																			  NSLocalizedString(@"GenericImages", nil),
																			  NSLocalizedString(@"DeletePhoto", nil), nil];
			[actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
			[actionSheet setTag:IPHONE_CAMERA_EDIT_TAG];
			[actionSheet showInView:self.view];
			[actionSheet release];
			
		}
		
	} else { // iPod without Camera
		if ([self.pet photo] == nil) {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
													   destructiveButtonTitle:nil
															otherButtonTitles:NSLocalizedString(@"AddPhoto", nil),
																			  NSLocalizedString(@"GenericImages", nil), nil];
			[actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
			[actionSheet setTag:IPOD_NOCAMERA_ADD_TAG];
			[actionSheet showInView:self.view];
			[actionSheet release];
			
		} else {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
																	 delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
													   destructiveButtonTitle:nil
															otherButtonTitles:NSLocalizedString(@"AddPhoto", nil),
																			  NSLocalizedString(@"GenericImages", nil),
																			  NSLocalizedString(@"DeletePhoto", nil), nil];
			[actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
			[actionSheet setTag:IPOD_NOCAMERA_EDIT_TAG];
			[actionSheet showInView:self.view];
			[actionSheet release];
			
		}	
	}	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([actionSheet tag] == IPHONE_CAMERA_ADD_TAG) {
		if (buttonIndex == 0) [self pickPhotoFromCamera:nil];
		else if (buttonIndex == 1) [self pickPhotoFromPhotoLibrary:nil];
		else if (buttonIndex == 2) [self pickPhotoFromImages:nil];
	} else if ([actionSheet tag] == IPHONE_CAMERA_EDIT_TAG) {
		if (buttonIndex == 0) [self pickPhotoFromCamera:nil];
		else if (buttonIndex == 1) [self pickPhotoFromPhotoLibrary:nil];
		else if (buttonIndex == 2) [self pickPhotoFromImages:nil];
		else if (buttonIndex == 3) [self confirmDeletePetPhoto];
	} else if ([actionSheet tag] == IPOD_NOCAMERA_ADD_TAG) {
		if (buttonIndex == 0) [self pickPhotoFromPhotoLibrary:nil];
		else if (buttonIndex == 1) [self pickPhotoFromImages:nil];
	} else if ([actionSheet tag] == IPOD_NOCAMERA_EDIT_TAG) {
		if (buttonIndex == 0) [self pickPhotoFromPhotoLibrary:nil];
		else if (buttonIndex == 1) [self pickPhotoFromImages:nil];
		else if (buttonIndex == 2) [self confirmDeletePetPhoto];
	} else if ([actionSheet tag] == DELETE_PHOTO_TAG) {
		if (buttonIndex == 0) {
			[self useImage:nil];
			[imagePet setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
																		   pathForResource:NSLocalizedString(@"addPhoto", nil) 
																		   ofType:@"png"]] forState:UIControlStateNormal];
			[imagePet setImage:nil forState:UIControlStateNormal];
		}
	}
}

- (void)confirmDeletePetPhoto {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self 
													cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
											   destructiveButtonTitle:NSLocalizedString(@"DeletePhoto", nil)
													otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
	[actionSheet setTag:DELETE_PHOTO_TAG];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)pickPhotoFromCamera:(id)sender {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *picker = [self pickerController];
		[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
		[[self navigationController] presentModalViewController:picker animated:YES];
	}
}

- (void)pickPhotoFromPhotoLibrary:(id)sender {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController *picker = [self pickerController];
		[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		[self.navigationController presentModalViewController:picker animated:YES];
	}
}

- (void)pickPhotoFromImages:(id)sender {
	ImagesViewController *controller = [[ImagesViewController alloc] init];
	controller.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	[self.navigationController presentModalViewController:nav animated:YES];
	[controller release];
	[nav release];
}

- (void)imagePickerController:(UIImagePickerController *)picker	didFinishPickingImage:(UIImage *)anImage editingInfo:(NSDictionary *)editingInfo {
	[self useImage:anImage];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	nameField.hidden = NO;
	[self clearPickerController];
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[self clearPickerController];
}

- (void)useImage:(UIImage *)theImage {
	if (theImage != nil) {
		if (!isAddViewController && recalculeAge) [self calculeAge];
		
		[self.pet setPhoto:[UIImage setImage:theImage]];
		
		[imagePet setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
										    pathForResource:NSLocalizedString(@"editPNG", nil) 
													 ofType:@"png"]] 
												   forState:UIControlStateNormal];
	} else {
		[self.pet setPhoto:nil];
	}
}

- (void)imagesViewControllerDidCancel:(ImagesViewController *)album {
	[album dismissModalViewControllerAnimated:YES];
}

- (void)imagesViewController:(ImagesViewController *)album didFinishPickingImage:(UIImage *)anImage {
	[self useImage:anImage];
	nameField.hidden = NO;
	[album dismissModalViewControllerAnimated:YES];
}

@end
