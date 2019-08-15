//
//  Estado.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 17/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Cidade;
@class DDD;

@interface Estado :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * siglaUF;
@property (nonatomic, retain) NSString * nomeUF;
@property (nonatomic, retain) NSSet* cidade;
@property (nonatomic, retain) NSSet* codigoDDD;

@end

@interface Estado (CoreDataGeneratedAccessors)
- (void)addCidadeObject:(Cidade *)value;
- (void)removeCidadeObject:(Cidade *)value;
- (void)addCidade:(NSSet *)value;
- (void)removeCidade:(NSSet *)value;

- (void)addCodigoDDDObject:(DDD *)value;
- (void)removeCodigoDDDObject:(DDD *)value;
- (void)addCodigoDDD:(NSSet *)value;
- (void)removeCodigoDDD:(NSSet *)value;

@end

