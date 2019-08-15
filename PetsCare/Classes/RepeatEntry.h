//
//  RepeatEntry.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 02/06/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Health.h"

@interface RepeatEntry : NSObject {
}

- (void)createRecurrentEventFor:(Event *)event;
- (void)createRecurrentHealthFor:(Health *)health;

@end
