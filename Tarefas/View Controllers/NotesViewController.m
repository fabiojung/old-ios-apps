//
//  NotesViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 25/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "NotesViewController.h"

@implementation NotesViewController

@synthesize currentNote, delegate;

- (id)init {
    if (self = [super init]) {
		self.title = NSLocalizedString(@"Notes_Loc", nil);
		doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																   target:self 
																   action:@selector(resignTextView)];
    }
    return self;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification 
											   object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification 
											   object:nil];
}

- (void)resignTextView {
	[notesTextView setEditable:NO];
	[notesTextView resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)loadView {
	[self registerForKeyboardNotifications];
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"body" ofType:@"png"];
	UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:imagePath];

	background.image = bgImage;
	[bgImage release];
	
	[contentView addSubview:background];
	[background release];
	
	tableViewFrame = CGRectMake(0.0, 0.0, 320.0, 416.0);
	notesTextView = [[NotesTextView alloc] initWithFrame:tableViewFrame];
	notesTextView.delegate = self;
	notesTextView.backgroundColor = [UIColor clearColor];
	notesTextView.font = [UIFont fontWithName:@"Marker Felt" size:19];
	notesTextView.scrollEnabled = YES;
	notesTextView.clipsToBounds = YES;
	notesTextView.alwaysBounceVertical = YES;
	notesTextView.editable = NO;
	notesTextView.dataDetectorTypes = UIDataDetectorTypeAll;
	
	[contentView addSubview:notesTextView];
	[notesTextView	release];
	
	self.view = contentView;
	[contentView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (currentNote.length > 0) {
		notesTextView.text = currentNote;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.delegate updateTaskWithNote:notesTextView.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)unregisterForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardDidShowNotification 
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardDidHideNotification 
												  object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (keyboardShown)
        return;
	
    NSDictionary* info = [aNotification userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    tableViewFrame.size.height -= keyboardSize.height;
    notesTextView.frame = tableViewFrame;
	self.navigationItem.rightBarButtonItem = doneButton;
    keyboardShown = YES;
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    tableViewFrame.size.height += keyboardSize.height;
    notesTextView.frame = tableViewFrame;
    keyboardShown = NO;
}

- (void)dealloc {
	[self unregisterForKeyboardNotifications];
	[doneButton release];
	[currentNote release];
    [super dealloc];
}

@end
