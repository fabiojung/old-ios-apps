//
//  HealthViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 25/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20.h"
#import "Constants.h"

@interface HealthViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TTTabDelegate> {
	int petPk;
	NSInteger selectedRow;
	NSString *petName;
	UITableView *myTableView;
	NSMutableArray *tempArray;
	TTTabBar *tabBar;
	TTTabBar *bottonBar;
	UILabel *isLate;
	UIImage *checkBox;
	UIImageView *repeatImage;
	UILabel *header;
	UILabel *desc;
	UILabel *dateLabel;
	UILabel *dateValue;
}

@property (assign, nonatomic) int petPk;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, retain) NSMutableArray *tempArray;

@end
