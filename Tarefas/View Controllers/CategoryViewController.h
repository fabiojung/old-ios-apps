//
//  CategoryViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 25/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate;
@class Category;


@interface CategoryViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
	id <CategoryViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (assign) id<CategoryViewControllerDelegate> delegate;

@end

@protocol CategoryViewControllerDelegate <NSObject>
- (void)updateTaskWithCategory:(Category *)newCategory;
- (NSInteger)categoryOrder;
@end