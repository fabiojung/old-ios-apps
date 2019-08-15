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
+ (NSString *)petAgeFromBornDate:(NSDate *)date;
+ (NSDate *)newDateForRepeatType:(NSInteger)repeat andDone:(NSDate *)date;
@end
