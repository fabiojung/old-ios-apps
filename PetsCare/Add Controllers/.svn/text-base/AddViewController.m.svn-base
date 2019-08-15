//
//  AddViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "AddViewController.h"
#import "Pet.h"
#import "DateHelper.h"

@interface AddViewController ()
- (void)cancel:(id)sender;
- (void)save:(id)sender;
- (void)checkFields;
- (void)showAlert;
@end

@implementation AddViewController

- (id)init {
	if (self = [super init]) {
		[self setTitle:NSLocalizedString(@"AddPet", nil)];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																							   target:self action:@selector(cancel:)] autorelease];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																								target:self action:@selector(save:)] autorelease];
		self.pet = [[Pet alloc] init];
	}
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	isAddViewController = YES;
	self.editing = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	if (tempPet.name != nil) nameField.text = tempPet.name;
	if (tempPet.breed != nil) breedField.text = tempPet.breed;
	if (tempPet.born != nil) bornField.text = [DateHelper stringFromDate:tempPet.born withNames:NO];
	if (tempPet.color != nil) colorField.text = tempPet.color;
	if (tempPet.gender != nil) genderField.text = tempPet.gender;
}

- (void)dealloc {
	[pet release];
    [super dealloc];
}

- (void)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkFields {
	if (tempPet.name != self.pet.name && tempPet.name.length > 0) {
		self.pet.name = tempPet.name;
	} else {
		self.pet.name = NSLocalizedString(@"NoName", nil);
	}
	if (tempPet.born && tempPet.born != self.pet.born) {
		self.pet.born = tempPet.born;
	} else {
		self.pet.born = [NSDate date];
	}
	if (tempPet.breed != self.pet.breed && tempPet.breed.length > 0) {
		self.pet.breed = tempPet.breed;
	} else {
		self.pet.breed = NSLocalizedString(@"NoBreed", nil);
	}
	if (tempPet.color != self.pet.color && tempPet.color.length > 0) {
		self.pet.color = tempPet.color;
	} else {
		self.pet.color = NSLocalizedString(@"NoColor", nil);
	}
	if (tempPet.gender != self.pet.gender && tempPet.gender.length > 0) {
		self.pet.gender = tempPet.gender;
	} else {
		self.pet.gender = NSLocalizedString(@"NoGender", nil);
	}
}

- (void)showAlert {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops..." 
													  message:NSLocalizedString(@"NoName", nil)
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"OK", nil];
	[myAlert show];
	[myAlert release];
}

- (void)save:(id)sender {
	[super saveData];
	[super tableViewAnimation:NO];
	if (tempPet.name == nil || tempPet.name.length == 0) {
		[self showAlert];
		return;
	}
	[self checkFields];
	[self.pet save];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
