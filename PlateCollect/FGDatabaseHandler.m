//
//  FGDatabaseHandler.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 09.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDatabaseHandler.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation FGDatabaseHandler

# pragma mark singleton variables for database queue
static FMDatabaseQueue *_queue;
static NSOperationQueue *_writeQueue;
static NSRecursiveLock *_writeQueueLock;

//Source:  http://www.thismuchiknow.co.uk/?p=71
#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

#pragma mark main required methods
- (id)initWithDatabase
{
    self = [super init];
    if (self) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[FGDatabaseHandler databasePath]];
        _writeQueue = [NSOperationQueue new];
        [_writeQueue setMaxConcurrentOperationCount:1];
        _writeQueueLock = [NSRecursiveLock new];
    }
    return self;
}

+(NSString*)databasePath {
    // If the database doesn't exist in the Documentes folder, it will be copied from the mainBundle.
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:@"stolpersteine.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"stolpersteine" ofType:@"sqlite"];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
    NSLog(@"path: %@",targetPath);
    return targetPath;
}

#pragma mark SQLite functions
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

# pragma mark query methods
-(FGStolperstein*)stolpersteinByID:(NSInteger)stID {
    __block FGStolperstein *stone = [[FGStolperstein alloc] init];
    [self readFromDatabase:^(FMDatabase *db) {
        
        NSDateFormatter *formatter = [FGStolperstein basicDateFormatter];
        
        //Get basic information
        NSString *basicInformationQuery = [NSString stringWithFormat:@"SELECT * FROM stolperstein JOIN location ON stolperstein.location_id = location.location_id WHERE stolperstein.st_id = %i", stID];
        FMResultSet *result = [db executeQuery:basicInformationQuery];
        while ([result next]) {
            CLLocation*stoneLocation = [[CLLocation alloc] initWithLatitude:[result doubleForColumn:@"latitude"]
                                                                  longitude:[result doubleForColumn:@"longitude"]];
            stone.location = stoneLocation;
            stone.firstName =  [result stringForColumn:@"firstname"];
            stone.lastName =  [result stringForColumn:@"lastname"];
            stone.bornName = [result stringForColumn:@"birthname"];
            stone.birthday = [formatter dateFromString:[result stringForColumn:@"birthday"]];
            stone.address = [result stringForColumn:@"adress"];
            stone.quarter = [result stringForColumn:@"neighbourhood"];
            stone.placeOfDeath = [result stringForColumn:@"place_of_death"];
            stone.dayOfDeath = [formatter dateFromString:[result stringForColumn:@"day_of_death"]];
            stone.identifier = [result intForColumn:@"st_id"];
            stone.visited = (BOOL)[result intForColumn:@"visited"];
        }
        
        //Get deportation information
        NSString *depQuery = [NSString stringWithFormat:@"SELECT * FROM deportation WHERE st_id = %i ORDER BY dep_index ASC",stID];
        NSMutableArray *deportations = [[NSMutableArray alloc] init];
        result = [db executeQuery:depQuery];
        while ([result next]) {
            NSDictionary *dictionary = @{@"place":[result stringForColumn:@"destination"],
                                         @"date":[formatter dateFromString:[result stringForColumn:@"date"]]};
            [deportations addObject:dictionary];
        }
        stone.deportations = [deportations copy];
        
        [result close];
    }];
    return stone;
}


-(FGStolperstein*)fullInformationForStolperstein:(FGStolperstein*)stolperstein {
    return [self stolpersteinByID:stolperstein.identifier];
}

-(NSArray*)stolpersteinsNearLocation:(CLLocation*)location amount:(NSInteger)amount {
    __block NSMutableArray *stones = [[NSMutableArray alloc] init];

    [self readFromDatabase:^(FMDatabase *db) {
        // Assign distance calculation function to sqlite db
        //sqlite3_create_function([db sqliteHandle], "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
        [db makeFunctionNamed:@"distance" maximumArguments:4 withBlock:^(sqlite3_context *context, int aargc, sqlite3_value **aargv){
            distanceFunc(context, aargc, aargv);
        }];
        db.logsErrors=YES;
        
        //Current position
        double locLongitude = (double)location.coordinate.longitude;
        double locLatitude = (double)location.coordinate.latitude;
        
        //Stores stones
        
        //Basic Information and stone location
        NSString *query = [NSString stringWithFormat:@"SELECT s.firstname, s.lastname, s.st_id, l.visited, l.longitude, l.latitude FROM stolperstein AS s JOIN location AS l ON s.location_id = l.location_id ORDER BY distance(l.latitude, l.longitude,%f, %f) LIMIT %i ",locLatitude,locLongitude,amount];
        FMResultSet *result = [db executeQuery:query];
        
        //Add sql result as stolperstein object to array
        while([result next]) {
            CLLocation*stoneLocation = [[CLLocation alloc] initWithLatitude:[result doubleForColumn:@"latitude"]
                                                                  longitude:[result doubleForColumn:@"longitude"]];
            
            FGStolperstein *stone = [[FGStolperstein alloc] initWithFirstname:[result stringForColumn:@"firstname"]
                                                                     lastname:[result stringForColumn:@"lastname"]
                                                                     location:stoneLocation
                                                                   identifier:[result intForColumn:@"st_id"]
                                                                      visited:(BOOL)[result intForColumn:@"visited"]];
            
            [stones addObject:stone];
        }
        [result close];
    }];
    
    return [stones copy];
}
-(void)isVisitingStolperstein:(FGStolperstein*)stone {
    [self writeToDatabase:^(FMDatabase *db) {
        int st_id = stone.identifier;
        [db executeUpdate:@"UPDATE location SET visited = 1 AND visited_timestamp = CURRENT_TIMESTAMP() WHERE location_id IN (SELECT location_id FROM stolperstein WHERE st_id = %i)",st_id];
    }];
}
-(BOOL)visitedStolperstein:(FGStolperstein*)stone {
    __block BOOL visited = NO;
    
    [self readFromDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT visited FROM location WHERE location.location_id IN (SELECT location_id FROM stolperstein WHERE st_id = %i)",stone.identifier];
        FMResultSet *result = [db executeQuery:query];
        
        while([result next]) {
            visited = (BOOL)[result intForColumn:@"visited"];
        }
        [result close];
    }];
    
    return visited;
}

# pragma mark Thread-safe read/write handlers
-(void)readFromDatabase:(void(^)(FMDatabase *db))block{
    [_writeQueueLock lock];
    [_queue inDatabase:block];
    [_writeQueueLock unlock];
}

- (void)writeToDatabase:(void(^)(FMDatabase *db))block {
    [_writeQueue addOperationWithBlock:^{
        [_writeQueueLock lock];
        [_queue inDatabase:block];
        [_writeQueueLock unlock];
    }];
}

@end