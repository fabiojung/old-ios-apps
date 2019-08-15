//
//  TextFieldViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 07/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "TextFieldViewController.h"


@implementation TextFieldViewController

- (id)init {
	if (self = [super init]) {
		self.navigationItem.title = NSLocalizedString(@"New Type", nil);
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
										 initWithTitle:NSLocalizedString(@"Cancel", nil)
										 style:UIBarButtonItemStylePlain
										 target:self
										 action:@selector(cancel)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		saveButton = [[UIBarButtonItem alloc]
									   initWithTitle:NSLocalizedString(@"Save", nil)
									   style:UIBarButtonItemStylePlain
									   target:self
									   action:@selector(save)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(enableSaveButton) 
													 name:UITextFieldTextDidChangeNotification 
												   object:nil];
		
	}
	return self;
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.view = contentView;
	[contentView release];
	myTextField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 80.0, 240.0, 30.0)];
	[myTextField setDelegate:self];
	[myTextField setBorderStyle:UITextBorderStyleRoundedRect];
	[myTextField setAutocorrectionType:UITextAutocorrectionTypeDefault];
	[myTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[myTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[myTextField setFont:[UIFont boldSystemFontOfSize:18]];
	[myTextField setTextColor:[UIColor blackColor]];
	[myTextField setBackgroundColor:[UIColor clearColor]];
	[myTextField becomeFirstResponder];
	[contentView addSubview:myTextField];
	[myTextField release];
	saveButton.enabled = NO;
}

- (void)enableSaveButton {
	if (myTextField.text.length < 1) {
		saveButton.enabled = NO;
	} else {
		saveButton.enabled = YES;
	}
}

- (void)save {
	int index = [[Type allObjects] count] + 1;
	Type *newType = [[Type alloc] init];
	newType.label = myTextField.text;
	newType.listorder = index;
	[newType save];
	[newType release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end
