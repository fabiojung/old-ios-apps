//
//  RecurrenceViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 02/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecurrenceViewControllerDelegate;

@interface RecurrenceViewController : UITableViewController {
	NSArray *frequencyArray;
	id<RecurrenceViewControllerDelegate> delegate;
}

@property (assign) id<RecurrenceViewControllerDelegate> delegate;

@end

@protocol RecurrenceViewControllerDelegate <NSObject>

- (void)dismissRecurrenceViewController:(RecurrenceViewController *)controller;
- (void)updateEntryWith:(NSInteger)repeat;
- (NSInteger)repeatType;

@end

