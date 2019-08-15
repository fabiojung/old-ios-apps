//
//  EventViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20.h"
#import "Constants.h"

@interface EventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TTTabDelegate> {
	int petPk;
	NSInteger selectedRow;
	NSString *petName;
	UITableView *myTableView;
	NSMutableArray *tempArray;
	TTTabBar *tabBar;
	TTTabBar *bottonBar;
	UILabel *labelEvent;
	UILabel *labelD;
	UILabel *date;
	UILabel *isLate;
	UIImage *checkBox;
	UIImageView *repeatImage;
}

@property (assign, nonatomic) int petPk;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, retain) NSMutableArray *tempArray;

@end
