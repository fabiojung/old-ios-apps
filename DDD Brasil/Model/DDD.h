//
//  DDD.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 17/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Cidade;
@class Estado;

@interface DDD :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * numeroDDD;
@property (nonatomic, retain) NSSet* estado;
@property (nonatomic, retain) NSSet* cidade;

@end


@interface DDD (CoreDataGeneratedAccessors)
- (void)addEstadoObject:(Estado *)value;
- (void)removeEstadoObject:(Estado *)value;
- (void)addEstado:(NSSet *)value;
- (void)removeEstado:(NSSet *)value;

- (void)addCidadeObject:(Cidade *)value;
- (void)removeCidadeObject:(Cidade *)value;
- (void)addCidade:(NSSet *)value;
- (void)removeCidade:(NSSet *)value;

@end

