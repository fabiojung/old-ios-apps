//
//  CategoryViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 25/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "CategoryViewController.h"
#import "TarefasAppDelegate.h"
#import "Category.h"

@implementation CategoryViewController

@synthesize fetchedResultsController, managedObjectContext, delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	TarefasAppDelegate *appDelegate = (TarefasAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"fetchedResultsController ERROR");
	}
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	fetchedResultsController = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Category *category = [fetchedResultsController objectAtIndexPath:indexPath];
	
	if (indexPath.row == 0) {
		cell.textLabel.text = NSLocalizedString(category.categoryName, nil);
		cell.imageView.image = [UIImage imageNamed:@"home.png"];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = NSLocalizedString(category.categoryName, nil);
		cell.imageView.image = [UIImage imageNamed:@"work.png"];
	} else if (indexPath.row == 2) {
		cell.textLabel.text = NSLocalizedString(category.categoryName, nil);
		cell.imageView.image = [UIImage imageNamed:@"users.png"];
	} else {
		cell.textLabel.text = category.categoryName;
		cell.imageView.image = [UIImage imageNamed:@"UserList.png"];
	}
	if ([self.delegate categoryOrder] == indexPath.row) {
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
	NSUInteger oldRow;
	
	if ([self.delegate categoryOrder] == row) return;
	oldRow = [self.delegate categoryOrder];
	
	Category *category = [fetchedResultsController objectAtIndexPath:indexPath];
	
	[self.delegate updateTaskWithCategory:category];
	
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
	
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

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
	NSArray *sortDescriptors = nil;
	NSString *sectionNameKeyPath = nil;
	sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES] autorelease]];
	sectionNameKeyPath = nil;
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:managedObjectContext 
																								  sectionNameKeyPath:sectionNameKeyPath 
																										   cacheName:@"CategoryCache"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	return fetchedResultsController;
}

@end

