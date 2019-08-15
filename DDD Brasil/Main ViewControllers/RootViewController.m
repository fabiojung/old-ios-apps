//
//  RootViewController.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 08/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "RootViewController.h"
#import "EstadoDetailViewController.h"
#import "Estado.h"

@implementation RootViewController

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
	return @"Estados";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EstadosViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Estado *estado =  [fetchedResultsController objectAtIndexPath:indexPath];
	
	NSString *imgName = [NSString stringWithFormat:@"%@.png", estado.siglaUF];
	
	cell.textLabel.text = estado.nomeUF;
	cell.imageView.image = [UIImage imageNamed:imgName];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	EstadoDetailViewController *detailViewController = [[EstadoDetailViewController alloc] initWithNibName:@"EstadoDetailView"
																									bundle:nil];
	Estado *selectedEstado = (Estado *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
	detailViewController.estado = selectedEstado;
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Estado" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSArray *sortDescriptors = nil;
	NSString *sectionNameKeyPath = nil;
	
	sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"nomeUF" ascending:YES] autorelease]];
	sectionNameKeyPath = nil;
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:managedObjectContext 
																								  sectionNameKeyPath:sectionNameKeyPath 
																										   cacheName:@"EstadosCache"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	return fetchedResultsController;
}

@end

