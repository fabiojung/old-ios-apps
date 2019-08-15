//
//  TypesViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 07/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "TypesViewController.h"
#import "CheckOSVersion.h"

@interface TypesViewController ()
- (void)reloadArray;
@end

@implementation TypesViewController

@synthesize typesList, delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.navigationItem.title = NSLocalizedString(@"Types", nil);
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[self reloadArray];
	[self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)dealloc {
	[delegate release];
	[typesList release];
	[Type clearCache];
    [super dealloc];
}

- (void)reloadArray {
	if (self.typesList == nil) {
		self.typesList = [[NSMutableArray alloc] initWithArray:[Type findByCriteria:@"WHERE listorder < '1000' ORDER BY listorder ASC;"]];
	}
	else if ([typesList count] > 0){
		self.typesList = nil;
		self.typesList = (NSMutableArray *)[Type findByCriteria:@"WHERE listorder < '1000' ORDER BY listorder ASC;"];
		int index = 1;
		for (Type *type in typesList) {
			if ([type listorder] != 1000){
				type.listorder = index;
			}
			index++;
		}
	}
}

#pragma mark Tableview methods
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
	[super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	[self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.editing) return [typesList count];
	return [typesList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *selectionListCellIdentifier = @"SelectionListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectionListCellIdentifier];
    if (cell == nil) {
        if ([CheckOSVersion isNewOS]) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectionListCellIdentifier] autorelease];
		else 
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:selectionListCellIdentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    if (row >= [typesList count]) {
        if ([CheckOSVersion isNewOS]) {
			cell.textLabel.font = [UIFont boldSystemFontOfSize:19.0];
			cell.textLabel.text = NSLocalizedString(@"Add Type", nil);
		} else {
			cell.font = [UIFont boldSystemFontOfSize:19.0];
			cell.text = NSLocalizedString(@"Add Type", nil);
		}
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        if ([CheckOSVersion isNewOS]) {
			cell.textLabel.font = [UIFont systemFontOfSize:19.0];
			cell.textLabel.text = NSLocalizedString([[typesList objectAtIndex:row] label], nil);
		} else {
			cell.font = [UIFont systemFontOfSize:19.0];
			cell.text = NSLocalizedString([[typesList objectAtIndex:row] label], nil);
		}
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.showsReorderControl = YES; 
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int newRow = [indexPath row];
	
    if (newRow < [typesList count]) {
		delegate.newType = [NSString stringWithString:NSLocalizedString([[typesList objectAtIndex:indexPath.row] label], nil)];
		[self.navigationController dismissModalViewControllerAnimated:YES];
	} else {
        TextFieldViewController *controller = [[TextFieldViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
		[controller release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Perform the re-order
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)oldPath toIndexPath:(NSIndexPath *)newPath {
	id item = [[typesList objectAtIndex:oldPath.row] retain];
	[typesList removeObject:item];
	[typesList insertObject:item atIndex:newPath.row];
	[item release];
	
	for (int i = 0; i < typesList.count; i++) {
		Type *type = [typesList objectAtIndex:i];
		type.listorder = i;
		[type save];
	}
	
	[self reloadArray];
}

// Handle deletion
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	int primaryKey = [[typesList objectAtIndex:indexPath.row] pk];
	[Type deleteObject:primaryKey cascade:NO];
	[typesList removeObjectAtIndex:indexPath.row];
	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	[self reloadArray];
	[self.tableView reloadData];
}

@end

