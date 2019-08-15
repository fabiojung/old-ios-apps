//
//  NotesViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 25/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesTextView.h"

@protocol NotesViewControllerDelegate;

@interface NotesViewController : UIViewController <UITextViewDelegate> {
	id <NotesViewControllerDelegate> delegate;
	NSString *currentNote;
	NotesTextView *notesTextView;
	CGRect tableViewFrame;
	NSUInteger numOfLines;
	BOOL keyboardShown;
	UIBarButtonItem *doneButton;
}

@property (assign) id<NotesViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *currentNote;

@end

@protocol NotesViewControllerDelegate <NSObject>
- (void)updateTaskWithNote:(NSString *)aNote;
@end
