//
//  DateViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 25/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewControllerDelegate;

@interface DateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSDate *dueDate;
	UITableView *dateTableView;
	UIDatePicker *datePicker;
	id <DateViewControllerDelegate> delegate;

}

@property (nonatomic, retain) NSDate *dueDate;
@property (nonatomic, assign) id <DateViewControllerDelegate> delegate;

@end

@protocol DateViewControllerDelegate <NSObject>
- (void)dateViewControllerEndWithDate:(NSDate *)aDate;
@end