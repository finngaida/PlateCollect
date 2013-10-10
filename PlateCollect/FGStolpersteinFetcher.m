//
//  FGStolpersteinFetcher.m
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGStolpersteinFetcher.h"
#import "FGDatabase.h"

@implementation FGStolpersteinFetcher

-(NSArray *)fetchNearestStonesAtLocation:(CLLocation *)location amount:(NSInteger)amount {
    FGDatabase *database = [[FGDatabase alloc] database];
    [database open];
    NSArray *stones = [database stolpersteinsNearLocation:location amount:amount];
    [database close];
    return stones;
}
@end
