//
//  Pet.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 24/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface Pet : SQLitePersistentObject {
    NSString *name;
	NSString *breed;
	NSString *color;
	NSString *gender;
	NSString *regnumber;
	NSString *chipnumber;
	NSString *notes;
	NSString *vetname;
	NSDate *born;
    UIImage *photo;
	NSInteger vetid;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *breed;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *regnumber;
@property (nonatomic, copy) NSString *chipnumber;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *vetname;
@property (nonatomic, retain) NSDate *born;
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, assign) NSInteger vetid;

@end

@interface Pet (squelch)
+ (id)findByPk:(NSInteger)thePk;
@end