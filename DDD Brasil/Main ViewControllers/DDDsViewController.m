//
//  DDDsViewController.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 11/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "DDDsViewController.h"
#import "DDDDetailViewController.h"
#import "DDD.h"
#import "UITableViewCellStyled.h"

@implementation DDDsViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Voltar" 
																   style:UIBarButtonItemStyleBordered 
																  target:nil 
																  action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"fetchedResultsController ERROR");
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
		self.fetchedResultsController = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Códigos DDD";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DDDsViewCell";
    
    UITableViewCellStyled *cell = (UITableViewCellStyled *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCellStyled alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	DDD *ddd =  [fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = @"Código de Área: ";
	cell.detailTextLabel.text = ddd.numeroDDD;
	cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:18];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	DDDDetailViewController *detailViewController = [[DDDDetailViewController alloc] initWithNibName:@"DDDDetailView" 
																							  bundle:nil];
	DDD *selectedDDD = (DDD *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
	detailViewController.managedObjectContext = self.managedObjectContext;
	detailViewController.nroDDD = selectedDDD.numeroDDD;
	detailViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DDD" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSArray *sortDescriptors = nil;
	NSString *sectionNameKeyPath = nil;
	
	sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"numeroDDD" ascending:YES] autorelease]];
	sectionNameKeyPath = nil;
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:managedObjectContext 
																								  sectionNameKeyPath:sectionNameKeyPath 
																										   cacheName:@"DDDCache"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	return fetchedResultsController;
}

@end

