//
//  UITableViewCellTask.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 27/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonCell;

@interface UITableViewCellTask : UITableViewCell {
	UILabel *titleLabel;
	UILabel *dateLabel;
	UIImageView *priorityImageView;
	UIImageView *notesImageView;
	UIImageView *recurrenceImageView;
	ButtonCell *checkButton;
	BOOL hasPriority, hasRecurrence, hasNotes;
}

- (void)setTitleLabelText:(NSString *)newText;
- (void)setDateLabelText:(NSString *)newText;
- (void)setPriorityImage:(UIImage *)newImage;
- (void)setNotesImage:(UIImage *)newImage;
- (void)setRecurrenceImage:(UIImage *)newImage;
- (void)didSetCell:(BOOL)completed;
- (void)setCheckButtonTag:(NSIndexPath *)aTag andTarget:(id)aTarget;
- (void)setCellCheckedWithAnimation;
- (void)setCellUncheckedWithAnimation;
- (void)startDeleteAnimation;
@end
