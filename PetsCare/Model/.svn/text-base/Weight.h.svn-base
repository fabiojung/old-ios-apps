//
//  Weight.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface Weight : SQLitePersistentObject {
	NSInteger petpk;
	NSNumber *weight;
	NSDate *date;
}

@property (nonatomic, assign) NSInteger petpk;
@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSDate *date;

@end

@interface Weight (squelch)
+ (id)sumOfWeightWithCriteria:(NSString *)criteria;
@end