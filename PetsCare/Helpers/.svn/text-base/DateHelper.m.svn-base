//
//  DateHelper.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 05/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (id)stringFromDate:(NSDate *)date withNames:(BOOL)flag {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
	
    if (flag) {
		// Initialize the calendar and flags.
		unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSCalendar *calendar = [NSCalendar currentCalendar];
		// Create reference date for supplied date.
		NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
		[comps setHour:0];
		[comps setMinute:0];
		[comps setSecond:0];
		NSDate *suppliedDate = [calendar dateFromComponents:comps];
		comps = [calendar components:unitFlags fromDate:[NSDate date]];
		[comps setHour:0];
		[comps setMinute:0];
		[comps setSecond:0];
		NSDate *referenceDate = [calendar dateFromComponents:comps];
		if ([suppliedDate compare:referenceDate] == NSOrderedSame) 	{
			// Today
			return [NSString stringWithString:NSLocalizedString(@"Today", nil)];
		}
		[comps setDay:[comps day] - 1];
		referenceDate = [calendar dateFromComponents:comps];
		if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
			// Yesterday
			return [NSString stringWithString:NSLocalizedString(@"Yesterday", nil)];
		}
		[comps setDay:[comps day] + 2];
		referenceDate = [calendar dateFromComponents:comps];
		if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
			// Tomorrow
			return [NSString stringWithString:NSLocalizedString(@"Tomorrow", nil)];
		}
		// It's not in those three days.
		return [formatter stringFromDate:date];
	}	
    return [formatter stringFromDate:date];
}

+ (NSComparisonResult)compareAgainstNow:(NSDate *)date {
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	NSDate *suppliedDate = [calendar dateFromComponents:comps];
	comps = [calendar components:unitFlags fromDate:[NSDate date]];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	NSDate *today = [calendar dateFromComponents:comps];
	return [suppliedDate compare:today];
}

+ (NSString *)petAgeFromBornDate:(NSDate *)date {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:date
												  toDate:[NSDate date] options:0];
	NSInteger years = [components year];
	NSInteger months = [components month];
	NSInteger days = [components day];
	NSString *petAge = nil;
	
	if (months == 0) {
		if (years == 0) {
			if (days == 1) petAge = [NSString stringWithFormat:@"%d %@", days, NSLocalizedString(@"dayOld", nil)];
			if (days > 1) petAge = [NSString stringWithFormat:@"%d %@", days, NSLocalizedString(@"daysOld", nil)];
		}
		if (years == 1) petAge = [NSString stringWithFormat:@"%d %@", years, NSLocalizedString(@"yearOld", nil)];
		if (years > 1) petAge = [NSString stringWithFormat:@"%d %@", years, NSLocalizedString(@"yearsOld", nil)];
	} else if (months == 1) {
		if (years == 0) petAge = [NSString stringWithFormat:@"%d %@", months, NSLocalizedString(@"monthOld", nil)];
		if (years == 1) petAge = [NSString stringWithFormat:@"%d %@ %d %@", years, NSLocalizedString(@"yearAnd", nil), months, NSLocalizedString(@"monthOld", nil)];
		if (years > 1) petAge = [NSString stringWithFormat:@"%d %@ %d %@", years, NSLocalizedString(@"yearsAnd", nil), months, NSLocalizedString(@"monthOld", nil)];
	} else if (months > 1) {
		if (years == 0) petAge = [NSString stringWithFormat:@"%d %@", months, NSLocalizedString(@"monthsOld", nil)];
		if (years == 1) petAge = [NSString stringWithFormat:@"%d %@ %d %@", years, NSLocalizedString(@"yearAnd", nil), months, NSLocalizedString(@"monthsOld", nil)];
		if (years > 1) petAge = [NSString stringWithFormat:@"%d %@ %d %@", years, NSLocalizedString(@"yearsAnd", nil), months, NSLocalizedString(@"monthsOld", nil)];
	}
	[gregorian release];
	return petAge;
}

+ (NSDate *)newDateForRepeatType:(NSInteger)repeat andDone:(NSDate *)date {
	NSCalendar *userCalendar = [NSCalendar currentCalendar];
	NSDateComponents *newComponents = [[[NSDateComponents alloc] init] autorelease];
	
	switch (repeat) {
		case 1: //Daily
			[newComponents setDay:1];
			break;
		case 2: //Weekly
			[newComponents setDay:7];
			break;
		case 3: //Monthly
			[newComponents setMonth:1];
			break;
		case 4: // 3 Monthly
			[newComponents setMonth:3];
			break;
		case 5: // 6 Monthly
			[newComponents setMonth:6];
			break;
		case 6: // Yearly
			[newComponents setYear:1];
			break;
	}
	NSDate *newDate = [userCalendar dateByAddingComponents:newComponents toDate:date options:0];
	return newDate;
}

@end
