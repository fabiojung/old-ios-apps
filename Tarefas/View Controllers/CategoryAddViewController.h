//
//  CategoryAddViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 22/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryAddDelegate;
@class Category;

@interface CategoryAddViewController : UIViewController <UITextFieldDelegate> {
	@private
	Category *category;
	NSNumber *sortOrder;
	UITextField *nameTextField;
	UIBarButtonItem *saveButtonItem;
	BOOL editingCategory;
	id <CategoryAddDelegate> delegate;
}

@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSNumber *sortOrder;
@property (assign) BOOL editingCategory;
@property (nonatomic, assign) id <CategoryAddDelegate> delegate;

- (void)save;
- (void)cancel;

@end

@protocol CategoryAddDelegate <NSObject>
- (void)categoryAddViewController:(CategoryAddViewController *)viewController didAddCategory:(Category *)newCategory;
- (void)popCategoryAddViewController:(CategoryAddViewController *)viewController;
@end
