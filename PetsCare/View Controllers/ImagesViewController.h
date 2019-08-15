//
//  ImagesViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/07/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageClass.h"

@protocol ImagesViewControllerDelegate;

@interface ImagesViewController : UITableViewController {
	NSMutableArray *cellArray;
	id<ImagesViewControllerDelegate> delegate;
}

@property (assign) id<ImagesViewControllerDelegate> delegate;

@end

@protocol ImagesViewControllerDelegate <NSObject>

- (void)imagesViewControllerDidCancel:(ImagesViewController *)album;
- (void)imagesViewController:(ImagesViewController *)album didFinishPickingImage:(UIImage *)anImage;

@end