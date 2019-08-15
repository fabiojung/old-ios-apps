//
//  CallViewController.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 12/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"

@interface CallViewController : UIViewController <UITextFieldDelegate, 
												  ABPeoplePickerNavigationControllerDelegate,
												  UIActionSheetDelegate, 
												  ABNewPersonViewControllerDelegate,
												  ABPersonViewControllerDelegate>
{
	UIView *contentView;
	UITextField *operField;
	UILabel *dddField;
	UITextField *phoneField;
	UITextField *enabledField;
	NSMutableString *device;
	UIToolbar *mainToolBar;
	UISegmentedControl *mainTabBar;
	UILabel *label;
	UILabel *mainLabel;
	UILabel *operLabel;
	UILabel *wLabel;
	NSString *ddd;
	NSString *destino;
	ABPeoplePickerNavigationController *peoplePickerOnly;
	ABPeoplePickerNavigationController *peoplePickerToChange;
	NSInteger selectedButton;
	BOOL needsCustomKeyboard;
}

@property (nonatomic, copy) NSString *ddd;
@property (nonatomic, copy) NSString *destino;

- (void)dismissKeybord:(id)sender;

@end
