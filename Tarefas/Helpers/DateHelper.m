//
//  DateHelper.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 05/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

static NSDateFormatter *formatter = nil;
static unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

+ (NSDateComponents *)componentsFromDate:(NSDate *)date {
	NSDateComponents *components = nil;
	NSCalendar	*calendar = [NSCalendar currentCalendar];
	
	if (!date) {
		components = [calendar components:unitFlags fromDate:[NSDate date]];
		[components setHour:0];
		[components setMinute:0];
		[components setSecond:0];
	} else {
		components = [calendar components:unitFlags fromDate:date];
		[components setHour:0];
		[components setMinute:0];
		[components setSecond:0];
	}
	
	return components;
}


+ (id)stringFromDate:(NSDate *)date withNames:(BOOL)flag {
	
	if (![self isValidDueDate:date]) {
		return NSLocalizedString(@"NoDueDate_Loc", nil);
	}
	
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
	}
	
    if (flag) {
		NSCalendar	*calendar = [NSCalendar currentCalendar];
		
		NSDate *suppliedDate = [calendar dateFromComponents:[self componentsFromDate:date]];
		NSDate *referenceDate = [calendar dateFromComponents:[self componentsFromDate:nil]];
		NSDateComponents *comps = [self componentsFromDate:nil];
		
		if ([suppliedDate compare:referenceDate] == NSOrderedSame) 	{
			return [NSString stringWithString:NSLocalizedString(@"Today_Loc", nil)];
		}
		[comps setDay:[comps day] - 1];
		referenceDate = [calendar dateFromComponents:comps];
		if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
			return [NSString stringWithString:NSLocalizedString(@"Yesterday_Loc", nil)];
		}
		[comps setDay:[comps day] + 2];
		referenceDate = [calendar dateFromComponents:comps];
		if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
			return [NSString stringWithString:NSLocalizedString(@"Tomorrow_Loc", nil)];
		}
		return [formatter stringFromDate:date];
	}	
    return [formatter stringFromDate:date];
}

+ (NSComparisonResult)compareAgainstNow:(NSDate *)date {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
	NSDate *suppliedDate = [calendar dateFromComponents:[self componentsFromDate:date]];
	NSDate *today = [calendar dateFromComponents:[self componentsFromDate:nil]];
	
	return [suppliedDate compare:today];
}

+ (NSDate *)dateWithoutTimeFor:(NSDate *)aDate {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
	NSDate *newDate = [calendar dateFromComponents:[self componentsFromDate:aDate]];
	
	return newDate;
}

+ (NSDate *)todayDateWithoutTime {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
	NSDate *todayNoTime = [calendar dateFromComponents:[self componentsFromDate:nil]];
	
	return todayNoTime;
}

+ (NSDate *)dateByAddingOneMonth:(NSDate *)givenDate {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *date = [calendar dateByAddingComponents:comps toDate:givenDate options:0];
	[comps release];
	
    return date;
}

+ (NSDate *)dateForRepeatType:(NSInteger)repeat andDone:(NSDate *)doneDate {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	switch (repeat) {
		case 1: //Daily
			[comps setDay:1];
			break;
		case 2: //Weekly
			[comps setDay:7];
			break;
		case 3: //Monthly
			[comps setMonth:1];
			break;
		case 4: // 3 Monthly
			[comps setMonth:3];
			break;
		case 5: // 6 Monthly
			[comps setMonth:6];
			break;
		case 6: // Yearly
			[comps setYear:1];
			break;
		default:
			break;
	}
	NSDate *date = [calendar dateByAddingComponents:comps toDate:doneDate options:0];
	[comps release];
	
	return date;
}

+ (NSString *)currentDayOfMonth {
	unsigned unitDayFlag = NSDayCalendarUnit;
	NSCalendar	*calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:unitDayFlag fromDate:[NSDate date]];
	return [NSString stringWithFormat:@"%d", [comps day]];
}

+ (NSDate *)dateByAddingOneYear:(NSDate *)givenDate {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1];
    NSDate *date = [calendar dateByAddingComponents:comps toDate:givenDate options:0];
	[comps release];
	
    return date;
}

+ (NSDate *)noDueDate {
	NSCalendar	*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:01];
	[comps setMonth:01];
	[comps setYear:2100];
	[comps setHour:00];
	[comps setMinute:00];
	[comps setSecond:00];
	NSDate *date = [calendar dateFromComponents:comps];
	[comps release];
	
	return date;
}

+ (NSTimeInterval)timeIntervalFor:(NSDate *)aDate {
	return [aDate timeIntervalSinceReferenceDate];
}

+ (BOOL)isValidDueDate:(NSDate *)dueDate {
	if (dueDate == nil) {
		return NO;
	}
	if ([[self noDueDate] compare:dueDate] == NSOrderedSame) {
		return NO;
	} else {
		return YES;
	}
}

@end
