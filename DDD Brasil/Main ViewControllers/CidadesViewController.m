//
//  CidadesViewController.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 11/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//
#import <CoreFoundation/CFString.h>
#import "CidadesViewController.h"
#import "CidadeDetailViewController.h"
#import "Cidade.h"
#import "Estado.h"
#import "DDD.h"

@implementation CidadesViewController

@synthesize fetchedResultsController;
@synthesize filteredResultsController;
@synthesize managedObjectContext;
@synthesize searchPredicate;
@synthesize indexTitles;

- (void)performPreFetch {
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"fetchedResultsController ERROR");
	}
	[self.tableView reloadData];
}

- (void)dealloc {
	[indexTitles release];
	[searchPredicate release];
	[fetchedResultsController release];
	[filteredResultsController release];
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
	
	self.searchPredicate = [NSPredicate predicateWithFormat:@"nomeCidadeBusca >= $lowBound and nomeCidadeBusca < $highBound"];
	
	
	
	if (fetchedResultsController == nil)
		[self performPreFetch];

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
	self.filteredResultsController = nil;
}

- (NSArray *)lettersForSections {
	if (indexTitles != nil) {
		return indexTitles;
	}
	indexTitles = [[NSMutableArray alloc] init];
	[indexTitles addObject:UITableViewIndexSearch];
	
	for (id object in [fetchedResultsController sectionIndexTitles]) {
		[indexTitles addObject:object];
	}
	
	return indexTitles;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [[filteredResultsController sections] count];
	} else {
		return [[fetchedResultsController sections] count];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo;
	if (tableView == self.searchDisplayController.searchResultsTableView)
		sectionInfo = [[filteredResultsController sections] objectAtIndex:section];
	else 
		sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	
	return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (self.searchDisplayController.active) 
		return nil;
	else
		return [[[fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return nil;
	else
		return [self lettersForSections];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.searchDisplayController.searchResultsTableView)
		return 0;
	else {
		if (index == 0) {
			[tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
			return -1;
		}
		return index - 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CidadesViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Cidade *cidade =  nil;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
		cidade =  [filteredResultsController objectAtIndexPath:indexPath];
	else 
		cidade =  [fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", cidade.nomeCidade, cidade.estado.siglaUF];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CidadeDetailViewController *detailViewController = [[CidadeDetailViewController alloc] initWithNibName:@"CidadeDetailView" bundle:nil];
	
	Cidade *selectedCidade; 
	if (tableView == self.searchDisplayController.searchResultsTableView)
		selectedCidade =  (Cidade *)[filteredResultsController objectAtIndexPath:indexPath];
	else 
		selectedCidade = (Cidade *)[fetchedResultsController objectAtIndexPath:indexPath];
	
	detailViewController.cidade = selectedCidade;
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cidade" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSArray *sortDescriptors = nil;
	NSString *sectionNameKeyPath = nil;
	
	sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"nomeCidadeBusca" ascending:YES] autorelease]];
	sectionNameKeyPath = @"nomeSection";
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:managedObjectContext 
																								  sectionNameKeyPath:sectionNameKeyPath 
																										   cacheName:@"CidadesCache"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	return fetchedResultsController;
}

- (NSFetchedResultsController *)filteredResultsController {
    
    if (filteredResultsController != nil) {
        return filteredResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cidade" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
	
	NSArray *sortDescriptors = nil;
	NSString *sectionNameKeyPath = nil;
	
	
	sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"nomeCidadeBusca" ascending:YES] autorelease]];
	sectionNameKeyPath = nil;
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:managedObjectContext 
																								  sectionNameKeyPath:sectionNameKeyPath 
																										   cacheName:@"SearchCache"];
	self.filteredResultsController = aFetchedResultsController;
	filteredResultsController.delegate = self;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	return filteredResultsController;
}

#pragma mark -
#pragma mark Content Filtering

+ (NSString *)normalizeString:(NSString *)unprocessedValue {
	
    if (!unprocessedValue) return nil;
    
    NSMutableString *result = [NSMutableString stringWithString:unprocessedValue];
    
    CFStringNormalize((CFMutableStringRef)result, kCFStringNormalizationFormD);
    CFStringFold((CFMutableStringRef)result, kCFCompareCaseInsensitive | kCFCompareDiacriticInsensitive | kCFCompareWidthInsensitive, NULL);
	
    return result;
}

+ (NSString *)upperBoundSearchString:(NSString*)text {
    NSUInteger length = [text length];
    NSString *baseString = nil;
    NSString *incrementedString = nil;
    
    if (length < 1) {
        return text;
    } else if (length > 1) {
        baseString = [text substringToIndex:(length-1)];
    } else {
        baseString = @"";
    }
    UniChar lastChar = [text characterAtIndex:(length-1)];
    UniChar incrementedChar;
    
    if ((lastChar >= 0xD800UL) && (lastChar <= 0xDBFFUL)) {
        incrementedChar = (0xDBFFUL + 1);
    } else if ((lastChar >= 0xDC00UL) && (lastChar <= 0xDFFFUL)) {
        incrementedChar = (0xDFFFUL + 1);
    } else if (lastChar == 0xFFFFUL) {
        if (length > 1 ) baseString = text;
        incrementedChar =  0x1;
    } else {
        incrementedChar = lastChar + 1;
    }
    
    incrementedString = [NSString stringWithFormat:@"%@%C", baseString, incrementedChar];
    
    return incrementedString;
}

- (id)reverseTransformedValue:(id)value {
	
    if (!value) return nil;
    
    NSString *lowBound = nil;
    NSString *highBound = nil;
    NSMutableDictionary *bindVariables = nil;
    
	lowBound = [[self class] normalizeString:value];
    highBound = [[self class] upperBoundSearchString:lowBound];
    
    bindVariables = [[NSMutableDictionary alloc] init];
    [bindVariables setObject:lowBound forKey:@"lowBound"];
    [bindVariables setObject:highBound forKey:@"highBound"];
    
    NSPredicate *result = [self.searchPredicate predicateWithSubstitutionVariables:bindVariables];
	
    [bindVariables release];
	
    return result;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	[self.filteredResultsController.fetchRequest setPredicate:[self reverseTransformedValue:searchText]];
	[NSFetchedResultsController deleteCacheWithName:@"Search"];
	[self fetch];	
}

- (void)fetch {
    NSError *error = nil;
    BOOL success = [self.filteredResultsController performFetch:&error];
    if (!success) {
		NSAssert2(success, @"Unhandled error performing fetch at CidadesViewController.m, line %d: %@", __LINE__, [error localizedDescription]);
	}
	[self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self filterContentForSearchText:searchString scope:
	[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
	return YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	[self.tableView reloadData];
}

@end

