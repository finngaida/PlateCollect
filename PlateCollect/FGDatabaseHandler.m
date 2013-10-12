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
    FMDatabase *database;
}

//Source from http://www.thismuchiknow.co.uk/?p=71
#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

#pragma mark main required methods
- (id)initWithDatabase
{
    self = [super init];
    if (self) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"stolpersteine" ofType:@"sqlite"];
        database = [[FMDatabase alloc] initWithPath:databasePath];
        database.logsErrors = YES;
    }
    return self;
}

- (BOOL)openDatabase {
    BOOL ready = [database open];
    //Adds a function to calculate distances easily
    sqlite3_create_function([database sqliteHandle], "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
    return ready;
}

-(BOOL)closeDatabase {
    return [database close];
}

static void distanceFunc(sqlite3_context *context, int argc, sqlite3_value **argv)
{
    // check that we have four arguments (lat1, lon1, lat2, lon2)
    assert(argc == 4);
    // check that all four arguments are non-null
    if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
        sqlite3_result_null(context);
        return;
    }
    // get the four argument values
    double lat1 = sqlite3_value_double(argv[0]);
    double lon1 = sqlite3_value_double(argv[1]);
    double lat2 = sqlite3_value_double(argv[2]);
    double lon2 = sqlite3_value_double(argv[3]);
    // convert lat1 and lat2 into radians now, to avoid doing it twice below
    double lat1rad = DEG2RAD(lat1);
    double lat2rad = DEG2RAD(lat2);
    // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
    // 6378.1 is the approximate radius of the earth in kilometres
    sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
}

# pragma mark custom methods
-(FGStolperstein*)stolpersteinByID:(NSInteger)stID {
    return nil;
}

-(NSArray*)stolpersteinsNearLocation:(CLLocation*)location amount:(NSInteger)amount {
    //Current position
    double locLongitude = (double)location.coordinate.longitude;
    double locLatitude = (double)location.coordinate.latitude;

    //Stores stones
    NSMutableArray *stones = [[NSMutableArray alloc] init];
    
    //Basic Information and stone location
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM stolperstein JOIN location ON stolperstein.location_id = location.location_id ORDER BY distance(location.latitude, location.longitude, %f, %f) LIMIT %i ",locLatitude,locLongitude,amount];
    FMResultSet *result = [database executeQuery:query];
    
    //Add sql result as stolperstein object to array
    while([result next]) {
        CLLocation *stoneLocation = [[CLLocation alloc] initWithLatitude:[result doubleForColumn:@"latitude"]
                                                              longitude:[result doubleForColumn:@"longitude"]];
        
        FGStolperstein *stone = [[FGStolperstein alloc] initWithFirst:[result stringForColumn:@"firstname"]
                                                                 last:[result stringForColumn:@"lastname"]
                                                                 born:[result stringForColumn:@"birthname"]
                                                             birthday:[result stringForColumn:@"birthday"]
                                                              address:[result stringForColumn:@"adress"]
                                                              quarter:[result stringForColumn:@"neighbourhood"]
                                                             location:stoneLocation
                                                         deportations:nil
                                                      locationOfDeath:[result stringForColumn:@"place_of_death"]
                                                           dayOfDeath:[result stringForColumn:@"day_of_death"]
                                                           identifier:[result intForColumn:@"st_id"]
                                                              visited:(BOOL)[result intForColumn:@"visited"]];
        
        [stones addObject:stone];
    }
    return [stones copy];
}
-(BOOL)isVisitingStolperstein:(FGStolperstein*)stone {
    int st_id = stone.identifier;
    return [database executeUpdate:@"UPDATE location SET visited = 1 AND visited_timestamp = CURRENT_TIMESTAMP() WHERE location_id IN (SELECT location_id FROM stolperstein WHERE st_id = %i)",st_id];
}
-(BOOL)visitedStolperstein:(FGStolperstein*)stone {
    BOOL visited = NO;
    
    NSString *query = [NSString stringWithFormat:@"SELECT visited FROM location WHERE location.location_id IN (SELECT location_id FROM stolperstein WHERE st_id = %i)",stone.identifier];
    FMResultSet *result = [database executeQuery:query];
    
    while([result next]) {
        visited = (BOOL)[result intForColumn:@"visited"];
    }
    return visited;
}

@end
