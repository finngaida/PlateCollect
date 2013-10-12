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

@interface FGDatabaseHandler : NSObject
//Läd die Datenbank automatisch mit (benutzt FMDatabase databaseWithPath:)
- (id)initWithDatabase;
-(BOOL)openDatabase;
-(BOOL)closeDatabase;

//provding content
-(NSArray*)stolpersteinsNearLocation:(CLLocation*)location amount:(NSInteger)amount; //Es fehlen noch ergebnisse aus deports table
-(FGStolperstein*)stolpersteinByID:(NSInteger)stID;

-(BOOL)isVisitingStolperstein:(FGStolperstein*)stone; //YES, wenn erfolgreiche Abfrage
-(BOOL)visitedStolperstein:(FGStolperstein*)stone;//YES, wenn besucht

@end
