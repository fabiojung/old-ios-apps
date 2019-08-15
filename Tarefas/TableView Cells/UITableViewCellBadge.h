//
//  UITableViewCellBadge.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 20/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CellBadgeStyleBlue = 0,
	CellBadgeStyleRed = 1,
	CellBadgeStyleGreen = 2
} CellBadgeStyle;

@interface UITableViewCellBadge : UITableViewCell {
	UIImageView *counterImageView;
	UILabel *counterLabel;
	UILabel *dayLabel;
	CellBadgeStyle badgeStyle;
}

@property (nonatomic, retain) UIImageView *counterImageView;
@property (nonatomic, retain) UILabel *counterLabel;
@property (nonatomic, retain) UILabel *dayLabel;

- (void)setCellBadgeStyle:(CellBadgeStyle)style;
- (void)setBadge:(id)aText;
- (void)setDayOfMonth:(NSString *)aDay;

@end
