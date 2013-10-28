//
//  FGStolpersteinFetcher.m
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGStolpersteinFetcher.h"
#import "FGDatabaseHandler.h"

@implementation FGStolpersteinFetcher

-(NSArray *)fetchNearestStonesAtLocation:(CLLocation *)location amount:(NSInteger)amount {
    FGDatabaseHandler *database = [[FGDatabaseHandler alloc] initWithDatabase];
    [database openDatabase];
    NSArray *stones = [database stolpersteinsNearLocation:location amount:(int)amount];
    NSLog(@"SQL return: %@", stones);
    [database closeDatabase];
    return stones;
}
@end
