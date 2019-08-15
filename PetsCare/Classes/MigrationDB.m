//
//  MigrationDB.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 16/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "MigrationDB.h"
#import "DateHelper.h"

@implementation MigrationDB

+ (BOOL)performDatabaseMigration:(int)oldDatabaseVersion {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	sqlite3 *oldDatabase;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"petdb.sqlite"];
	if (sqlite3_open([path UTF8String], &oldDatabase) != SQLITE_OK) {
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(oldDatabase));
		[pool drain];
		return NO;
	}
	const char *sql = "SELECT * FROM pet";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(oldDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Pet *pet = [[Pet alloc] init];
			char *name = (char *)sqlite3_column_text(statement, 1);
			pet.name = (name != NULL) ? [NSString stringWithUTF8String:name] : NSLocalizedString(@"NoName", nil);
			pet.born = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 2)];
			char *breed = (char *)sqlite3_column_text(statement, 3);
			pet.breed = (breed != NULL) ? [NSString stringWithUTF8String:breed] : NSLocalizedString(@"NoBreed", nil);
			char *color = (char *)sqlite3_column_text(statement, 4);
			pet.color = (color != NULL) ? [NSString stringWithUTF8String:color] : NSLocalizedString(@"NoColor", nil);
			char *gender = (char *)sqlite3_column_text(statement, 5);
			pet.gender = (gender != NULL) ? [NSString stringWithUTF8String:gender] : NSLocalizedString(@"NoGender", nil);
			int length = sqlite3_column_bytes(statement, 6);
			pet.photo = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(statement, 6) length:length]];
			
			if (oldDatabaseVersion == 2) {
				char *regnumber = (char *)sqlite3_column_text(statement, 7);
				pet.regnumber = (regnumber != NULL) ? [NSString stringWithUTF8String:regnumber] : @" ";
				char *chipnumber = (char *)sqlite3_column_text(statement, 8);
				pet.chipnumber = (chipnumber != NULL) ? [NSString stringWithUTF8String:chipnumber] : @" ";
				char *notes = (char *)sqlite3_column_text(statement, 9);
				pet.notes = (notes != NULL) ? [NSString stringWithUTF8String:notes] : @" ";			
			}
			
			[pet save];
			[pet release];
		}
	}
	[Pet clearCache];
	sqlite3_finalize(statement);
	statement = nil;
	
	sql = "SELECT * FROM vaccines";
	if (sqlite3_prepare_v2(oldDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSDate *nextdate = nil;
			Health *health = [[Health alloc] init];
			health.petpk = sqlite3_column_int(statement, 1);
			char *infotag = (char *)sqlite3_column_text(statement, 2);
			health.infotag = (infotag != NULL) ? [NSString stringWithUTF8String:infotag] : @" ";	
			health.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 3)];
			nextdate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 4)];
			char *type = (char *)sqlite3_column_text(statement, 5);
			health.type = (type != NULL) ? [NSString stringWithUTF8String:type] : @" ";	
			health.islate = 0;
			health.kindrepeat = 0;
			
			if ([DateHelper compareAgainstNow:health.date] == NSOrderedAscending) {
				health.donedate = health.date;
				health.isdone = 1;
			} else {
				health.isdone = 0;
			}
			
			[health save];
			
			if ([DateHelper compareAgainstNow:nextdate] != NSOrderedAscending) {
				// Create new based on nextDate
				Health *newHealth = [[Health alloc] init];
				[newHealth setPetpk:health.petpk];
				[newHealth setType:health.type];
				[newHealth setInfotag:health.infotag];
				[newHealth setDate:nextdate];
				[newHealth setIslate:0];
				[newHealth setKindrepeat:0];
				[newHealth setIsdone:0];
				[newHealth save];
				[newHealth release];
			}
			[health release];
		}
	}
	[Health clearCache];
	sqlite3_finalize(statement);
	statement = nil;
	
	sql = "SELECT * FROM events";
	if (sqlite3_prepare_v2(oldDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Event *event = [[Event alloc] init];
			event.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 0)];
			char *eventName = (char *)sqlite3_column_text(statement, 1);
			event.event = (eventName != NULL) ? [NSString stringWithUTF8String:eventName] : NSLocalizedString(@"Event", nil);
			event.petpk = sqlite3_column_int(statement, 3);
			event.islate = 0;
			event.kindrepeat = 0;
			
			if ([DateHelper compareAgainstNow:event.date] == NSOrderedAscending) {
				event.donedate = event.date;
				event.isdone = 1;
			} else {
				event.isdone = 0;
			}
			
			[event save];
			[event release];
		}
	}
	[Event clearCache];
	sqlite3_finalize(statement);
	statement = nil;
	
	sql = "SELECT * FROM weights";
	if (sqlite3_prepare_v2(oldDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Weight *weight = [[Weight alloc] init];
			weight.petpk = sqlite3_column_int(statement, 1);
			weight.weight = [NSNumber numberWithDouble:sqlite3_column_double(statement, 2)];
			weight.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 3)];
			
			[weight save];
			[weight release];
		}
	}
	sqlite3_finalize(statement);
	statement = nil;
	
	if (sqlite3_close(oldDatabase) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(oldDatabase));
		[pool drain];
		return NO;
	}
	[pool drain];
	return YES;
}

@end
