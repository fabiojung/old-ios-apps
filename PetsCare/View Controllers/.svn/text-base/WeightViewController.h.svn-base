//
//  WeightViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 26/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20.h"
#import "Constants.h"

@interface WeightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TTTabDelegate> {
	int petPk;
	NSInteger selectedRow;
	NSString *petName;
	UITableView *myTableView;
	NSMutableArray *tempArray;
	TTTabBar *tabBar;
	TTTabBar *bottonBar;
	UIView *graphView;
	NSString *unit;
	UILabel *labelW;
	UILabel *weightLabel;
	UILabel *labelD;
	UILabel *dateLabel;
}

@property (assign, nonatomic) int petPk;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, retain) NSMutableArray *tempArray;

@end
