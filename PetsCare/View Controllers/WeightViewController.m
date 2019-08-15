//
//  WeightViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 26/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "WeightViewController.h"
#import "PetsCareAppDelegate.h"
#import "Weight.h"
#import "AddWeightViewController.h"
#import "WeightGraphView.h"
#import "DateHelper.h"

#define UP_TAB_TAG		111
#define DOWN_TAB_TAG	222

@interface WeightViewController ()
- (void)addNew;
- (void)presentSheet;
- (void)deleteWeight:(NSInteger)index;
- (void)editWeight:(NSInteger)index;
- (void)setWeightUnit:(NSNumber *)value;
- (void)loadGraphicView;
- (void)updateArrayWith:(NSInteger)tabBarIndex;
- (void)showMessage;
@end

@implementation WeightViewController

@synthesize petName, petPk, tempArray;

- (id)init {
	if (self = [super init]) {
		self.editing = YES;
		[self setTitle:NSLocalizedString(@"Growth", nil)];
		UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					target:self 
																					action:@selector(addNew)];
		self.navigationItem.rightBarButtonItem = tempButton;
		[tempButton release];
		PetsCareAppDelegate *delegate = [[UIApplication sharedApplication] delegate]; 
		[self setWeightUnit:delegate.weightUnit];
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
					   [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"Table", nil)] autorelease],
					   [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"Graphic", nil)] autorelease],
					   nil];
	
	tabBar.selectedTabIndex = 0;
	tabBar.tag = UP_TAB_TAG;
	[contentView addSubview:tabBar];
	[tabBar release];
	
	bottonBar = [[TTTabStrip alloc] initWithFrame:CGRectMake(0, 375, 320, 41)];
	bottonBar.delegate = self;
	bottonBar.contentMode = UIViewContentModeScaleToFill;
	bottonBar.tabItems = [NSArray arrayWithObjects:
						  [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"by Date", nil)] autorelease],
						  [[[TTTabItem alloc] initWithTitle:NSLocalizedString(@"by Weight", nil)] autorelease],
						  nil];
	
	bottonBar.selectedTabIndex = 0;
	bottonBar.tag = DOWN_TAB_TAG;
	[contentView addSubview:bottonBar];
	[bottonBar release];
	
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 335.0) style:UITableViewStyleGrouped];
	[myTableView setBackgroundColor:TTSTYLEVAR(tabTintColor)];
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[contentView addSubview:myTableView];
	[myTableView release];
	
	graphView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 373.0)];
	graphView.backgroundColor = TTSTYLEVAR(tabTintColor);
	graphView.alpha = 0.0;
	[contentView addSubview:graphView];
	[graphView release]; 
}

- (void)viewWillAppear:(BOOL)animated {
	[self updateArrayWith:bottonBar.selectedTabIndex];
	if (tabBar.selectedTabIndex == 1) [self loadGraphicView];
	[super viewWillAppear:animated];
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"units_message"]) {
		[[NSUserDefaults standardUserDefaults] setValue:@"Ok" forKey:@"units_message"];
		[self showMessage];
	}
}

- (void)showMessage {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnitTitle", nil)
														message:NSLocalizedString(@"UnitMessage", nil)
													   delegate:self
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)tabBar:(TTTabBar*)aTabBar tabSelected:(NSInteger)selectedIndex {
	if ([aTabBar tag] == UP_TAB_TAG) {
		if (selectedIndex == 0) {
			graphView.alpha = 0.0;
			bottonBar.hidden = NO;
		}
		else if (selectedIndex == 1) {
			bottonBar.hidden = YES;
			[self loadGraphicView];
		}
	}
	if ([aTabBar tag] == DOWN_TAB_TAG) {
		[self updateArrayWith:bottonBar.selectedTabIndex];
	}
}

- (void)updateArrayWith:(NSInteger)tabBarIndex {
	self.tempArray = nil;
	if (tabBarIndex == 0) {
		self.tempArray = (NSMutableArray *)[Weight findByCriteria:@"WHERE petpk = '%d' ORDER BY date DESC;", self.petPk];
	} else if (tabBarIndex == 1) {
		self.tempArray = (NSMutableArray *)[Weight findByCriteria:@"WHERE petpk = '%d' ORDER BY weight DESC;", self.petPk];
	}
	[myTableView reloadData];
}

- (void)loadGraphicView {
	WeightGraphView *graphic = [[[WeightGraphView alloc] initWithFrame:CGRectMake(0, 80, 320, 200)] autorelease];
	graphic.weights = (NSMutableArray *)[Weight findByCriteria:@"WHERE petpk = '%d' ORDER BY date ASC;", self.petPk];
	graphic.petpk = self.petPk;
	graphic.weightUnit = unit;
	[graphView addSubview:graphic];
	graphView.alpha = 1.0;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tempArray count];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"WeightCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		labelW = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 8.0, 55.0, 30.0)] autorelease];
		[labelW setText:NSLocalizedString(@"Weight", nil)];
		[labelW setTextAlignment:UITextAlignmentLeft];
		[labelW setFont:[UIFont boldSystemFontOfSize:15]];
		[labelW setTextColor:[UIColor grayColor]];
		[labelW setBackgroundColor:[UIColor whiteColor]];
		[labelW setOpaque:YES];
		[labelW setTag:WEIGHT_LABELW_TAG];
		[cell.contentView addSubview:labelW];
		
		weightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(65.0, 8.0, 75.0, 30.0)] autorelease];
		[weightLabel setTextAlignment:UITextAlignmentCenter];
		[weightLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[weightLabel setTextColor:[UIColor blackColor]];
		[weightLabel setBackgroundColor:[UIColor whiteColor]];
		[weightLabel setOpaque:YES];
		[weightLabel setTag:WEIGHT_CELL_TAG];
		[cell.contentView addSubview:weightLabel];
		
		labelD = [[[UILabel alloc] initWithFrame:CGRectMake(160.0, 8.0, 35.0, 30.0)] autorelease];
		[labelD setText:NSLocalizedString(@"Date", nil)];
		[labelD setTextAlignment:UITextAlignmentLeft];
		[labelD setFont:[UIFont boldSystemFontOfSize:15]];
		[labelD setTextColor:[UIColor grayColor]];
		[labelD setBackgroundColor:[UIColor whiteColor]];
		[labelD setOpaque:YES];
		[labelD setTag:WEIGHT_LABELD_TAG];
		[cell.contentView addSubview:labelD];
		
		dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(195.0, 8.0, 100.0, 30.0)] autorelease];
		[dateLabel setTextAlignment:UITextAlignmentCenter];
		[dateLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[dateLabel setTextColor:[UIColor blackColor]];
		[dateLabel setBackgroundColor:[UIColor whiteColor]];
		[dateLabel setOpaque:YES];
		[dateLabel setTag:WEIGHT_DATE_TAG];
		[cell.contentView addSubview:dateLabel];
    } else {
		labelW = (UILabel *)[cell.contentView viewWithTag:WEIGHT_LABELW_TAG];
		weightLabel = (UILabel *)[cell.contentView viewWithTag:WEIGHT_CELL_TAG];
		labelD = (UILabel *)[cell.contentView viewWithTag:WEIGHT_LABELD_TAG];
		dateLabel = (UILabel *)[cell.contentView viewWithTag:WEIGHT_DATE_TAG];
	}
	Weight *weight = [self.tempArray objectAtIndex:indexPath.row];
	[weightLabel setText:[NSString stringWithFormat:@"%.2f %@", [[weight weight] doubleValue], unit]];
	[dateLabel setText:[DateHelper stringFromDate:weight.date withNames:NO]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedRow = indexPath.row;
	[self presentSheet];
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}

- (void)presentSheet {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil
													  delegate:self
											 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
										destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
											 otherButtonTitles:NSLocalizedString(@"Edit", nil), nil];
	menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[menu showInView:self.view];
	[menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self deleteWeight:selectedRow];
			break;
		case 1:
			[self editWeight:selectedRow];
			break;
		default:
			break;
	}
}

- (void)deleteWeight:(NSInteger)index {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	NSInteger pk = [[self.tempArray objectAtIndex:index] pk];
	[Weight deleteObject:pk cascade:NO];
	[tempArray removeObjectAtIndex:index];
	[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	[myTableView reloadData];
}

- (void)editWeight:(NSInteger)index {
	AddWeightViewController *editController = [[AddWeightViewController alloc] init];
	editController.selectedWeight = [tempArray objectAtIndex:index];
	editController.petPk = petPk;
	editController.petName = [NSString stringWithFormat:@"%@", petName];
	editController.navigationItem.title = NSLocalizedString(@"Edit",nil);
	[self.navigationController pushViewController:editController animated:YES];
	[editController release];
}

- (void)addNew {
	AddWeightViewController *addController = [[AddWeightViewController alloc] init];
	addController.selectedWeight = [[[Weight alloc] init] autorelease];
	addController.petPk = petPk;
	addController.petName = [NSString stringWithFormat:@"%@", petName];
	addController.unit = [NSString stringWithFormat:@"%@", unit];
	addController.navigationItem.title = NSLocalizedString(@"Add", nil);
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}

- (void)setWeightUnit:(NSNumber *)value {
	if ([value intValue] == 0) {
		unit = [NSString stringWithString:@"lbs"];
	} else if ([value intValue] == 1) {
		unit = [NSString stringWithString:@"oz"];
	} else if ([value intValue] == 2) {
		unit = [NSString stringWithString:@"kg"];
	} else if ([value intValue] == 3) {
		unit = [NSString stringWithString:@"g"];
	}
}

- (void)dealloc {
	myTableView.delegate = nil;
	myTableView.dataSource = nil;
	[unit release];
	[petName release];
	tempArray = nil;
	[tempArray release];
	[Weight clearCache];
    [super dealloc];
}

@end
