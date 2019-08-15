//
//  MigrationDB.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 16/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Pet.h"
#import "Health.h"
#import "Weight.h"
#import "Event.h"

@interface MigrationDB : NSObject {
}

+ (BOOL)performDatabaseMigration:(int)oldDatabaseVersion;

@end
