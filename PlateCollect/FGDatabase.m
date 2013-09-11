//
//  FGDatabaseHandler.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 09.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDatabase.h"
#import "FMDatabase.h"

@implementation FGDatabase

#pragma mark main required methods
- (instancetype)database
{
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"stolpersteine" ofType:@"sqlite"];
        return (FGDatabase*)[FMDatabase databaseWithPath:databasePath];
}


#pragma mark providing content
-(NSArray*)stolpersteinsInRegion:(CLRegion*)region forAmount:(NSInteger)amount{
    NSMutableArray *stolpersteine;
    
    NSString *entryQuery = [NSString stringWithFormat:@"SELECT * FROM stolperstein WHERE stolperstein.stdID = %i ",amount];
    FMResultSet *entryResult = [super executeQuery:entryQuery];
    while([entryResult next]) {
        
    }
    
    return [stolpersteine copy];
}
-(FGStolperstein*)stolpersteinByID:(NSInteger)stID {
    FGStolperstein *stone;
    
    //SQL-Abfrage (Es fehlt zb noch der JOIN)
    NSString *entryQuery = [NSString stringWithFormat:@"SELECT * FROM stolperstein WHERE stolperstein.stdID = %i ",stID];
    FMResultSet *entryResult = [super executeQuery:entryQuery];
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
