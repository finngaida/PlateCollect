//
//  FGDatabaseHandler.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 09.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDatabaseHandler.h"
#import "FMDatabase.h"

@implementation FGDatabaseHandler {
    FMDatabase *db;
}

#pragma mark main required methods
- (id)init
{
    self = [super init];
    if (self) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"stolpersteine" ofType:@"sqlite"];
        db = [FMDatabase databaseWithPath:databasePath];
    }
    return self;
}
-(void)openDB {
    [db open];
}

-(void)closeDB {
    [db close];
}

#pragma mark providing content
-(NSArray*)stolpersteinsInRegion:(CLRegion*)region forAmount:(NSInteger)amount{
    NSMutableArray *stolpersteine;
    
    NSString *entryQuery = [NSString stringWithFormat:@"SELECT * FROM stolperstein WHERE stolperstein.stdID = %i ",amount];
    FMResultSet *entryResult = [db executeQuery:entryQuery];
    while([entryResult next]) {
        
    }
    
    return [stolpersteine copy];
-(NSMutableArray*)stolpersteinsInRegion:(CLRegion*)region {
    return [NSMutableArray new];
}

-(FGStolperstein*)stolpersteinByID:(NSInteger)stID {
    FGStolperstein *stone;
    
    //SQL-Abfrage (Es fehlt zb noch der JOIN)
    NSString *entryQuery = [NSString stringWithFormat:@"SELECT * FROM stolperstein WHERE stolperstein.stdID = %i ",stID];
    FMResultSet *entryResult = [db executeQuery:entryQuery];
    while([entryResult next]) {
        
        //Location in CLLocation umwandeln
        double lat = [entryResult doubleForColumn:@"latitude"];
        double longi = [entryResult doubleForColumn:@"longitude"];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
        
        //Deportations in Array einfügen (Fehlt)
        
        stone = [[FGStolperstein alloc] initWithFirst:[entryResult stringForColumn:@"firstname"]
                                                 last:[entryResult stringForColumn:@"lastname"]
                                                 born:[entryResult stringForColumn:@"birthname"]
                                             birthday:[entryResult stringForColumn:@"birthday"]
                                              address:[entryResult stringForColumn:@"adress"]
                                              quarter:[entryResult stringForColumn:@"neighbourhood"]
                                             location:location
                                         deportations:nil
                                      locationOfDeath:[entryResult stringForColumn:@"place_of_death"]
                                           dayOfDeath:[entryResult stringForColumn:@"day_of_death"]
                                           identifier:[NSString stringWithFormat:@"%i", stID]];
    }
    
    return stone;
}
@end
