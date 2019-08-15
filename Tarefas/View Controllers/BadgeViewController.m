//
//  BadgeViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 08/09/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "BadgeViewController.h"
#import "StringsHelper.h"

@implementation BadgeViewController


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = NSLocalizedString(@"Badge_Loc", nil);
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.sectionHeaderHeight = 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

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
	label.text = NSLocalizedString(@"Show_Loc", nil);
	[header addSubview:label];
	[label release];
	
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BadgeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [StringsHelper iconBadgeTypeString:indexPath.row];
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"iconBadge"] intValue] == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f];
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath	animated:YES];
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = 0;
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"iconBadge"] intValue] == row)
		return;
	
	oldRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"iconBadge"] intValue];
	[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"iconBadge"];
	
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
    [super dealloc];
}

@end

