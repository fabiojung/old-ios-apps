//
//  Type.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 06/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface Type : SQLitePersistentObject {
	NSString *label;
	NSInteger listorder;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) NSInteger listorder;
@end
