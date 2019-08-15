//
//  DetailViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesViewController.h"

@class Pet;

@interface DetailViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate,
													UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,
													UIPickerViewDelegate, UIPickerViewDataSource, ImagesViewControllerDelegate>
{
	BOOL isAddViewController;
	BOOL wasEdited;
	BOOL recalculeAge;
	UIView *contentView;
	UILabel *ageLabel;
	NSDate *dateValue;
	NSInteger edited;
	NSInteger primaryKey;
	NSString *editedFieldKey;
	UIButton *imagePet;
	UIButton *nameButton;
	UITableView *myTableView;
	UIDatePicker *datePicker;
	UITextField *nameField;
	UITextField *colorField;
	UILabel *bornField;
	UITextField *breedField;
	UILabel *genderField;
	UILabel *left;
	UIToolbar *toolBar;
	UIPickerView *myPickerView;
	NSMutableArray *pickerSourceArray;
	UIImagePickerController *pickerController;
	Pet *pet;
	Pet *tempPet;
}

@property (nonatomic, retain) Pet *pet;
@property (nonatomic, retain) UIView *contentView;

- (void)saveData;
- (void)tableViewAnimation:(BOOL)hide;
- (id)initWithPrimaryKey:(NSInteger)pk;

@end
