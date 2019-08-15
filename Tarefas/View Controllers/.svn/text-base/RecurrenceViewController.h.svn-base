//
//  RecurrenceViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 02/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecurrenceViewControllerDelegate;

@interface RecurrenceViewController : UITableViewController {
	NSMutableArray *frequencyArray;
	id<RecurrenceViewControllerDelegate> delegate;
}

@property (assign) id<RecurrenceViewControllerDelegate> delegate;

@end

@protocol RecurrenceViewControllerDelegate <NSObject>

- (void)updateTaskWithRecurrence:(NSInteger)value;
- (void)updateTaskWithRecurrenceFrom:(NSInteger)value;
- (NSInteger)recurrence;
- (NSInteger)recurrenceFrom;

@end

