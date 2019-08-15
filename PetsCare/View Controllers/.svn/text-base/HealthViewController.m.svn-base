//
//  HealthViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "HealthViewController.h"
#import "Health.h"
#import "AddHealthViewController.h"
#import "DateHelper.h"
#import "RepeatEntry.h"
#import "CheckOSVersion.h"

#define KlabelDFrameDefault	CGRectMake(50.0, 30.0, 30.0, 20.0)
#define KlabelDFrameChanged	CGRectMake(50.0, 30.0, 80.0, 20.0)
#define KdateFrameDefault CGRectMake(85.0, 30.0, 80.0, 20.0)
#define KdateFrameChanged CGRectMake(115.0, 30.0, 80.0, 20.0)

@interface HealthViewController ()
- (void)addNew;
- (void)presentSheet;
- (void)deleteEntry:(NSInteger)index;
- (void)editEntry:(NSInteger)index;
- (void)duplicateEntry:(NSInteger)index;
- (void)updateArrayWith:(NSInteger)tabBarIndex and:(NSInteger)bottonBarIndex;
- (void)changeStatusFromEvent:(id)sender;
- (void)checkLateEvents;
@end

@implementation HealthViewController

@synthesize petPk, tempArray, petName;

- (id)init {
	if (self = [super init]) {
		self.editing = YES;
		[self setTitle:NSLocalizedString(@"Health", nil)];
		UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					target:self 
																					action:@selector(addNew)];
		self.navigationItem.rightBarButtonItem = tempButton;
		[tempButton release];
		
	}
	return self;
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:TTSTYLEVAR(tabTintColor)];
	self.view = contentView;
	[contentView release];
	
	tabBar = [[TTTabBar alloc] initWithFrame:CGRectMake(0, -1, 320, 43)];
	tabBar.delegate = self;
	tabBar.contentMode = UIViewContentModeScaleToFill;
	tabBar.tabItems = [NSArray arrayWithObjects:
						 [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"Schedule", nil)] autorelease],
						 [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"Completed", nil)] autorelease],
						 nil];
	tabBar.selectedTabIndex = 0;
	
	[contentView addSubview:tabBar];
	[tabBar release];
	
	bottonBar = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 375, 320, 41)];
	bottonBar.delegate = self;
	bottonBar.contentMode = UIViewContentModeScaleToFill;
	bottonBar.tabItems = [NSArray arrayWithObjects:
						  [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"by Date", nil)] autorelease],
						  [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"by Type", nil)] autorelease],
						  nil];
	
	bottonBar.selectedTabIndex = 0;
	bottonBar.tag = 3002;
	[contentView addSubview:bottonBar];
	[bottonBar release];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 335.0) style:UITableViewStyleGrouped];
	[myTableView setBackgroundColor:TTSTYLEVAR(tabTintColor)];
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[contentView addSubview:myTableView];
	[myTableView release];
}

- (void)tabBar:(TTTabBar*)aTabBar tabSelected:(NSInteger)selectedIndex {
	[self updateArrayWith:tabBar.selectedTabIndex and:bottonBar.selectedTabIndex];
}

- (void)dealloc {
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	tempArray = nil;
	[tempArray release];
	[petName release];
	[Health clearCache];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[self updateArrayWith:tabBar.selectedTabIndex and:bottonBar.selectedTabIndex];
	[super viewWillAppear:animated];
}

- (void)checkLateEvents {
	NSArray *array = [Health findByCriteria:@"WHERE petpk = '%d' AND isdone = '0' AND date < date('now');", self.petPk];
	for (Health *health in array) {
		health.islate = 1;
	}
	array = nil;
	array = [Health findByCriteria:@"WHERE petpk = '%d' AND date >= date('now');", self.petPk];
	for (Health *health in array) {
		health.islate = 0;
	}
	array = nil;
}

- (void)updateArrayWith:(NSInteger)tabBarIndex and:(NSInteger)bottonBarIndex {
	self.tempArray = nil;
	[self checkLateEvents];
	if (tabBarIndex == 0) {
		if (bottonBarIndex == 1) {
			self.tempArray = (NSMutableArray *)[Health findByCriteria:@"WHERE petpk = '%d' AND isdone = '0' ORDER BY type, date ASC;", self.petPk];
		} else if (bottonBarIndex == 0) {
			self.tempArray = (NSMutableArray *)[Health findByCriteria:@"WHERE petpk = '%d' AND isdone = '0' ORDER BY date ASC;", self.petPk];
		}
		
	} else if (tabBarIndex == 1) {
		if (bottonBarIndex == 1) {
			self.tempArray = (NSMutableArray *)[Health findByCriteria:@"WHERE petpk = '%d' AND isdone = '1' ORDER BY type, donedate ASC;", self.petPk];
		} else if (bottonBarIndex == 0) {
			self.tempArray = (NSMutableArray *)[Health findByCriteria:@"WHERE petpk = '%d' AND isdone = '1' ORDER BY donedate DESC;", self.petPk];
		}
	}
	[myTableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[myTableView setEditing:editing animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tempArray count];	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *tableHeader = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 40.0)] autorelease];
	tableHeader.textAlignment = UITextAlignmentCenter;
	tableHeader.font = [UIFont boldSystemFontOfSize:16.0];
	tableHeader.opaque = YES;
	tableHeader.textColor = [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.00];
	tableHeader.text = [NSString stringWithString:petName];
	tableHeader.backgroundColor = TTSTYLEVAR(tabTintColor);
	return tableHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"HealthCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([CheckOSVersion isNewOS]) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		else 
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		header = [[[UILabel alloc] initWithFrame:CGRectMake(50.0, 5.0, 140.0, 20.0)] autorelease];
		[header setTextAlignment:UITextAlignmentLeft];
		[header setTextColor:[UIColor blackColor]];
		[header setFont:[UIFont boldSystemFontOfSize:15]];
		[header setBackgroundColor:[UIColor whiteColor]];
		[header setOpaque:YES];
		[header setTag:HEALTH_HEADER_TAG];
		[cell.contentView addSubview:header];
		
		desc = [[[UILabel alloc] initWithFrame:CGRectMake(195.0, 5.0, 100.0, 20.0)] autorelease];
		[desc setAdjustsFontSizeToFitWidth:YES];
		[desc setMinimumFontSize:12];
		[desc setTextAlignment:UITextAlignmentRight];
		[desc setFont:[UIFont systemFontOfSize:14]];
		[desc setBackgroundColor:[UIColor whiteColor]];
		[desc setOpaque:YES];
		[desc setTag:HEALTH_DESC_TAG];
		[cell.contentView addSubview:desc];
		
		dateLabel = [[[UILabel alloc] initWithFrame:KlabelDFrameDefault] autorelease];	
		[dateLabel setTextAlignment:UITextAlignmentLeft];
		[dateLabel setTextColor:[UIColor grayColor]];
		[dateLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[dateLabel setBackgroundColor:[UIColor whiteColor]];
		[dateLabel setOpaque:YES];
		[dateLabel setTag:HEALTH_DATELABEL_TAG];
		[cell.contentView addSubview:dateLabel];
		
		dateValue = [[[UILabel alloc] initWithFrame:KdateFrameDefault] autorelease];	
		[dateValue setTextAlignment:UITextAlignmentLeft];
		[dateValue setAdjustsFontSizeToFitWidth:YES];
		[dateValue setFont:[UIFont systemFontOfSize:12]];
		[dateValue setBackgroundColor:[UIColor whiteColor]];
		[dateValue setOpaque:YES];
		[dateValue setTag:HEALTH_DATEVALUE_TAG];
		[cell.contentView addSubview:dateValue];
		
		isLate = [[[UILabel alloc] initWithFrame:CGRectMake(230.0, 30.0, 60.0, 20.0)] autorelease];
		[isLate setTextAlignment:UITextAlignmentRight];
		[isLate setText:NSLocalizedString(@"Late", nil)];
		[isLate setFont:[UIFont boldSystemFontOfSize:12]];
		[isLate setTextColor:[UIColor redColor]];
		[isLate setBackgroundColor:[UIColor whiteColor]];
		[isLate setOpaque:YES];
		[isLate setTag:EVENT_ISLATE_TAG];
		[cell.contentView addSubview:isLate];
		
		repeatImage = [[[UIImageView alloc] initWithFrame:CGRectMake(175.0, 30.0, 16.0, 16.0)] autorelease];
		repeatImage.tag = REPEAT_IMAGE_TAG;
		repeatImage.opaque = YES;
		[cell.contentView addSubview:repeatImage];
		
    } else {
		header =	(UILabel *)[cell.contentView viewWithTag:HEALTH_HEADER_TAG];
		desc =		(UILabel *)[cell.contentView viewWithTag:HEALTH_DESC_TAG];
		dateLabel = (UILabel *)[cell.contentView viewWithTag:HEALTH_DATELABEL_TAG];
		dateValue = (UILabel *)[cell.contentView viewWithTag:HEALTH_DATEVALUE_TAG];
		isLate = (UILabel *)[cell.contentView viewWithTag:EVENT_ISLATE_TAG];
		repeatImage = (UIImageView *)[cell.contentView viewWithTag:REPEAT_IMAGE_TAG];
	}
	
	UIButton *checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
	checkBoxButton.frame = CGRectMake(5.0, 10.0, 40.0, 40.0);
	checkBoxButton.tag = indexPath.row;
	[checkBoxButton addTarget:self action:@selector(changeStatusFromEvent:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:checkBoxButton];
	Health *health = [self.tempArray objectAtIndex:indexPath.row];
	[header setText:[health type]];
	[desc setText:[health infotag]];
	
	if (tabBar.selectedTabIndex == 0) {
		dateLabel.frame = KlabelDFrameDefault;
		dateValue.frame = KdateFrameDefault;
		[dateLabel setText:NSLocalizedString(@"Date", nil)];
		[dateValue setText:[DateHelper stringFromDate:[health date] withNames:YES]];
	} else {
		if ([NSLocalizedString(@"Done", nil) isEqualToString:@"Concluído"]) {
			dateLabel.frame = KlabelDFrameChanged;
			dateValue.frame = KdateFrameChanged;
		}
		[dateLabel setText:NSLocalizedString(@"Done", nil)];
		[dateValue setText:[DateHelper stringFromDate:[health donedate] withNames:YES]];
	}
	
	if (health.isdone == 0) {
		if ([CheckOSVersion isNewOS]) 
			cell.imageView.image = [UIImage imageNamed:@"checkbox.png"];
		else 
			cell.image = [UIImage imageNamed:@"checkbox.png"];
		if (health.islate == 1) {
			isLate.hidden = NO;
		} else {
			isLate.hidden = YES;
		}
	} else {
		isLate.hidden = YES;
		if ([CheckOSVersion isNewOS]) 
			cell.imageView.image = [UIImage imageNamed:@"checkedbox.png"];
		else 
			cell.image = [UIImage imageNamed:@"checkedbox.png"];
	}
	if (health.kindrepeat > 0 && tabBar.selectedTabIndex == 0) {
		repeatImage.image = [UIImage imageNamed:@"repeat.png"];
	} else {
		repeatImage.image = nil;
	}	
		
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedRow = indexPath.row;
	[self presentSheet];
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}

- (void)changeStatusFromEvent:(id)sender {
	NSInteger row = [sender tag];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
	
	Health *health = [self.tempArray objectAtIndex:row];
	if (health.isdone == 0) {
		health.isdone = 1;
		health.islate = 0;
		health.donedate = [NSDate date];
		if (health.kindrepeat > 0 && health.repeatoff == 0) {
			RepeatEntry *carbon = [[RepeatEntry alloc] init];
			[carbon createRecurrentHealthFor:health];
			[carbon release];
			health.repeatoff = 1;
		}
		[tempArray removeObjectAtIndex:row];
		[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	} else {
		health.isdone = 0;
		health.donedate = NULL;
		[tempArray removeObjectAtIndex:row];
		[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
	[health save];
	[self updateArrayWith:tabBar.selectedTabIndex and:bottonBar.selectedTabIndex];
}

- (void)presentSheet {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil
													  delegate:self
											 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
										destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
											 otherButtonTitles:NSLocalizedString(@"Edit", nil),
															   NSLocalizedString(@"Duplicate", nil), nil];
	menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[menu showInView:self.view];
	[menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self deleteEntry:selectedRow];
			break;
		case 1:
			[self editEntry:selectedRow];
			break;
		case 2:
			[self duplicateEntry:selectedRow];
			break;
	}
}

- (void)deleteEntry:(NSInteger)index {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	NSInteger pk = [[tempArray objectAtIndex:index] pk];
	[Health deleteObject:pk cascade:NO];
	[tempArray removeObjectAtIndex:index];
	[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	[myTableView reloadData];
}

- (void)duplicateEntry:(NSInteger)index {
	AddHealthViewController *addController = [[AddHealthViewController alloc] init];
	addController.selectedEntry = [[[Health alloc] init] autorelease];
	addController.selectedEntry.type = [NSString stringWithString:[[tempArray objectAtIndex:index] type]];
	addController.selectedEntry.infotag = [NSString stringWithString:[[tempArray objectAtIndex:index] infotag]];
	addController.selectedEntry.kindrepeat = [[tempArray objectAtIndex:index] kindrepeat];
	addController.petPk = petPk;
	addController.navigationItem.title = NSLocalizedString(@"Add", nil);
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}

- (void)editEntry:(NSInteger)index {
	AddHealthViewController *editController = [[AddHealthViewController alloc] init];
	editController.selectedEntry = [tempArray objectAtIndex:index];
	editController.petPk = petPk;
	editController.navigationItem.title = NSLocalizedString(@"Edit", nil);
	[self.navigationController pushViewController:editController animated:YES];
	[editController release];
}

- (void)addNew {
	AddHealthViewController *addController = [[AddHealthViewController alloc] init];
	addController.selectedEntry = [[[Health alloc] init] autorelease];
	addController.petPk = petPk;
	addController.navigationItem.title = NSLocalizedString(@"Add", nil);
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}


@end
