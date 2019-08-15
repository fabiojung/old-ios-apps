//
//  UITableViewCellBadge.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 20/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "UITableViewCellBadge.h"


@implementation UITableViewCellBadge

@synthesize counterImageView, counterLabel, dayLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		counterImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
		[self.contentView addSubview:counterImageView];
		
		counterLabel = [[UILabel alloc]initWithFrame:CGRectZero];
		counterLabel.textColor = [UIColor whiteColor];
		counterLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
		counterLabel.textAlignment = UITextAlignmentCenter;
		counterLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:counterLabel];
		
		dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		dayLabel.backgroundColor = [UIColor clearColor];
		dayLabel.font = [UIFont boldSystemFontOfSize:10];
		dayLabel.textAlignment = UITextAlignmentCenter;
		dayLabel.textColor = [UIColor blackColor];
		dayLabel.shadowColor = [UIColor whiteColor];
		dayLabel.shadowOffset = CGSizeMake(1, 1);
		[self.imageView addSubview:dayLabel];
	}
	return self;
}

- (void)setCellBadgeStyle:(CellBadgeStyle)style {
	badgeStyle = style;
}

- (void)setBadge:(id)aText {
	NSString *value;
	if ([aText isKindOfClass:[NSNumber class]])
		value = [NSString stringWithFormat:@"%@",aText];
	else
		value = aText;
	counterLabel.text = value;	
}

- (void)setDayOfMonth:(NSString *)aDay {
	dayLabel.text = aDay;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGRect textLabelRect = self.textLabel.frame;
	
	UIFont *font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
	NSString *text = counterLabel.text;
	if (text.length) {
		UIImage *badge;
		if (badgeStyle == CellBadgeStyleRed)
			badge = [[UIImage imageNamed:@"overcount.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		else if (badgeStyle == CellBadgeStyleGreen)
			badge = [[UIImage imageNamed:@"donecount.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		else
			badge = [[UIImage imageNamed:@"count.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		counterImageView.image = badge;
	}
	else
		counterImageView.image = nil;
	
	CGSize size = [text sizeWithFont:font];
	
	CGFloat badgeWidth = size.width + 10;
	if (badgeWidth < 26) badgeWidth = 26;
	CGRect badgeFrame = CGRectMake(contentRect.size.width - badgeWidth - 10,
								   round((contentRect.size.height - 21) / 2),
								   badgeWidth,
								   20.0);
	
	counterLabel.frame = badgeFrame;
	counterImageView.frame = badgeFrame;
	CGRect textLabelFrame = CGRectMake(textLabelRect.origin.x, 
									   textLabelRect.origin.y, 
									   textLabelRect.size.width - badgeFrame.size.width - 5, 
									   textLabelRect.size.height);
	
	self.textLabel.frame = textLabelFrame;
	
	dayLabel.frame = CGRectMake(2.0, 6.0, 24.0, 16.0);
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

- (void)dealloc {
	[counterImageView release];
	[counterLabel release];
	[dayLabel release];
    [super dealloc];
}

@end
