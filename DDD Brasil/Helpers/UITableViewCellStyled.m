//
//  UITableViewCellStyled.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 11/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "UITableViewCellStyled.h"


@implementation UITableViewCellStyled

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 
									   self.textLabel.frame.origin.y, 
									   self.textLabel.frame.size.width + 50, 
									   self.textLabel.frame.size.height);
	
	self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x + 50, 
											 self.detailTextLabel.frame.origin.y, 
											 self.detailTextLabel.frame.size.width - 50, 
											 self.detailTextLabel.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [super dealloc];
}


@end
