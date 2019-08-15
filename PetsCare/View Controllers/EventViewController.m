//
//  EventViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "EventViewController.h"
#import "PetsCareAppDelegate.h"
#import "Event.h"
#import "AddEventViewController.h"
#import "RepeatEntry.h"
#import "DateHelper.h"
#import "CheckOSVersion.h"

#define KlabelDFrameDefault	CGRectMake(50.0, 30.0, 30.0, 20.0)
#define KlabelDFrameChanged	CGRectMake(50.0, 30.0, 80.0, 20.0)
#define KdateFrameDefault CGRectMake(85.0, 30.0, 80.0, 20.0)
#define KdateFrameChanged CGRectMake(115.0, 30.0, 80.0, 20.0)

@interface EventViewController ()
- (void)addNew;
- (void)presentSheet;
- (void)updateArrayWith:(NSInteger)tabBarIndex and:(NSInteger)bottonBarIndex;
- (void)deleteEvent:(NSInteger)index;
- (void)duplicateEvent:(NSInteger)index;
- (void)editEvent:(NSInteger)index;
- (void)changeStatusFromEvent:(id)sender;
- (void)checkLateEvents;
@end

@implementation EventViewController

@synthesize petName, petPk, tempArray;

- (id)init {
	if (self = [super init]) {
		self.editing = YES;
		[self setTitle:NSLocalizedString(@"Events", nil)];
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
	tabBar.tag = 3000;
	[contentView addSubview:tabBar];
	[tabBar release];
	
	bottonBar = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 375, 320, 41)];
	bottonBar.delegate = self;
	bottonBar.contentMode = UIViewContentModeScaleToFill;
	bottonBar.tabItems = [NSArray arrayWithObjects:
						  [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"by Date", nil)] autorelease],
						  [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"by Title", nil)] autorelease],
						  nil];
	
	bottonBar.selectedTabIndex = 0;
	bottonBar.tag = 3001;
	[contentView addSubview:bottonBar];
	[bottonBar release];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 335.0) style:UITableViewStyleGrouped];
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[myTableView setBackgroundColor:TTSTYLEVAR(tabTintColor)];
	[contentView addSubview:myTableView];
	[myTableView release];
}

- (void)tabBar:(TTTabBar*)aTabBar tabSelected:(NSInteger)selectedIndex {
	[self updateArrayWith:tabBar.selectedTabIndex and:bottonBar.selectedTabIndex];
}

- (void)dealloc {
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	[petName release];
	tempArray = nil;
	[tempArray release];
	[Event clearCache];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[self updateArrayWith:tabBar.selectedTabIndex and:bottonBar.selectedTabIndex];
	[super viewWillAppear:animated];
}

- (void)checkLateEvents {
	NSArray *array = [Event findByCriteria:@"WHERE petpk = '%d' AND isdone = '0' AND date < date('now');", self.petPk];
	for (Event *event in array) {
		event.islate = 1;
	}
	array = nil;
	array = [Event findByCriteria:@"WHERE petpk = '%d' AND date >= date('now');", self.petPk];
	for (Event *event in array) {
		event.islate = 0;
	}
	array = nil;
}

- (void)updateArrayWith:(NSInteger)tabBarIndex and:(NSInteger)bottonBarIndex {
	self.tempArray = nil;
	[self checkLateEvents];
	if (tabBarIndex == 0) {
		if (bottonBarIndex == 1) {
			self.tempArray = (NSMutableArray *)[Event findByCriteria:@"WHERE petpk = '%d' AND isdone = '0' ORDER BY event, date ASC;", self.petPk];
		} else if (bottonBarIndex == 0) {
			self.tempArray = (NSMutableArray *)[Event findByCriteria:@"WHERE petpk = '%d' AND isdone = '0' ORDER BY date ASC;", self.petPk];
		}
		
	} else if (tabBarIndex == 1) {
		if (bottonBarIndex == 1) {
			self.tempArray = (NSMutableArray *)[Event findByCriteria:@"WHERE petpk = '%d' AND isdone = '1' ORDER BY event, donedate ASC;", self.petPk];
		} else if (bottonBarIndex == 0) {
			self.tempArray = (NSMutableArray *)[Event findByCriteria:@"WHERE petpk = '%d' AND isdone = '1' ORDER BY donedate DESC;", self.petPk];
		}
	}
	[myTableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[myTableView setEditing:editing animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *header = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 40.0)] autorelease];
	header.textAlignment = UITextAlignmentCenter;
	header.font = [UIFont boldSystemFontOfSize:16.0];
	header.opaque = YES;
	header.textColor = [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.00];
	header.text = [NSString stringWithString:petName];
	header.backgroundColor = TTSTYLEVAR(tabTintColor);
	return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tempArray count];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"EventCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([CheckOSVersion isNewOS]) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		else 
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			
		labelEvent = [[[UILabel alloc] initWithFrame:CGRectMake(50.0, 8.0, 230.0, 20.0)] autorelease];
		[labelEvent setTextAlignment:UITextAlignmentLeft];
		[labelEvent setFont:[UIFont boldSystemFontOfSize:15]];
		[labelEvent setTextColor:[UIColor blackColor]];
		[labelEvent setBackgroundColor:[UIColor whiteColor]];
		[labelEvent setOpaque:YES];
		[labelEvent setTag:EVENT_LABEL_TAG];
		[cell.contentView addSubview:labelEvent];
		
		labelD = [[[UILabel alloc] initWithFrame:KlabelDFrameDefault] autorelease];
		[labelD setTextAlignment:UITextAlignmentLeft];
		[labelD setFont:[UIFont boldSystemFontOfSize:12]];
		[labelD setTextColor:[UIColor grayColor]];
		[labelD setBackgroundColor:[UIColor whiteColor]];
		[labelD setOpaque:YES];
		[labelD setTag:EVENT_LABEL_DATE_TAG];
		[cell.contentView addSubview:labelD];
		
		date = [[[UILabel alloc] initWithFrame:KdateFrameDefault] autorelease];
		[date setTextAlignment:UITextAlignmentLeft];
		[date setAdjustsFontSizeToFitWidth:YES];
		[date setFont:[UIFont systemFontOfSize:12]];
		[date setTextColor:[UIColor blackColor]];
		[date setBackgroundColor:[UIColor whiteColor]];
		[date setOpaque:YES];
		[date setTag:EVENT_DATE_TAG];
		[cell.contentView addSubview:date];
		
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
		labelEvent = (UILabel *)[cell.contentView viewWithTag:EVENT_LABEL_TAG];
		labelD = (UILabel *)[cell.contentView viewWithTag:EVENT_LABEL_DATE_TAG];
		date = (UILabel *)[cell.contentView viewWithTag:EVENT_DATE_TAG];
		isLate = (UILabel *)[cell.contentView viewWithTag:EVENT_ISLATE_TAG];
		repeatImage = (UIImageView *)[cell.contentView viewWithTag:REPEAT_IMAGE_TAG];
	}
	
	UIButton *checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
	checkBoxButton.frame = CGRectMake(5.0, 10.0, 40.0, 40.0);
	checkBoxButton.tag = indexPath.row;
	[checkBoxButton addTarget:self action:@selector(changeStatusFromEvent:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:checkBoxButton];	
	
	Event *event = [self.tempArray objectAtIndex:indexPath.row];
	
	[labelEvent setText:[event event]];
	
	if (tabBar.selectedTabIndex == 0) {
		labelD.frame = KlabelDFrameDefault;
		date.frame = KdateFrameDefault;
		[labelD setText:NSLocalizedString(@"Date", nil)];
		[date setText:[DateHelper stringFromDate:[event date] withNames:YES]];
	} else {
		if ([NSLocalizedString(@"Done", nil) isEqualToString:@"Concluído"]) {
			labelD.frame = KlabelDFrameChanged;
			date.frame = KdateFrameChanged;
		}
		[labelD setText:NSLocalizedString(@"Done", nil)];
		[date setText:[DateHelper stringFromDate:[event donedate] withNames:YES]];
	}
	
	
	if (event.isdone == 0) {
		if ([CheckOSVersion isNewOS]) 
			cell.imageView.image = [UIImage imageNamed:@"checkbox.png"];
		else 
			cell.image = [UIImage imageNamed:@"checkbox.png"];
		if (event.islate == 1) {
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
	
	if (event.kindrepeat > 0 && tabBar.selectedTabIndex == 0) {
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
	
	Event *event = [self.tempArray objectAtIndex:row];
	if (event.isdone == 0) {
		event.isdone = 1;
		event.islate = 0;
		event.donedate = [NSDate date];
		if (event.kindrepeat > 0 && event.repeatoff == 0) {
			RepeatEntry *carbon = [[RepeatEntry alloc] init];
			[carbon createRecurrentEventFor:event];
			[carbon release];
			event.repeatoff = 1;
			event.kindrepeat = 0;
		}
		[tempArray removeObjectAtIndex:row];
		[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	} else {
		event.isdone = 0;
		event.donedate = NULL;
		[tempArray removeObjectAtIndex:row];
		[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
	[event save];
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
			[self deleteEvent:selectedRow];
			break;
		case 1:
			[self editEvent:selectedRow];
			break;
		case 2:
			[self duplicateEvent:selectedRow];
			break;
	}
}

- (void)deleteEvent:(NSInteger)index {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	NSInteger pk = [[tempArray objectAtIndex:index] pk];
	[Event deleteObject:pk cascade:NO];
	[tempArray removeObjectAtIndex:index];
	[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	[myTableView reloadData];
}

- (void)editEvent:(NSInteger)index {
	AddEventViewController *editController = [[AddEventViewController alloc] init];
	editController.selectedEntry = [tempArray objectAtIndex:index];
	editController.petPk = petPk;
	editController.petName = [NSString stringWithFormat:@"%@", petName];
	editController.navigationItem.title = NSLocalizedString(@"Edit", nil);
	[self.navigationController pushViewController:editController animated:YES];
	[editController release];
}

- (void)duplicateEvent:(NSInteger)index {
	AddEventViewController *addController = [[AddEventViewController alloc] init];
	addController.selectedEntry = [[[Event alloc] init] autorelease];
	addController.selectedEntry.event = [NSString stringWithString:[[tempArray objectAtIndex:index] event]];
	addController.selectedEntry.kindrepeat = [[tempArray objectAtIndex:index] kindrepeat];
	addController.petPk = petPk;
	addController.petName = [NSString stringWithFormat:@"%@", petName];
	addController.navigationItem.title = NSLocalizedString(@"AddEvent", nil);
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}

- (void)addNew {
	AddEventViewController *addController = [[AddEventViewController alloc] init];
	addController.selectedEntry = [[[Event alloc] init] autorelease];
	addController.petPk = petPk;
	addController.petName = [NSString stringWithFormat:@"%@", petName];
	addController.navigationItem.title = NSLocalizedString(@"AddEvent", nil);
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}


@end
