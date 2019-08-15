//
//  StringsHelper.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 26/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "StringsHelper.h"


@implementation StringsHelper

+ (NSString *)sectionTitleString:(int)value {
	
	switch (value) {
		case 0:
			return NSLocalizedString(@"High_Loc", nil);
			break;
		case 1:
			return NSLocalizedString(@"Medium_Loc", nil);
			break;
		case 2:
			return NSLocalizedString(@"Low_Loc", nil);
			break;
		case 3:
			return NSLocalizedString(@"NoPriority_Loc", nil);
			break;
		case 4:
			return NSLocalizedString(@"Overdue_Loc", nil);
			break;
		case 5:
			return NSLocalizedString(@"Today_Loc", nil);
			break;
		case 6:
			return NSLocalizedString(@"Tomorrow_Loc", nil);
			break;
		case 7:
			return NSLocalizedString(@"NextSevenDays_Loc", nil);
			break;
		case 8:
			return NSLocalizedString(@"Future_Loc", nil);
			break;
		case 9:
			return NSLocalizedString(@"NoDueDate_Loc", nil);
			break;
		default:
			return nil;
			break;
	}
}

+ (NSString *)recurrenceString:(NSNumber *)value {
	int index = [value intValue];
	switch (index) {
		case 0:
			return NSLocalizedString(@"No_Loc", nil);
			break;
		case 1:
			return NSLocalizedString(@"Daily_Loc", nil);
			break;
		case 2:
			return NSLocalizedString(@"Weekly_Loc", nil);
			break;
		case 3:
			return NSLocalizedString(@"Monthly_Loc", nil);
			break;
		case 4:
			return NSLocalizedString(@"3Months_Loc", nil);
			break;
		case 5:
			return NSLocalizedString(@"6Months_Loc", nil);
			break;
		case 6:
			return NSLocalizedString(@"Yearly_Loc", nil);
			break;
		default:
			return NSLocalizedString(@"No_Loc", nil);
			break;
	}
}

+ (NSString *)recurrenceFromString:(NSNumber *)value {
	int index = [value intValue];
	switch (index) {
		case 0:
			return NSLocalizedString(@"DueDate_Loc", nil);
			break;
		case 1:
			return NSLocalizedString(@"CompletionDate_Loc", nil);
			break;
		default:
			return NSLocalizedString(@"None_Loc", nil);
			break;
	}
}

+ (NSString *)iconBadgeTypeString:(NSInteger)value {
	switch (value) {
		case 0:
			return NSLocalizedString(@"NoBadge_Loc", nil);
			break;
		case 1:
			return NSLocalizedString(@"OverBadge_Loc", nil);
			break;
		case 2:
			return NSLocalizedString(@"TodayBadge_Loc", nil);
			break;
		case 3:
			return NSLocalizedString(@"WeekBadge_Loc", nil);
			break;
		case 4:
			return NSLocalizedString(@"OverToday_Loc", nil);
			break;
		case 5:
			return NSLocalizedString(@"OverWeek_Loc", nil);
			break;
		case 6:
			return NSLocalizedString(@"AllActive_Loc", nil);
			break;
		default:
			return nil;
			break;
	}
}

@end
