//
//  CategoryAddViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 22/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "CategoryAddViewController.h"
#import "BaseView.h"
#import "Category.h"

@implementation CategoryAddViewController

@synthesize category;
@synthesize sortOrder;
@synthesize delegate;
@synthesize editingCategory;

- (void)registerForTextFieldNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldDidChange:)
												 name:UITextFieldTextDidChangeNotification 
											   object:nil];
}

- (void)unregisterForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UITextFieldTextDidChangeNotification 
												  object:nil];
}

- (id)init {
    if (self = [super init]) {
		
		UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" 
																			 style:UIBarButtonItemStyleBordered 
																			target:self 
																			action:@selector(cancel)];
		self.navigationItem.leftBarButtonItem = cancelButtonItem;
		[cancelButtonItem release];
		
		saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" 
														  style:UIBarButtonItemStyleDone 
														 target:self 
														 action:@selector(save)];
		self.navigationItem.rightBarButtonItem = saveButtonItem;
		[saveButtonItem release];
		saveButtonItem.enabled = NO;
		[self registerForTextFieldNotifications];
	}
    return self;
}

- (void)loadView {
	BaseView *contentView = [[BaseView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 70.0, 280.0, 31.0)];
	nameTextField.delegate = self;
	nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	nameTextField.autocorrectionType = UITextAutocorrectionTypeDefault;
	nameTextField.enablesReturnKeyAutomatically = YES;
	nameTextField.borderStyle = UITextBorderStyleRoundedRect;
	nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	nameTextField.font = [UIFont systemFontOfSize:17.0];
	[contentView addSubview:nameTextField];
	[nameTextField release];
	
	self.view = contentView;
	[contentView release];
}

- (void)viewWillAppear:(BOOL)animated {
	if (editingCategory) {
		nameTextField.text = NSLocalizedString(category.categoryName, nil);
		self.navigationItem.title = NSLocalizedString(@"EditList_Loc", nil);
	} else {
		self.navigationItem.title = NSLocalizedString(@"NewList_Loc", nil);
	}

	
	if (nameTextField.text.length > 0) {
		saveButtonItem.enabled = YES;
	}
}

- (void)viewDidLoad {
	[nameTextField becomeFirstResponder];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == nameTextField) {
		[nameTextField resignFirstResponder];
		[self save];
	}
	return YES;
}

- (void)textFieldDidChange:(NSNotification*)aNotification {
	if (nameTextField.text.length == 0) {
		saveButtonItem.enabled = NO;
	} else {
		saveButtonItem.enabled = YES;
	}
}

- (void)contextSave {
	NSError *error = nil;
	if (![category.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

- (void)save {
	if (editingCategory) {
		category.categoryName = nameTextField.text;
		[self contextSave];
		[self.delegate popCategoryAddViewController:self];
	} else {
		category.categoryName = nameTextField.text;
		category.sortOrder = self.sortOrder;
		[self.delegate categoryAddViewController:self didAddCategory:category];
	}
}

- (void)cancel {
	if (!editingCategory) {
		[category.managedObjectContext deleteObject:category];
		[self contextSave];
		[self.delegate categoryAddViewController:self didAddCategory:nil];
	} else {
		[self.delegate popCategoryAddViewController:self];
	}
}

- (void)dealloc {
	[self unregisterForKeyboardNotifications];
	nameTextField.delegate = nil;
	self.delegate = nil;
    [category release];
	[sortOrder release];
    [super dealloc];
}

@end
