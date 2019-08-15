//
//  AddEventViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "RecurrenceViewController.h"

@interface AddEventViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, RecurrenceViewControllerDelegate> {
	Event *selectedEntry;
	Event *tempEvent;
	UITableView *myTableView;
	int petPk;
	NSInteger edited;
	NSString *editedFieldKey;
	NSString *petName;
	NSDate *dateValue;
	NSDate *doneValue;
	UIDatePicker *datePicker;
	UILabel *cellLabel;
	UITextField *eventLabel;
	UILabel *dateLabel;
	UILabel *doneLabel;
	UILabel *repeatsLabel;
	UIImageView *checkBox;
	UIButton *checkButton;
}

@property (nonatomic, retain) Event *selectedEntry;
@property (nonatomic, copy) NSString *petName;
@property (assign, nonatomic) int petPk;

@end
