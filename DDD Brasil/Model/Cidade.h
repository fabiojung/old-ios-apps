//
//  Cidade.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 17/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DDD;
@class Estado;

@interface Cidade :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * nomeCidadeBusca;
@property (nonatomic, retain) NSString * nomeCidade;
@property (nonatomic, retain) NSString * nomeSection;
@property (nonatomic, retain) DDD * codigoDDD;
@property (nonatomic, retain) Estado * estado;

@end



