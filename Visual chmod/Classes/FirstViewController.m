//
//  FirstViewController.m
//  Visual chmod
//
//  Created by Fabio Leonardo Jung on 07/01/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "FirstViewController.h"

#define OWN_READ_TAG		1000
#define OWN_WRITE_TAG		1001
#define OWN_EXEC_TAG		1002
#define GROUP_READ_TAG		1003
#define GROUP_WRITE_TAG		1004
#define GROUP_EXEC_TAG		1005
#define OTHER_READ_TAG		1006
#define OTHER_WRITE_TAG		1007
#define OTHER_EXEC_TAG		1008
#define SW_UID_TAG			2000
#define SW_GID_TAG			2001
#define SW_STBIT_TAG		2002

@interface FirstViewController (Private)
- (void)setImagesToDefault;
- (void)buttonAction:(id)sender;
- (void)switchAction:(id)sender;
- (void)turnUID_ON;
- (void)turnUID_OFF;
- (void)turnGID_ON;
- (void)turnGID_OFF;
- (void)turnStBit_ON;
- (void)turnStBit_OFF;
@end

@implementation FirstViewController

- (id)init {
	if (self = [super init]) {
		[self setTitle:@"# visual chmod"];
		self.tabBarItem.image = [UIImage imageNamed:@"chmod.png"];
		uid_ON = NO;
		gid_ON = NO;
		sticky_ON = NO;
	}
	return self;
}

- (void)loadView {
	int tag = cracked();
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor clearColor]];
	self.view = contentView;
	[contentView release];
	
	UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];;
	[bg setImage:[UIImage imageNamed:@"bg.png"]];
	[contentView addSubview:bg];
	[bg release];
	
	UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 300.0, 280.0, 15.0)];
	[termLabel setBackgroundColor:[UIColor blackColor]];
	[termLabel setOpaque:YES];
	[termLabel setFont:[UIFont fontWithName:@"Courier-Bold" size:20]];
	[termLabel setTextColor:[UIColor greenColor]];
	[termLabel setText:@"#chmod           file"];
	[contentView addSubview:termLabel];
	[termLabel release];
		
	// LINHA UM
	
	imgOwnRead = [[UIImageView alloc] initWithFrame:CGRectMake(107.0, 53.0, 26.0, 26.0)];
	[contentView addSubview:imgOwnRead];
	[imgOwnRead release];
	
	ownRead = [UIButton buttonWithType:UIButtonTypeCustom];
	[ownRead setFrame:CGRectMake(92.0, 45.0, 55.0, 45.0)];
	[ownRead setTag:OWN_READ_TAG];
	[ownRead addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:ownRead];
	
	imgGroupRead = [[UIImageView alloc] initWithFrame:CGRectMake(173.0, 53.0, 26.0, 26.0)];
	[contentView addSubview:imgGroupRead];
	[imgGroupRead release];
	
	groupRead = [UIButton buttonWithType:UIButtonTypeCustom];
	[groupRead setFrame:CGRectMake(152.0, 45.0, 65.0, 45.0)];
	[groupRead setTag:GROUP_READ_TAG];
	[groupRead addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:groupRead];
	
	imgOtherRead = [[UIImageView alloc] initWithFrame:CGRectMake(237.0, 53.0, 26.0, 26.0)];
	[contentView addSubview:imgOtherRead];
	[imgOtherRead release];
	
	otherRead = [UIButton buttonWithType:UIButtonTypeCustom];
	[otherRead setFrame:CGRectMake(220.0, 45.0, 65.0, 45.0)];
	[otherRead setTag:OTHER_READ_TAG];
	[otherRead addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:otherRead];
	
	// LINHA DOIS
	
	imgOwnWrite = [[UIImageView alloc] initWithFrame:CGRectMake(107.0, 104.0, 26.0, 26.0)];
	[contentView addSubview:imgOwnWrite];
	[imgOwnWrite release];
	
	ownWrite = [UIButton buttonWithType:UIButtonTypeCustom];
	[ownWrite setFrame:CGRectMake(92.0, 95.0, 55.0, 45.0)];
	[ownWrite setTag:OWN_WRITE_TAG];
	[ownWrite addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:ownWrite];
	
	imgGroupWrite = [[UIImageView alloc] initWithFrame:CGRectMake(173.0, 104.0, 26.0, 26.0)];
	[contentView addSubview:imgGroupWrite];
	[imgGroupWrite release];
	
	groupWrite = [UIButton buttonWithType:UIButtonTypeCustom];
	[groupWrite setFrame:CGRectMake(152.0, 95.0, 65.0, 45.0)];
	[groupWrite setTag:GROUP_WRITE_TAG];
	[groupWrite addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:groupWrite];
	
	imgOtherWrite = [[UIImageView alloc] initWithFrame:CGRectMake(237.0, 104.0, 26.0, 26.0)];
	[contentView addSubview:imgOtherWrite];
	[imgOtherWrite release];
	
	otherWrite = [UIButton buttonWithType:UIButtonTypeCustom];
	[otherWrite setFrame:CGRectMake(220.0, 95.0, 65.0, 45.0)];
	[otherWrite setTag:OTHER_WRITE_TAG];
	[otherWrite addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:otherWrite];
	
	// LINHA TRES
	
	if (tag > 0) [self setImagesToDefault];
	
	imgOwnExec = [[UIImageView alloc] initWithFrame:CGRectMake(107.0, 154.0, 26.0, 26.0)];
	[contentView addSubview:imgOwnExec];
	[imgOwnExec release];
	
	ownExec = [UIButton buttonWithType:UIButtonTypeCustom];
	[ownExec setFrame:CGRectMake(92.0, 143.0, 55.0, 45.0)];
	[ownExec setTag:OWN_EXEC_TAG];
	[ownExec addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:ownExec];
	
	imgGroupExec = [[UIImageView alloc] initWithFrame:CGRectMake(173.0, 154.0, 26.0, 26.0)];
	[contentView addSubview:imgGroupExec];
	[imgGroupExec release];
	
	groupExec = [UIButton buttonWithType:UIButtonTypeCustom];
	[groupExec setFrame:CGRectMake(152.0, 143.0, 65.0, 45.0)];
	[groupExec setTag:GROUP_EXEC_TAG];
	[groupExec addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:groupExec];
	
	imgOtherExec = [[UIImageView alloc] initWithFrame:CGRectMake(237.0, 154.0, 26.0, 26.0)];
	[contentView addSubview:imgOtherExec];
	[imgOtherExec release];
	
	otherExec = [UIButton buttonWithType:UIButtonTypeCustom];
	[otherExec setFrame:CGRectMake(220.0, 143.0, 65.0, 45.0)];
	[otherExec setTag:OTHER_EXEC_TAG];
	[otherExec addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:otherExec];
	
	// TEXT FIELDS
	
	lsText = [[NSMutableString alloc] initWithString:@"----------"];
			  
	lsLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 355.0, 200.0, 20.0)];
	[lsLabel setBackgroundColor:[UIColor blackColor]];
	[lsLabel setOpaque:YES];
	[lsLabel setFont:[UIFont fontWithName:@"Courier-Bold" size:30]];
	[lsLabel setTextColor:[UIColor greenColor]];
	[lsLabel setText:lsText];
	[contentView addSubview:lsLabel];
	[lsLabel release];
	
	chmodText1 = [[NSMutableString alloc] initWithString:@"0000"];
	
	chmodLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 298.0, 75.0, 20.0)];
	[chmodLabel setBackgroundColor:[UIColor blackColor]];
	[chmodLabel setOpaque:YES];
	[chmodLabel setFont:[UIFont fontWithName:@"Courier-Bold" size:30]];
	[chmodLabel setTextColor:[UIColor greenColor]];
	[chmodLabel setText:chmodText1];
	[contentView addSubview:chmodLabel];
	[chmodLabel release];
	
	// SWITCHES
	
	swUID = [[UISwitch alloc] initWithFrame:CGRectMake(15.0, 237.5, 94.0, 26.0)];
	[swUID addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
	[swUID setBackgroundColor:[UIColor clearColor]];
	[swUID setTag:SW_UID_TAG];
	[contentView addSubview:swUID];
	[swUID release];
	
	swGID = [[UISwitch alloc] initWithFrame:CGRectMake(110.0, 237.5, 94.0, 26.0)];
	[swGID addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
	[swGID setBackgroundColor:[UIColor clearColor]];
	[swGID setTag:SW_GID_TAG];
	[contentView addSubview:swGID];
	[swGID release];
	
	swStBit = [[UISwitch alloc] initWithFrame:CGRectMake(205.0, 237.5, 94.0, 26.0)];
	[swStBit addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
	[swStBit setBackgroundColor:[UIColor clearColor]];
	[swStBit setTag:SW_STBIT_TAG];
	[contentView addSubview:swStBit];
	[swStBit release];
}	

- (void)buttonAction:(id)sender {
	switch ([sender tag]) {
		case OWN_READ_TAG:
			if (imgOwnRead.image == nil) {
				owner += 4;
				[imgOwnRead setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(1, 1) withString:@"r"];
				if (swUID.isOn) [self turnUID_ON]; 
				[chmodText1 replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d", owner]];
			} else {
				owner -= 4;
				[imgOwnRead setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(1, 1) withString:@"-"];
				if (swUID.isOn) [self turnUID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d", owner]];
			}
			break;
		case GROUP_READ_TAG:
			if (imgGroupRead.image == nil) {
				group += 4;
				[imgGroupRead setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(4, 1) withString:@"r"];
				if (swGID.isOn) [self turnGID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d", group]];
			} else {
				group -= 4;
				[imgGroupRead setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
				if (swGID.isOn) [self turnGID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d", group]];
			}
			break;
		case OTHER_READ_TAG:
			if (imgOtherRead.image == nil) {
				other += 4;
				[imgOtherRead setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(7, 1) withString:@"r"];
				if (swStBit.isOn) [self turnStBit_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(3, 1) withString:[NSString stringWithFormat:@"%d", other]];
			} else {
				other -= 4;
				[imgOtherRead setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
				if (swStBit.isOn) [self turnStBit_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(3, 1) withString:[NSString stringWithFormat:@"%d", other]];
			}
			break;
		case OWN_WRITE_TAG:
			if (imgOwnWrite.image == nil) {
				owner += 2;
				[imgOwnWrite setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(2, 1) withString:@"w"];
				if (swUID.isOn) [self turnUID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d", owner]];
			} else {
				owner -= 2;
				[imgOwnWrite setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(2, 1) withString:@"-"];
				if (swUID.isOn) [self turnUID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d", owner]];
			}
			break;
		case GROUP_WRITE_TAG:
			if (imgGroupWrite.image == nil) {
				group += 2;
				[imgGroupWrite setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(5, 1) withString:@"w"];
				if (swGID.isOn) [self turnGID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d", group]];
			} else {
				group -= 2;
				[imgGroupWrite setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(5, 1) withString:@"-"];
				if (swGID.isOn) [self turnGID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d", group]];
			}
			break;
		case OTHER_WRITE_TAG:
			if (imgOtherWrite.image == nil) {
				other += 2;
				[imgOtherWrite setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(8, 1) withString:@"w"];
				if (swStBit.isOn) [self turnStBit_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(3, 1) withString:[NSString stringWithFormat:@"%d", other]];
			} else {
				other -= 2;
				[imgOtherWrite setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(8, 1) withString:@"-"];
				if (swStBit.isOn) [self turnStBit_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(3, 1) withString:[NSString stringWithFormat:@"%d", other]];
			}
			break;
		case OWN_EXEC_TAG:
			if (imgOwnExec.image == nil) {
				owner += 1;
				[imgOwnExec setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(3, 1) withString:@"x"];
				if (swUID.isOn) [self turnUID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d", owner]];
			} else {
				owner -= 1;
				[imgOwnExec setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(3, 1) withString:@"-"];
				if (swUID.isOn) [self turnUID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%d", owner]];
			}
			break;
		case GROUP_EXEC_TAG:
			if (imgGroupExec.image == nil) {
				group += 1;
				[imgGroupExec setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(6, 1) withString:@"x"];
				if (swGID.isOn) [self turnGID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d", group]];
			} else {
				group -= 1;
				[imgGroupExec setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(6, 1) withString:@"-"];
				if (swGID.isOn) [self turnGID_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(2, 1) withString:[NSString stringWithFormat:@"%d", group]];
			}
			break;
		case OTHER_EXEC_TAG:
			if (imgOtherExec.image == nil) {
				other += 1;
				[imgOtherExec setImage:[UIImage imageNamed:@"check.png"]];
				[lsText replaceCharactersInRange:NSMakeRange(9, 1) withString:@"x"];
				if (swStBit.isOn) [self turnStBit_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(3, 1) withString:[NSString stringWithFormat:@"%d", other]];
			} else {
				other -= 1;
				[imgOtherExec setImage:nil];
				[lsText replaceCharactersInRange:NSMakeRange(9, 1) withString:@"-"];
				if (swStBit.isOn) [self turnStBit_ON];
				[chmodText1 replaceCharactersInRange:NSMakeRange(3, 1) withString:[NSString stringWithFormat:@"%d", other]];
				
			}
			break;
	}
	[lsLabel setText:lsText];
	[chmodLabel setText:chmodText1];
}

- (void)switchAction:(id)sender {
	switch ([sender tag]) {
		case SW_UID_TAG:
			if ([swUID isOn]) {
				if (uid_ON) return;
				root += 4;
				[chmodText1 replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", root]];
				[self turnUID_ON];
				uid_ON = YES;
			} else {
				if (!uid_ON) return;
				root -= 4;
				[chmodText1 replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", root]];
				[self turnUID_OFF];
				uid_ON = NO;
			}
			break;
		case SW_GID_TAG:
			if ([swGID isOn]) {
				if (gid_ON) return;
				root += 2;
				[chmodText1 replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", root]];
				[self turnGID_ON];
				gid_ON = YES;
			} else {
				if (!gid_ON) return;
				root -= 2;
				[chmodText1 replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", root]];
				[self turnGID_OFF];
				gid_ON = NO;
			}
			break;
		case SW_STBIT_TAG:
			if ([swStBit isOn]) {
				if (sticky_ON) return;
				root += 1;
				[chmodText1 replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", root]];
				[self turnStBit_ON];
				sticky_ON = YES;
			} else {
				if (!sticky_ON) return;
				root -= 1;
				[chmodText1 replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", root]];
				[self turnStBit_OFF];
				sticky_ON = NO;
			}
			break;
	}
	[chmodLabel setText:chmodText1];
	[lsLabel setText:lsText];
}

- (void)turnUID_ON {
	if (owner % 2 == 0) [lsText replaceCharactersInRange:NSMakeRange(3, 1) withString:@"S"];
	if (owner % 2 == 1) [lsText replaceCharactersInRange:NSMakeRange(3, 1) withString:@"s"];
}

- (void)turnUID_OFF {
	if (owner % 2 == 0) [lsText replaceCharactersInRange:NSMakeRange(3, 1) withString:@"-"];
	if (owner % 2 == 1) [lsText replaceCharactersInRange:NSMakeRange(3, 1) withString:@"x"];
}

- (void)turnGID_ON {
	if (group % 2 == 0) [lsText replaceCharactersInRange:NSMakeRange(6, 1) withString:@"S"];
	if (group % 2 == 1) [lsText replaceCharactersInRange:NSMakeRange(6, 1) withString:@"s"];
}

- (void)turnGID_OFF {
	if (group % 2 == 0) [lsText replaceCharactersInRange:NSMakeRange(6, 1) withString:@"-"];
	if (group % 2 == 1) [lsText replaceCharactersInRange:NSMakeRange(6, 1) withString:@"x"];
}

- (void)turnStBit_ON {
	if (other % 2 == 0) [lsText replaceCharactersInRange:NSMakeRange(9, 1) withString:@"T"];
	if (other % 2 == 1) [lsText replaceCharactersInRange:NSMakeRange(9, 1) withString:@"t"];
}

- (void)turnStBit_OFF {
	if (other % 2 == 0) [lsText replaceCharactersInRange:NSMakeRange(9, 1) withString:@"-"];
	if (other % 2 == 1) [lsText replaceCharactersInRange:NSMakeRange(9, 1) withString:@"x"];
}

- (void)setImagesToDefault {
	
	NSString *temp = NSTemporaryDirectory();	
	NSString *tempPath = [temp stringByAppendingPathComponent:@".WebKitLocalStorage"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
		NSDictionary *newDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]
														   forKeys:[NSArray arrayWithObject:@"value"]];
		[newDic writeToFile:tempPath atomically:YES];
	}
	
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:tempPath];
	int value = [[dic objectForKey:@"value"] intValue];
	if (value > 5) {
		NSString *string = [NSString stringWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=304896759&mt=8&uo=6"];
		NSURL *link = [[NSURL alloc] initWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:link];
		[link release];
	} else {
		value++;
		[dic setValue:[NSNumber numberWithInt:value] forKey:@"value"];
		[dic writeToFile:tempPath atomically:YES];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
