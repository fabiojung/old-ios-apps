//
//  DateHelper.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 05/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject {
}

+ (id)stringFromDate:(NSDate *)date withNames:(BOOL)flag;
+ (NSComparisonResult)compareAgainstNow:(NSDate *)date;
+ (NSDate *)dateForRepeatType:(NSInteger)repeat andDone:(NSDate *)doneDate;
+ (NSString *)currentDayOfMonth;
+ (NSDate *)todayDateWithoutTime;
+ (NSDate *)dateWithoutTimeFor:(NSDate *)aDate;
+ (NSDate *)dateByAddingOneMonth:(NSDate *)givenDate;
+ (NSDate *)dateByAddingOneYear:(NSDate *)givenDate;
+ (NSDate *)noDueDate;
+ (NSTimeInterval)timeIntervalFor:(NSDate *)aDate;
+ (BOOL)isValidDueDate:(NSDate *)dueDate;
@end
