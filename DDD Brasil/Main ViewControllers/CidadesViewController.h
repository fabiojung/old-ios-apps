//
//  CidadesViewController.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 11/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CidadesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSFetchedResultsController *filteredResultsController;
    NSManagedObjectContext *managedObjectContext;
	NSPredicate *searchPredicate;
	NSMutableArray *indexTitles;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *filteredResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) NSPredicate *searchPredicate;
@property (nonatomic, copy) NSMutableArray *indexTitles;

- (void)fetch;
- (NSArray *)lettersForSections;
- (void)performPreFetch;

@end
