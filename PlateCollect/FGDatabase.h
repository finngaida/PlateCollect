//
//  FGDatabaseHandler.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 09.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGStolperstein.h"
#import "FMDatabase.h"

@interface FGDatabase : FMDatabase
//Läd die Datenbank automatisch mit (benutzt FMDatabase databaseWithPath:)
-(instancetype)database;

//provding content
-(NSArray*)stolpersteinsInRegion:(CLRegion*)region forAmount:(NSInteger)amount;
-(FGStolperstein*)stolpersteinByID:(NSInteger)stID;

@end
