//
//  RootViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 20/08/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import "RootViewController.h"
#import "TarefasAppDelegate.h"
#import "UITableViewCellBadge.h"
#import "TasksViewController.h"
#import "TaskAddViewController.h"
#import "ConfigViewController.h"
#import "DateHelper.h"
#import "Category.h"
#import "Task.h"

@implementation RootViewController

@synthesize fetchedResultsControllerForTasks;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize rootTableView;
@synthesize configButton;

- (void)countAllTasks {
	allTasks = [ModelHelper countAllTasksIn:managedObjectContext];
	if ([TarefasAppDelegate nextSortValue] == 0) {
		[TarefasAppDelegate setNextSortValue:allTasks];
	}
}

- (void)countNotDoneTasks {
	notDoneTasks = [ModelHelper countNotDoneTasksIn:managedObjectContext];
}

- (void)countDoneTasks {
	doneTasks = [ModelHelper countDoneTasksIn:managedObjectContext];

}

- (void)countTodayTasks {
	todayTasks = [ModelHelper countTodayTasksIn:managedObjectContext];

}

- (void)countLateTasks {
	lateTasks = [ModelHelper countLateTasksIn:managedObjectContext];

}

- (void)dealloc {
	self.navigationItem.rightBarButtonItem = nil;
	[rootTableView release];
	[configButton release];
	[addListButton release];
	[addTaskButton release];
	[fetchedResultsControllerForTasks release];
	[fetchedResultsController release];
	[managedObjectContext release];
	managedObjectContext = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Lists_Loc", @"");
	self.rootTableView.backgroundColor = [UIColor clearColor];
	self.rootTableView.allowsSelectionDuringEditing = YES;
	self.view.backgroundColor = [UIColor clearColor];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	addTaskButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewTask)];
	addListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addList.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(insertNewCategory)];
	self.navigationItem.rightBarButtonItem = addTaskButton;	
    	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle the error...
	}
}

- (void)reloadAll {
	allTasks = 0;
	notDoneTasks = 0;
	doneTasks = 0;
	todayTasks = 0;
	lateTasks = 0;
	
	[self countAllTasks];
	[self countNotDoneTasks];
	[self countDoneTasks];
	[self countTodayTasks];
	[self countLateTasks];
	[self.rootTableView reloadData];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.rootTableView = nil;
	self.configButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[self reloadAll];
    [super viewWillAppear:animated];
}

- (void)insertNewCategory {
	
	CategoryAddViewController *addController = [[CategoryAddViewController alloc] init];//WithNibName:@"CategoryAddViewController" bundle:nil];
    addController.delegate = self;
	
	Category *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
	addController.category = newCategory;
	addController.sortOrder = [NSNumber numberWithInteger:[TarefasAppDelegate nextCategorySortValue]];
	
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentModalViewController:navigationController animated:YES];
    
    [navigationController release];
    [addController release];
}

- (void)editCategory:(Category *)aCategory {
	CategoryAddViewController *controller = [[CategoryAddViewController alloc] init];//WithNibName:@"CategoryAddViewController" bundle:nil];
    controller.delegate = self;
	
	controller.category = aCategory;
	controller.editingCategory = YES;
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)insertNewTask {
	TaskAddViewController *controller = [[TaskAddViewController alloc] init];
	controller.delegate = self;
	
	Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
	controller.task = newTask;
	
	controller.sortOrder = [NSNumber numberWithInteger:[TarefasAppDelegate nextSortValue]];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navigationController animated:YES];
    
    [navigationController release];
    [controller release];
}

- (IBAction)presentModalConfigView:(id)sender {
	ConfigViewController *configController = [[ConfigViewController alloc] init];
	UINavigationController *configNavController = [[UINavigationController alloc] initWithRootViewController:configController];
	[configController release];
	configNavController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController presentModalViewController:configNavController animated:YES];
	[configNavController release];
}

- (void)setEditable:(BOOL)editable {
    self.navigationItem.leftBarButtonItem.enabled = editable;
    self.navigationItem.rightBarButtonItem.enabled = editable;
}

#pragma mark -
#pragma mark CategoryDelegate methods

- (void)categoryAddViewController:(CategoryAddViewController *)viewController didAddCategory:(Category *)newCategory {
	NSError *error = nil;
	if (newCategory != nil) {
		if (![newCategory.managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
		[TarefasAppDelegate incrementNextCategorySortValue];
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)popCategoryAddViewController:(CategoryAddViewController *)viewController {
	[viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark TaskDelegate methods

- (void)activeViewController:(UIViewController *)viewController didSaveTask:(Task *)aTask {
	NSError *error = nil;
	if (aTask != nil) {
		if (![aTask.managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
		[TarefasAppDelegate incrementNextSortValue];
	}
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark TableView methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	self.navigationItem.rightBarButtonItem = nil;
	if (editing) {
		self.configButton.enabled = NO;
		self.navigationItem.rightBarButtonItem = addListButton;
	} else {
		self.configButton.enabled = YES;
		self.navigationItem.rightBarButtonItem = addTaskButton;
	}
	[super setEditing:editing animated:animated];
	[self.rootTableView setEditing:editing animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
	else if (section == 1) { 
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
		if ([TarefasAppDelegate nextCategorySortValue] == 0) {
			[TarefasAppDelegate setNextCategorySortValue:[sectionInfo numberOfObjects]];
		}
		return [sectionInfo numberOfObjects];
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RootViewCell";
    
    UITableViewCellBadge *cell = (UITableViewCellBadge *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCellBadge alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	NSIndexPath *objIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
	Category *category = (Category *)[fetchedResultsController objectAtIndexPath:objIndexPath];
	
	[cell setCellBadgeStyle:CellBadgeStyleBlue];
	[cell setDayOfMonth:@""];
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"AllTasks_Loc", nil);
			cell.imageView.image = [UIImage imageNamed:@"all.png"];
			[cell setBadge:[NSString stringWithFormat:@"%d", notDoneTasks]];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Today_Loc", nil);
			cell.imageView.image = [UIImage imageNamed:@"calendar.png"];
			[cell setBadge:[NSString stringWithFormat:@"%d", todayTasks]];
			[cell setDayOfMonth:[DateHelper currentDayOfMonth]];
		} else if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Overdue_Loc", nil);
			cell.imageView.image = [UIImage imageNamed:@"calendarDue.png"];
			[cell setDayOfMonth:@"!"];
			[cell setCellBadgeStyle:CellBadgeStyleRed];
			[cell setBadge:[NSString stringWithFormat:@"%d", lateTasks]];
		}
	} else if (indexPath.section == 1) {
		NSString *tasksCount = @"0";
		if (category.categoryName != nil) {
			tasksCount = [NSString stringWithFormat:@"%d", [ModelHelper countByCategory:category.categoryName inContext:managedObjectContext]];
		}
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(category.categoryName, nil);
			cell.imageView.image = [UIImage imageNamed:@"home.png"];
			[cell setBadge:tasksCount];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(category.categoryName, nil);
			cell.imageView.image = [UIImage imageNamed:@"work.png"];
			[cell setBadge:tasksCount];
		} else if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(category.categoryName, nil);
			cell.imageView.image = [UIImage imageNamed:@"users.png"];
			[cell setBadge:tasksCount];
		} else {
			cell.textLabel.text = category.categoryName;
			cell.imageView.image = [UIImage imageNamed:@"UserList.png"];
			[cell setBadge:tasksCount];
		}
	} else if (indexPath.section == 2) {
		cell.textLabel.text = NSLocalizedString(@"Completed_Loc", nil);
		cell.imageView.image = [UIImage imageNamed:@"done.png"];
		[cell setCellBadgeStyle:CellBadgeStyleGreen];
		[cell setBadge:[NSString stringWithFormat:@"%d", doneTasks]];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
		if (indexPath.section == 1) {
			return indexPath;
		} else {
			return nil;
		}
	} else {
		return indexPath;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
		NSIndexPath *objIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
		Category *tmpCategory = [fetchedResultsController objectAtIndexPath:objIndexPath];
		[self editCategory:tmpCategory];
	} else {
		TasksViewController *controller = [[TasksViewController alloc] initWithNibName:@"TasksViewController" bundle:nil];
		controller.managedObjectContext = self.managedObjectContext;

		NSString *navTitle = nil;
		if (indexPath.section == 0) {
			if (indexPath.row == 0) navTitle = NSLocalizedString(@"AllTasks_Loc", nil);
			else if (indexPath.row == 1) navTitle = NSLocalizedString(@"Today_Loc", nil);
			else if (indexPath.row == 2) navTitle = NSLocalizedString(@"Overdue_Loc", nil);
			controller.predicateNumber = [NSNumber numberWithInteger:indexPath.row];
		} else if (indexPath.section == 1) {
			NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
			controller.predicateNumber = [NSNumber numberWithInteger:4];
			controller.predicateCategory = [[fetchedResultsController objectAtIndexPath:categoryIndexPath] categoryName];
			navTitle = NSLocalizedString([[fetchedResultsController objectAtIndexPath:categoryIndexPath] categoryName], nil);
		} else if (indexPath.section == 2) {
			navTitle = NSLocalizedString(@"Completed_Loc", nil);
			controller.predicateNumber = [NSNumber numberWithInteger:3];
		}
		controller.navigationBarTitle = navTitle;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		return YES;
	}
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    
	if (indexPath.section == 1 && indexPath.row > 2) {
		return UITableViewCellEditingStyleDelete;
	}	
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (indexPath.row > 2) {
			[self.rootTableView beginUpdates];
			NSIndexPath *objIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
			NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
			[context deleteObject:[fetchedResultsController objectAtIndexPath:objIndexPath]];
			
			NSError *error;
			if (![context save:&error]) {
					// Handle the error...
			}
			
			[self.rootTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.rootTableView endUpdates];
		} else {
			
		}
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -
#pragma mark Core Data methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.rootTableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																									managedObjectContext:managedObjectContext 
																									  sectionNameKeyPath:nil 
																											   cacheName:@"CategoryCache"];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	return fetchedResultsController;
}    

- (NSFetchedResultsController *)fetchedResultsControllerForTasks {
    
    if (fetchedResultsControllerForTasks == nil) {
        NSFetchRequest *fetchRequestTask = [[NSFetchRequest alloc] init];
		NSEntityDescription *entityTask = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
		[fetchRequestTask setEntity:entityTask];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequestTask setSortDescriptors:sortDescriptors];
		
		NSFetchedResultsController *aFetchedResultsControllerTask = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestTask 
																										managedObjectContext:managedObjectContext 
																										  sectionNameKeyPath:nil 
																												   cacheName:@"TaskCache"];
		self.fetchedResultsControllerForTasks = aFetchedResultsControllerTask;
		
		[aFetchedResultsControllerTask release];
		[fetchRequestTask release];
		[sortDescriptor release];
		[sortDescriptors release];
	}

	return fetchedResultsControllerForTasks;
}

@end

