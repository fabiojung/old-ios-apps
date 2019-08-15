//
//  RecurrenceViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 02/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "RecurrenceViewController.h"

@implementation RecurrenceViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = NSLocalizedString(@"RepeatTitle_Loc", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.sectionHeaderHeight = 40;
	
	NSArray *array1 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"DueDate_Loc", nil),
													   NSLocalizedString(@"DoneDate_Loc", nil), nil];
		
    NSArray *array2 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"None_Loc", nil),
													   NSLocalizedString(@"Daily_Loc", nil),
													   NSLocalizedString(@"Weekly_Loc", nil),
													   NSLocalizedString(@"Monthly_Loc", nil),
													   NSLocalizedString(@"3Months_Loc", nil),
													   NSLocalizedString(@"6Months_Loc", nil),
													   NSLocalizedString(@"Yearly_Loc", nil), nil];
	
	frequencyArray = [[NSMutableArray alloc] initWithObjects:array1, array2, nil];
	[array1 release];
	[array2 release];
}

#pragma mark Table view methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)] autorelease];
	header.backgroundColor = [UIColor clearColor];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, 290.0, 25.0)];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = UITextAlignmentLeft;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(-1, -1);
	
	if (section == 0) 
		label.text = NSLocalizedString(@"RepeatFrom_Loc", nil);
	else 
		label.text = NSLocalizedString(@"RepeatFreq_Loc", nil);
	
	[header addSubview:label];
	[label release];
	
	return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[frequencyArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RepeatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = [[frequencyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (indexPath.section == 0) {
		if ([self.delegate recurrenceFrom] == indexPath.row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor blackColor];
		}
	} else if (indexPath.section == 1) {
		if ([self.delegate recurrence] == indexPath.row) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor blackColor];
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath	animated:YES];
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = 0;
	
	if (section == 0) {
		if ([self.delegate recurrenceFrom] == row) return;
		oldRow = [self.delegate recurrenceFrom];
		[self.delegate updateTaskWithRecurrenceFrom:row];
	} else if (section == 1) {
		if ([self.delegate recurrence] == row) return;
		oldRow = [self.delegate recurrence];
		[self.delegate updateTaskWithRecurrence:row];
	}
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:indexPath.section];
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
    }
	
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		oldCell.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)dealloc {
	frequencyArray = nil;
	[frequencyArray release];
    [super dealloc];
}

@end

