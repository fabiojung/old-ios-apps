//
//  RootViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import "Health.h"
#import "Event.h"
#import "Weight.h"
#import "CheckOSVersion.h"

@implementation RootViewController

@synthesize pks, names, photos;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.navigationItem.title = @"PetsCare";
		
		UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					target:self 
																					action:@selector(addNew)];
		self.navigationItem.rightBarButtonItem = tempButton;
		[tempButton release];
		
		self.navigationItem.leftBarButtonItem = self.editButtonItem;

		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release];
    }
    return self;
}

- (void)dealloc {
	[pks release];
	[names release];
	[photos release];
	[super dealloc];
}

- (void)refreshData {
	NSArray *array = [Pet pairedArraysForProperties:[NSArray arrayWithObjects:@"name", @"photo", nil] withCriteria:@""];
	self.pks = [array objectAtIndex:0];
	self.names = [array objectAtIndex:1];
	self.photos = [array objectAtIndex:2];
}

- (void)viewWillAppear:(BOOL)animated {
	[self refreshData];
	[self.tableView reloadData];
}

- (void)setEditable:(BOOL)editable {
    self.navigationItem.leftBarButtonItem.enabled = editable;
    self.navigationItem.rightBarButtonItem.enabled = editable;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:YES];
	if(editing) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return NSLocalizedString(@"MyPets", nil); 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [pks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RootViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if ([CheckOSVersion isNewOS]) {
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.textLabel.text = [names objectAtIndex:indexPath.row];
		
		if ([[photos objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) { 
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noPhoto" ofType:@"png"]];
			
		} else {
			cell.imageView.image = [photos objectAtIndex:indexPath.row];
		}	
	} else {
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.text = [names objectAtIndex:indexPath.row];
		
		if ([[photos objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) { 
			cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noPhoto" ofType:@"png"]];
			
		} else {
			cell.image = [photos objectAtIndex:indexPath.row];
		}		
	}

	return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSInteger primKey = [[pks objectAtIndex:indexPath.row] intValue];
	DetailViewController *controller = [[DetailViewController alloc] initWithPrimaryKey:primKey];
	[controller setEditing:NO animated:YES];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		NSInteger primKey = [[pks objectAtIndex:indexPath.row] intValue];
		NSArray *array = [[Health pairedArraysForProperties:nil withCriteria:@"WHERE petpk = '%d';", primKey] objectAtIndex:0];
		if ([array count] > 0) {
			for (NSNumber *petpk in array) {
				[Health deleteObject:[petpk intValue] cascade:NO];
			}
		}
		
		array = [[Event pairedArraysForProperties:nil withCriteria:@"WHERE petpk = '%d';", primKey] objectAtIndex:0];
		if ([array count] > 0) {
			for (NSNumber *petpk in array) {
				[Event deleteObject:[petpk intValue] cascade:NO];
			}
		}
		
		array = [[Weight pairedArraysForProperties:nil withCriteria:@"WHERE petpk = '%d';", primKey] objectAtIndex:0];
		if ([array count] > 0) {
			for (NSNumber *petpk in array) {
				[Weight deleteObject:[petpk intValue] cascade:NO];
			}
		}
		
		array = nil;
		[array release];
		
		[Pet deleteObject:primKey cascade:NO];
		[self refreshData];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		[self.tableView reloadData];
    }
}

- (void)addNew {
	AddViewController *controller = [[AddViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; 
}

@end

