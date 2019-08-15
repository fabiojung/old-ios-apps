//
//  InfoViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"
#import "Constants.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, 
												  UITextViewDelegate, ABPeoplePickerNavigationControllerDelegate,
												  ABNewPersonViewControllerDelegate, ABPersonViewControllerDelegate>
{
	ABAddressBookRef ab;
	NSInteger primaryKey;
	NSInteger edited, vetID;
	NSString *editedFieldKey;
	UITableView *myTableView;
	UITextField *regField, *chipField;
	UILabel *vetField, *label;
	UITextView *notesField;
	ABNewPersonViewController *newPersonVC;
	Pet *pet;
	BOOL editingEnabled;
}

@property (nonatomic, assign) NSInteger primaryKey;
@property (nonatomic, assign) BOOL editingEnabled;
@property (nonatomic, retain) Pet *pet;

- (void)tableViewAnimation:(BOOL)hide;
- (void)saveData;

@end
