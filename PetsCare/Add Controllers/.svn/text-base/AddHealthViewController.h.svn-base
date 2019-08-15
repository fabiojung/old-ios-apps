//
//  AddHealthViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Health.h"
#import "Three20.h"
#import "RecurrenceViewController.h"

@interface AddHealthViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, 
													   RecurrenceViewControllerDelegate>

{
	int petPk;
	Health *selectedEntry;
	Health *tempEntry;
	NSDate *dateValue;
	UITableView *myTableView;
	NSInteger edited;
	NSString *editedFieldKey;
	NSString *newType;
	UIDatePicker *datePicker;
	UILabel *cellLabel;
	UITextField *tagLabel;
	UITextField *typeLabel;
	UITextField *dateLabel;
	UITextField *doneLabel;
	UIToolbar *datePickerBar;
	UIView *contentView;
	UILabel *repeatsLabel;
	UIImageView *checkBox;
	UIButton *checkButton;
}

@property (nonatomic, retain) Health *selectedEntry;
@property (nonatomic, copy) NSString *newType;
@property (assign, nonatomic) int petPk;

@end
