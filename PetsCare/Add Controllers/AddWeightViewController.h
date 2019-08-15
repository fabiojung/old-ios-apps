//
//  AddWeightViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 26/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weight.h"

@interface AddWeightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	Weight *selectedWeight;
	Weight *tempWeight;
	UITableView *myTableView;
	NSNumber *doubleValue;
	int petPk;
	NSInteger edited;
	NSString *editedFieldKey;
	NSString *petName;
	NSString *unit;
	NSDate *dateValue;
	UIDatePicker *datePicker;
	UILabel *cellLabel;
	UILabel *cellUnitLabel;
	UITextField *weightLabel;
	UITextField *dateLabel;
	BOOL flag;
}

@property (nonatomic, retain) Weight *selectedWeight;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, copy) NSString *unit;
@property (assign, nonatomic) int petPk;

@end
