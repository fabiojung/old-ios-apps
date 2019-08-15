//
//  Health.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface Health : SQLitePersistentObject {
	NSInteger petpk;
    NSString *infotag;
	NSString *type;
    NSDate *date;
    NSDate *donedate;
	NSInteger isdone;
	NSInteger islate;
	NSInteger kindrepeat;
	NSInteger repeatoff;
}

@property (nonatomic, assign) NSInteger petpk;
@property (nonatomic, copy) NSString *infotag;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *donedate;
@property (nonatomic) NSInteger isdone;
@property (nonatomic) NSInteger islate;
@property (nonatomic) NSInteger kindrepeat;
@property (nonatomic) NSInteger repeatoff;

@end
