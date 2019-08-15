//
//  UITableViewCellTask.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 27/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "UITableViewCellTask.h"
#import "TasksViewController.h"
#import "ButtonCell.h"

@implementation UITableViewCellTask

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:18];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.minimumFontSize = 14;
		titleLabel.shadowColor = [UIColor darkGrayColor];
		titleLabel.shadowOffset = CGSizeMake(1, 1);
		titleLabel.opaque = YES;
		[self.contentView addSubview:titleLabel];
		[titleLabel release];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.font = [UIFont systemFontOfSize:13];
		dateLabel.textColor = [UIColor whiteColor];
		dateLabel.shadowColor = [UIColor darkGrayColor];
		dateLabel.shadowOffset = CGSizeMake(1, 1);
		dateLabel.opaque = YES;
		[self.contentView addSubview:dateLabel];
		[dateLabel release];
		
		priorityImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		priorityImageView.backgroundColor = [UIColor clearColor];
		priorityImageView.opaque = YES;
		[self.contentView addSubview:priorityImageView];
		[priorityImageView release];
		
		notesImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		notesImageView.backgroundColor = [UIColor clearColor];
		notesImageView.opaque = YES;
		[self.contentView addSubview:notesImageView];
		[notesImageView release];
		
		recurrenceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		recurrenceImageView.backgroundColor = [UIColor clearColor];
		recurrenceImageView.opaque = YES;
		[self.contentView addSubview:recurrenceImageView];
		[recurrenceImageView release];
		
		checkButton = [[ButtonCell alloc] initWithFrame:CGRectMake(5.0, 0.0, 35.0, 60.0)];
		[checkButton setEnabled:YES];
		[checkButton setOpaque:YES];
		[checkButton setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:checkButton];
		[checkButton release];
		
		hasPriority = NO;
		hasRecurrence = NO;
		hasNotes = NO;
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	UIFont *font = [UIFont systemFontOfSize:13];
	NSString *text = dateLabel.text;
	
	titleLabel.frame = CGRectMake (
								  50.0, 
								  10.0, 
								  contentRect.size.width - 50, 
								  20.0
								  );
	
	CGSize size = [text sizeWithFont:font];
	dateLabel.frame = CGRectMake (
								  50.0, 
								  35.0, 
								  size.width, 
								  15.0
								  );
	
	float sizeWidth = 60 + size.width;
	
	if (hasRecurrence) {
		recurrenceImageView.frame = CGRectMake(sizeWidth,
											   34.0,
											   17.0, //17.0
											   16.0);
		sizeWidth += 27; //27
	} else {
		recurrenceImageView.frame = CGRectZero;
	}
	
	if (hasPriority) {
		priorityImageView.frame = CGRectMake(sizeWidth,
											 33.0,
											 17.0, 
											 17.0);
		sizeWidth += 27;
	} else {
		priorityImageView.frame = CGRectZero;
	}
	
	if (hasNotes) {
		notesImageView.frame = CGRectMake(sizeWidth,
										  33.0,
										  16.0, 
										  16.0);
	} else {
		notesImageView.frame = CGRectZero;
	}
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//
//    [super setSelected:selected animated:animated];
//
//}

- (void)didSetCell:(BOOL)completed {
	if (completed) {
		titleLabel.alpha = 0.70;
		dateLabel.alpha = 0.70;
	} else {
		titleLabel.alpha = 1.0;
		dateLabel.alpha = 1.0;
	}
}

- (void)setTitleLabelText:(NSString *)newText {
	if (newText) {
		titleLabel.text = newText;
	}
}

- (void)setDateLabelText:(NSString *)newText {
	if (newText) {
		dateLabel.text = newText;
	}
}

- (void)setPriorityImage:(UIImage *)newImage {
	if (newImage != nil) {
		priorityImageView.image = newImage;
		hasPriority = YES;
	} else {
		priorityImageView.image = nil;
		hasPriority = NO;
	}
}

- (void)setNotesImage:(UIImage *)newImage {
	if (newImage != nil) {
		notesImageView.image = newImage;
		hasNotes = YES;
	} else {
		notesImageView.image = nil;
		hasNotes = NO;
	}
}

- (void)setRecurrenceImage:(UIImage *)newImage {
	if (newImage != nil) {
		recurrenceImageView.image = newImage;
		hasRecurrence = YES;
	} else {
		recurrenceImageView.image = nil;
		hasRecurrence = NO;
	}
}

- (void)setCheckButtonTag:(NSIndexPath *)aTag andTarget:(id)aTarget {
	[checkButton addTarget:aTarget action:@selector(changeTaskStatus:) forControlEvents:UIControlEventTouchDown];
	[checkButton setIndexPath:aTag];
}

- (void)setCellCheckedWithAnimation {
	self.imageView.image = [UIImage imageNamed:@"checkboxDone.png"];
	titleLabel.alpha = 0.70;
	dateLabel.alpha = 0.70;
}

- (void)setCellUncheckedWithAnimation {
	self.imageView.image = [UIImage imageNamed:@"checkbox.png"];
	titleLabel.alpha = 1.0;
	dateLabel.alpha = 1.0;
}

- (void)startDeleteAnimation {
	UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 256.0, 60.0)];
	[deleteImageView setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"poof01.png"],
																  [UIImage imageNamed:@"poof02.png"],
															      [UIImage imageNamed:@"poof03.png"],
																  [UIImage imageNamed:@"poof04.png"],
																  [UIImage imageNamed:@"poof05.png"], nil]];
	[deleteImageView setAnimationRepeatCount:1];
	[deleteImageView setAnimationDuration:0.5];
	[deleteImageView setTag:5000];
	[self addSubview:deleteImageView];
	[deleteImageView release];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.5];
	self.contentView.alpha = 0.0;
	[UIView commitAnimations];
	[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:[self viewWithTag:5000] withObject:nil];
}

- (void)dealloc {
    [super dealloc];
}

@end
