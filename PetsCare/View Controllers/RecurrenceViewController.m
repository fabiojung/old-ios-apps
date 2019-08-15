//
//  RecurrenceViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 02/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "RecurrenceViewController.h"
#import "CheckOSVersion.h"

@implementation RecurrenceViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = NSLocalizedString(@"Repeats", nil);
		self.navigationItem.hidesBackButton = YES;
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																					target:self 
																					action:@selector(dismiss)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
    }
    return self;
}

- (void)dismiss {
	[self.delegate dismissRecurrenceViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    frequencyArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"None", nil),
													  NSLocalizedString(@"Daily", nil),
													  NSLocalizedString(@"Weekly", nil),
													  NSLocalizedString(@"Monthly", nil),
													  NSLocalizedString(@"Every Three Months", nil),
													  NSLocalizedString(@"Every Six Months", nil),
													  NSLocalizedString(@"Yearly", nil), nil];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return NSLocalizedString(@"Repeating Frequency", nil);
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [frequencyArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([CheckOSVersion isNewOS]) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		else 
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([CheckOSVersion isNewOS]) {
		cell.textLabel.text = [frequencyArray objectAtIndex:indexPath.row];
		if ([self.delegate repeatType] == indexPath.row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor blackColor];
		}
	} else {
		cell.text = [frequencyArray objectAtIndex:indexPath.row];
		if ([self.delegate repeatType] == indexPath.row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textColor = [UIColor blackColor];
		}
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
	[self.delegate updateEntryWith:indexPath.row];
	for (NSIndexPath *visibleIndexPath in [tableView indexPathsForVisibleRows])
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:visibleIndexPath];
		NSUInteger visibleRow = [visibleIndexPath row];
		if (visibleRow == row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			if ([CheckOSVersion isNewOS]) 
				cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
			else
				cell.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			if ([CheckOSVersion isNewOS]) 
				cell.textLabel.textColor = [UIColor blackColor];
			else
				cell.textColor = [UIColor blackColor];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath	animated:YES];
}

- (void)dealloc {
	[frequencyArray release];
    [super dealloc];
}

@end

