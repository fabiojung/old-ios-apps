//
//  ConfigViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 21/12/08.
//  Copyright 2008 iTouchFactory. All rights reserved.
//

#import "ConfigViewController.h"
#import "BadgeViewController.h"
#import "StringsHelper.h"
#import "BaseView.h"
#import "Constants.h"

@interface ConfigViewController (Private)
- (void)dismiss;
- (void)swDeleteChange:(id)sender;
- (void)swBadgeChange:(id)sender;
- (void)swBadgeDoneChange:(id)sender;
- (void)badgeView;
@end

@implementation ConfigViewController

- (id)init {
	if (self = [super init]) {
		[self setTitle:NSLocalizedString(@"Config_Loc", nil)];
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back_Loc", nil)
																	   style:UIBarButtonItemStyleBordered 
																	  target:self
																	  action:@selector(dismiss)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];		
		
	}
	return self;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	myTableView.delegate = nil;
		//emailField.delegate = nil;
}

- (void)dealloc {
	[super dealloc];
}

- (void)loadView {
	BaseView *contentView = [[BaseView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 00.0, 320.0, 460.0) style:UITableViewStyleGrouped];
	
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[myTableView setScrollEnabled:NO];
	myTableView.sectionHeaderHeight = 40;
	[myTableView setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:myTableView];
	[myTableView release];
	
	self.view = contentView;
	[contentView release];
}

- (void)viewWillAppear:(BOOL)animated {
	[myTableView reloadData];
	[super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
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
	
	switch (section) {
		case 0:
			label.text = @"Email";
			break;
		case 1:
			label.text = NSLocalizedString(@"AutoDel_Loc", nil);
			break;
		case 2:
			label.text = NSLocalizedString(@"Badge_Loc", nil);
			break;
		default:
			label.text = @"";
			break;
	}
	[header addSubview:label];
	[label release];
	
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
	static NSString *CellIdentifier = @"ConfigCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section == 0 || indexPath.section == 1) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		} else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}

		if (indexPath.section == 0) {
			emailField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 12.0, 280.0, 22.0)];
			[emailField setEnabled:NO];
			[emailField setDelegate:self];
			[emailField setPlaceholder:NSLocalizedString(@"NoEmailConfig_Loc", nil)];
			[emailField setKeyboardType:UIKeyboardTypeEmailAddress];
			[emailField setReturnKeyType:UIReturnKeyDone];
			[emailField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
			[emailField setTag:EMAIL_CELL_TAG];
			[emailField setFont:[UIFont systemFontOfSize:18]];
			[emailField setTextColor:[UIColor blackColor]];
			[emailField setBackgroundColor:[UIColor whiteColor]];
			[emailField setAdjustsFontSizeToFitWidth:YES];
			[emailField setTextAlignment:UITextAlignmentCenter];
			[emailField setOpaque:YES];
			[cell.contentView addSubview:emailField];
			[emailField release];
		} else if (indexPath.section == 1) {
			cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 4.0, 170.0, 35.0)];
			[cellLabel setTag:CELL_LABEL_TAG];
			[cellLabel setFont:[UIFont systemFontOfSize:12]];
			[cellLabel setTextColor:[UIColor blackColor]];
			[cellLabel setTextAlignment:UITextAlignmentCenter];
			[cellLabel setNumberOfLines:2];
			[cellLabel setBackgroundColor:[UIColor whiteColor]];
			[cellLabel setOpaque:YES];
			[cell.contentView addSubview:cellLabel];
			[cellLabel release];
			
			switchDelete = [[UISwitch alloc] initWithFrame:CGRectMake(200.0, 8.0, 0.0, 0.0)];
			[switchDelete setTag:SW_DELETE_TAG];
			[cell.contentView addSubview:switchDelete];
			[switchDelete release];
		}
		
	} else {
		if (indexPath.section == 0)
			emailField = (UITextField *)[cell.contentView viewWithTag:EMAIL_CELL_TAG];
		else if (indexPath.section == 1)
			cellLabel = (UILabel *)[cell.contentView viewWithTag:CELL_LABEL_TAG];
			switchDelete = (UISwitch *)[cell.contentView viewWithTag:SW_DELETE_TAG];
	}
 
	
	if (indexPath.section == 0) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] length] > 0) 
			emailField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
	} 
	else if (indexPath.section == 1) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		BOOL status = [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoDeleteTasks"] boolValue];
		cellLabel.text = NSLocalizedString(@"AutoDelete_Loc", nil);
		if (status) [switchDelete setOn:YES animated:YES];
		[switchDelete addTarget:self action:@selector(swDeleteChange:) forControlEvents:UIControlEventValueChanged];
	}
	else if (indexPath.section == 2) {
		NSUInteger badgeIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"iconBadge"] intValue];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = NSLocalizedString(@"Show_Loc", nil);
		cell.detailTextLabel.text = [StringsHelper iconBadgeTypeString:badgeIndex];
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
	}
	else if (indexPath.section == 3) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.text = NSLocalizedString(@"version_Loc", nil);
		cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	}
		
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[emailField setPlaceholder:@""];
		[emailField setEnabled:YES];
		[emailField becomeFirstResponder];
	}
	if (indexPath.section == 2) {
		[self badgeView]; 
	}
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return indexPath;
	if (indexPath.section == 2) return indexPath;
	return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (emailField.text.length == 0) 
		[emailField setPlaceholder:NSLocalizedString(@"NoEmailConfig_Loc", nil)];
	else 
		[[NSUserDefaults standardUserDefaults] setValue:emailField.text forKey:@"email"];
	[emailField setEnabled:NO];
	[emailField resignFirstResponder];
	return YES;
}

- (void)dismiss {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)swDeleteChange:(id)sender {
	if ([sender isOn]) 
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoDeleteTasks"];
	else 
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoDeleteTasks"];
}

- (void)badgeView {
	BadgeViewController *controller = [[BadgeViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end
